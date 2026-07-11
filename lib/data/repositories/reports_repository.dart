import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/enums.dart';
import '../models/reports.dart';

/// Read-side aggregates for the parent dashboard. Data volumes are tiny
/// (one child, tens of items), so aggregation happens in Dart for clarity.
abstract class ReportsRepository {
  Future<ProgressSummary> getSummary(String childId);
  Future<int> masteredThisWeek(String childId, DateTime now);
  Future<List<DailyAccuracy>> accuracyOverTime(String childId, {int days = 30});
  Future<List<ItemProgress>> perItemProgress(String childId);
}

class DriftReportsRepository implements ReportsRepository {
  DriftReportsRepository(this.db);

  final AppDatabase db;

  @override
  Future<ProgressSummary> getSummary(String childId) async {
    final states = await (db.select(db.learningStates)
          ..where((t) => t.childId.equals(childId)))
        .get();
    var n = 0, l = 0, m = 0, a = 0;
    for (final s in states) {
      switch (s.status) {
        case ItemStatus.isNew:
          n++;
        case ItemStatus.learning:
          l++;
        case ItemStatus.mastered:
          m++;
        case ItemStatus.archived:
          a++;
      }
    }
    // First-attempt trials only (retries excluded) for a fair accuracy figure.
    final trials = await (db.select(db.trialLogs)
          ..where((t) => t.childId.equals(childId) & t.isRetry.equals(false)))
        .get();
    final correct = trials.where((t) => t.correct).length;
    return ProgressSummary(
      newCount: n,
      learning: l,
      mastered: m,
      archived: a,
      totalTrials: trials.length,
      correctTrials: correct,
    );
  }

  @override
  Future<int> masteredThisWeek(String childId, DateTime now) async {
    final weekAgo = now.subtract(const Duration(days: 7));
    final states = await (db.select(db.learningStates)
          ..where((t) =>
              t.childId.equals(childId) &
              (t.status.equalsValue(ItemStatus.mastered) |
                  t.status.equalsValue(ItemStatus.archived)) &
              t.lastSeen.isBiggerOrEqualValue(weekAgo)))
        .get();
    return states.length;
  }

  @override
  Future<List<DailyAccuracy>> accuracyOverTime(
    String childId, {
    int days = 30,
  }) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final trials = await (db.select(db.trialLogs)
          ..where((t) =>
              t.childId.equals(childId) &
              t.isRetry.equals(false) &
              t.timestamp.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();

    final byDay = <DateTime, List<bool>>{};
    for (final t in trials) {
      final day = DateTime(t.timestamp.year, t.timestamp.month, t.timestamp.day);
      byDay.putIfAbsent(day, () => []).add(t.correct);
    }
    final result = byDay.entries.map((e) {
      final correct = e.value.where((c) => c).length;
      return DailyAccuracy(day: e.key, total: e.value.length, correct: correct);
    }).toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    return result;
  }

  @override
  Future<List<ItemProgress>> perItemProgress(String childId) async {
    final states = await (db.select(db.learningStates)
          ..where((t) => t.childId.equals(childId)))
        .get();
    if (states.isEmpty) return [];

    final items = await db.select(db.items).get();
    final itemById = {for (final i in items) i.id: i};

    final trials = await (db.select(db.trialLogs)
          ..where((t) => t.childId.equals(childId) & t.isRetry.equals(false)))
        .get();
    final correctByItem = <String, int>{};
    final totalByItem = <String, int>{};
    for (final t in trials) {
      totalByItem[t.itemId] = (totalByItem[t.itemId] ?? 0) + 1;
      if (t.correct) correctByItem[t.itemId] = (correctByItem[t.itemId] ?? 0) + 1;
    }

    final result = <ItemProgress>[];
    for (final s in states) {
      final item = itemById[s.itemId];
      if (item == null) continue;
      result.add(ItemProgress(
        itemId: s.itemId,
        label: item.label,
        categoryId: item.categoryId,
        status: s.status,
        leitnerBox: s.leitnerBox,
        timesSeen: s.timesSeen,
        correct: correctByItem[s.itemId] ?? 0,
        total: totalByItem[s.itemId] ?? 0,
      ));
    }
    result.sort((a, b) => b.leitnerBox.compareTo(a.leitnerBox));
    return result;
  }
}
