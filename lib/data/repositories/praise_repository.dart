import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../../core/utils/media_store.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';

/// Manages encouragement *words* (parent-facing). Each word's voice clips live
/// in the Sounds table (see [SoundRepository]). Soft-delete a word via
/// [setEnabled]; [resetPraises] restores the system defaults and removes all
/// parent additions (words + recorded voice clips).
abstract class PraiseRepository {
  Stream<List<Praise>> watchPraises();
  Future<List<Praise>> getEnabledPraises();
  Future<void> setEnabled(String id, bool enabled);
  Future<Praise> addUserPraiseWord({required String label});
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
  Future<Praise> addUserPraiseWord({required String label}) async {
    final id = newId();
    await db.into(db.praises).insert(
          PraisesCompanion.insert(
            id: id,
            label: label,
            source: ContentSource.user,
          ),
        );
    final row =
        await (db.select(db.praises)..where((p) => p.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<void> resetPraises() async {
    // Remove parent-recorded praise voice clips (files + rows).
    final userSounds = await (db.select(db.sounds)
          ..where((s) =>
              s.ownerType.equalsValue(SoundOwner.praise) &
              s.source.equalsValue(ContentSource.user)))
        .get();
    for (final s in userSounds) {
      if (!s.audioPath.startsWith('data:')) await deleteMediaFile(s.audioPath);
    }
    await (db.delete(db.sounds)
          ..where((s) =>
              s.ownerType.equalsValue(SoundOwner.praise) &
              s.source.equalsValue(ContentSource.user)))
        .go();

    // Remove parent-added praise words.
    await (db.delete(db.praises)
          ..where((p) => p.source.equalsValue(ContentSource.user)))
        .go();

    // Re-enable all system praise words and their system voice clips.
    await (db.update(db.praises)
          ..where((p) => p.source.equalsValue(ContentSource.system)))
        .write(const PraisesCompanion(enabled: Value(true)));
    await (db.update(db.sounds)
          ..where((s) =>
              s.ownerType.equalsValue(SoundOwner.praise) &
              s.source.equalsValue(ContentSource.system)))
        .write(const SoundsCompanion(enabled: Value(true)));
  }
}
