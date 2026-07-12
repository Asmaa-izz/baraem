import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';

/// Dumb data access for the learning engine — no algorithm lives here.
abstract class LearningRepository {
  Future<LearningState?> getState(String childId, String itemId);

  /// Every state for the child, any status (including archived). Used by the
  /// active-window admission to know which items have already been introduced.
  Future<List<LearningState>> getStates(String childId);
  Future<List<LearningState>> getActiveStates(String childId);
  Future<List<LearningState>> getDueStates(String childId, DateTime now);
  Future<int> countActive(String childId);
  Future<LearningState> initState(String childId, String itemId, DateTime now);
  Future<void> upsertState(LearningState state);

  /// The next item with no learning state yet; prefers [preferCategoryId],
  /// then falls through categories by order. Null when content is exhausted.
  Future<Item?> pickNewCandidate(String childId, {String? preferCategoryId});

  Future<SessionInfo> startSession(String childId, DateTime now);
  Future<void> endSession(
    String sessionId,
    DateTime now, {
    required int itemsSeen,
    required int correctCount,
  });
  Future<void> logTrial(TrialLog trial);
}

class DriftLearningRepository implements LearningRepository {
  DriftLearningRepository(this.db);

  final AppDatabase db;

  @override
  Future<LearningState?> getState(String childId, String itemId) async {
    final row = await (db.select(db.learningStates)
          ..where((t) => t.childId.equals(childId) & t.itemId.equals(itemId)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<LearningState>> getStates(String childId) async {
    final rows = await (db.select(db.learningStates)
          ..where((t) => t.childId.equals(childId)))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<LearningState>> getActiveStates(String childId) async {
    final rows = await (db.select(db.learningStates)
          ..where((t) =>
              t.childId.equals(childId) &
              t.status.equalsValue(ItemStatus.archived).not()))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<LearningState>> getDueStates(String childId, DateTime now) async {
    final rows = await (db.select(db.learningStates)
          ..where((t) =>
              t.childId.equals(childId) &
              t.status.equalsValue(ItemStatus.archived).not() &
              t.nextDue.isSmallerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDue)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<int> countActive(String childId) async {
    final states = await getActiveStates(childId);
    return states.length;
  }

  @override
  Future<LearningState> initState(
    String childId,
    String itemId,
    DateTime now,
  ) async {
    final id = newId();
    await db.into(db.learningStates).insert(
          LearningStatesCompanion.insert(
            id: id,
            childId: childId,
            itemId: itemId,
            status: ItemStatus.isNew,
            leitnerBox: const Value(1),
            nextDue: Value(now),
            admittedAt: Value(now),
          ),
        );
    return (await getState(childId, itemId))!;
  }

  @override
  Future<void> upsertState(LearningState s) async {
    await db.into(db.learningStates).insertOnConflictUpdate(
          LearningStatesCompanion(
            id: Value(s.id),
            childId: Value(s.childId),
            itemId: Value(s.itemId),
            status: Value(s.status),
            leitnerBox: Value(s.leitnerBox),
            consecutiveCorrect: Value(s.consecutiveCorrect),
            timesSeen: Value(s.timesSeen),
            lastSeen: Value(s.lastSeen),
            nextDue: Value(s.nextDue),
            lastExemplarId: Value(s.lastExemplarId),
            admittedAt: Value(s.admittedAt),
          ),
        );
  }

  @override
  Future<Item?> pickNewCandidate(
    String childId, {
    String? preferCategoryId,
  }) async {
    final cats = await (db.select(db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
        .get();
    final ordered = <CategoryRow>[
      if (preferCategoryId != null) ...cats.where((c) => c.id == preferCategoryId),
      ...cats.where((c) => c.id != preferCategoryId),
    ];

    for (final cat in ordered) {
      final query = db.select(db.items).join([
        leftOuterJoin(
          db.learningStates,
          db.learningStates.itemId.equalsExp(db.items.id) &
              db.learningStates.childId.equals(childId),
        ),
      ])
        ..where(db.items.categoryId.equals(cat.id) &
            db.learningStates.id.isNull())
        ..orderBy([
          OrderingTerm.asc(db.items.orderIndex),
          OrderingTerm.asc(db.items.id),
        ])
        ..limit(1);
      final row = await query.getSingleOrNull();
      if (row != null) return row.readTable(db.items).toDomain();
    }
    return null;
  }

  @override
  Future<SessionInfo> startSession(String childId, DateTime now) async {
    final id = newId();
    await db.into(db.sessions).insert(
          SessionsCompanion.insert(id: id, childId: childId, startedAt: now),
        );
    final row =
        await (db.select(db.sessions)..where((s) => s.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<void> endSession(
    String sessionId,
    DateTime now, {
    required int itemsSeen,
    required int correctCount,
  }) async {
    await (db.update(db.sessions)..where((s) => s.id.equals(sessionId))).write(
      SessionsCompanion(
        endedAt: Value(now),
        itemsSeen: Value(itemsSeen),
        correctCount: Value(correctCount),
      ),
    );
  }

  @override
  Future<void> logTrial(TrialLog t) async {
    await db.into(db.trialLogs).insert(
          TrialLogsCompanion.insert(
            id: t.id,
            childId: t.childId,
            sessionId: t.sessionId,
            itemId: t.itemId,
            chosenItemId: t.chosenItemId,
            correct: t.correct,
            timestamp: t.timestamp,
            choicesCount: Value(t.choicesCount),
            exemplarId: Value(t.exemplarId),
            isRetry: Value(t.isRetry),
          ),
        );
  }
}
