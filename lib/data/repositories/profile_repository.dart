import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';

abstract class ProfileRepository {
  Stream<List<ChildProfile>> watchProfiles();
  Future<List<ChildProfile>> getProfiles();
  Future<ChildProfile?> getProfile(String id);
  Future<ChildProfile> createProfile({
    required String name,
    required String avatar,
    required ProfileMode mode,
  });
  Future<void> updateProfile(ChildProfile profile);
  Future<void> deleteProfile(String id);
}

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this.db);

  final AppDatabase db;

  @override
  Stream<List<ChildProfile>> watchProfiles() {
    return db.select(db.childProfiles).watch().map(
          (rows) => rows.map((r) => r.toDomain()).toList(),
        );
  }

  @override
  Future<List<ChildProfile>> getProfiles() async {
    final rows = await db.select(db.childProfiles).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<ChildProfile?> getProfile(String id) async {
    final row = await (db.select(db.childProfiles)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<ChildProfile> createProfile({
    required String name,
    required String avatar,
    required ProfileMode mode,
  }) async {
    // Support mode starts gentler: shorter sessions.
    final sessionLength = mode == ProfileMode.support ? 8 : 12;
    final id = newId();
    await db.into(db.childProfiles).insert(
          ChildProfilesCompanion.insert(
            id: id,
            name: name,
            avatar: avatar,
            mode: mode,
            sessionLength: Value(sessionLength),
          ),
        );
    return (await getProfile(id))!;
  }

  @override
  Future<void> updateProfile(ChildProfile p) async {
    await (db.update(db.childProfiles)..where((t) => t.id.equals(p.id))).write(
      ChildProfilesCompanion(
        name: Value(p.name),
        avatar: Value(p.avatar),
        mode: Value(p.mode),
        choicesCount: Value(p.choicesCount),
        sessionLength: Value(p.sessionLength),
        activeWindowSize: Value(p.activeWindowSize),
        masteryThreshold: Value(p.masteryThreshold),
      ),
    );
  }

  @override
  Future<void> deleteProfile(String id) async {
    await db.transaction(() async {
      await (db.delete(db.trialLogs)..where((t) => t.childId.equals(id))).go();
      await (db.delete(db.sessions)..where((t) => t.childId.equals(id))).go();
      await (db.delete(db.learningStates)..where((t) => t.childId.equals(id)))
          .go();
      await (db.delete(db.childProfiles)..where((t) => t.id.equals(id))).go();
    });
  }
}
