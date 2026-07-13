import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../../core/utils/media_store.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';

/// Manages the voice clips of an item or a praise word (the unified store behind
/// both the content tab and the encouragement manager). System clips soft-delete
/// via [setEnabled] (restorable, survive re-seed); user clips hard-delete via
/// [deleteUserSound] (row + file removed).
abstract class SoundRepository {
  Stream<List<Sound>> watchSounds(SoundOwner ownerType, String ownerId);
  Future<List<Sound>> getEnabledSounds(SoundOwner ownerType, String ownerId);
  Future<Sound> addUserSound({
    required SoundOwner ownerType,
    required String ownerId,
    String? label,
    required String audioPath,
  });
  Future<void> setEnabled(String id, bool enabled);

  /// Hard-delete a parent-added clip (its file too). System clips must use
  /// [setEnabled] instead — their asset can't be removed and re-seeding restores
  /// the row anyway.
  Future<void> deleteUserSound(String id);
}

class DriftSoundRepository implements SoundRepository {
  DriftSoundRepository(this.db);

  final AppDatabase db;

  @override
  Stream<List<Sound>> watchSounds(SoundOwner ownerType, String ownerId) {
    final query = db.select(db.sounds)
      ..where((s) =>
          s.ownerType.equalsValue(ownerType) & s.ownerId.equals(ownerId))
      ..orderBy([
        (s) => OrderingTerm.asc(s.source),
        (s) => OrderingTerm.asc(s.orderIndex),
        (s) => OrderingTerm.asc(s.id),
      ]);
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Sound>> getEnabledSounds(
      SoundOwner ownerType, String ownerId) async {
    final rows = await (db.select(db.sounds)
          ..where((s) =>
              s.ownerType.equalsValue(ownerType) &
              s.ownerId.equals(ownerId) &
              s.enabled.equals(true)))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Sound> addUserSound({
    required SoundOwner ownerType,
    required String ownerId,
    String? label,
    required String audioPath,
  }) async {
    final id = newId();
    await db.into(db.sounds).insert(
          SoundsCompanion.insert(
            id: id,
            ownerType: ownerType,
            ownerId: ownerId,
            label: Value(label),
            audioPath: audioPath,
            source: ContentSource.user,
          ),
        );
    final row =
        await (db.select(db.sounds)..where((s) => s.id.equals(id))).getSingle();
    return row.toDomain();
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    await (db.update(db.sounds)..where((s) => s.id.equals(id)))
        .write(SoundsCompanion(enabled: Value(enabled)));
  }

  @override
  Future<void> deleteUserSound(String id) async {
    final row = await (db.select(db.sounds)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    // Only parent recordings own a deletable file; assets stay bundled.
    if (row.source == ContentSource.user && !row.audioPath.startsWith('data:')) {
      await deleteMediaFile(row.audioPath);
    }
    await (db.delete(db.sounds)..where((s) => s.id.equals(id))).go();
  }
}
