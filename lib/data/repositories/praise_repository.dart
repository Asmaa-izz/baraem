import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../../core/utils/media_store.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';

/// Manages encouragement clips (parent-facing). Soft-delete via [setEnabled];
/// [resetPraises] restores the system defaults and removes parent recordings.
abstract class PraiseRepository {
  Stream<List<Praise>> watchPraises();
  Future<List<Praise>> getEnabledPraises();
  Future<void> setEnabled(String id, bool enabled);
  Future<Praise> addUserPraise({required String label, required String audioPath});
  Future<void> resetPraises();
}

class DriftPraiseRepository implements PraiseRepository {
  DriftPraiseRepository(this.db);

  final AppDatabase db;

  @override
  Stream<List<Praise>> watchPraises() {
    final query = db.select(db.praises)
      ..orderBy([(p) => OrderingTerm.asc(p.source), (p) => OrderingTerm.asc(p.id)]);
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Praise>> getEnabledPraises() async {
    final rows = await (db.select(db.praises)
          ..where((p) => p.enabled.equals(true)))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    await (db.update(db.praises)..where((p) => p.id.equals(id)))
        .write(PraisesCompanion(enabled: Value(enabled)));
  }

  @override
  Future<Praise> addUserPraise({
    required String label,
    required String audioPath,
  }) async {
    final id = newId();
    await db.into(db.praises).insert(
          PraisesCompanion.insert(
            id: id,
            label: label,
            audioPath: audioPath,
            source: ContentSource.user,
          ),
        );
    final row =
        await (db.select(db.praises)..where((p) => p.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<void> resetPraises() async {
    // Remove parent recordings (rows + files); re-enable all system clips.
    final userRows = await (db.select(db.praises)
          ..where((p) => p.source.equalsValue(ContentSource.user)))
        .get();
    for (final row in userRows) {
      await deleteMediaFile(row.audioPath);
    }
    await (db.delete(db.praises)
          ..where((p) => p.source.equalsValue(ContentSource.user)))
        .go();
    await (db.update(db.praises)
          ..where((p) => p.source.equalsValue(ContentSource.system)))
        .write(const PraisesCompanion(enabled: Value(true)));
  }
}
