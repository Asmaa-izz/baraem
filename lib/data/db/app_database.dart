import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../models/enums.dart';
import 'connection.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Items,
    Exemplars,
    ChildProfiles,
    LearningStates,
    Sessions,
    TrialLogs,
    AppSettings,
    Praises,
    Sounds,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  /// Store dates as ISO-8601 UTC text so `nextDue <= now` comparisons are
  /// lexicographically correct and identical across web/native.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(items, items.speech);
            await m.addColumn(items, items.audioPath);
          }
          if (from < 3) {
            await m.createTable(praises);
          }
          if (from < 4) {
            await m.addColumn(items, items.orderIndex);
          }
          if (from < 5) {
            // Multi-voice audio: clips move from the single Items.audioPath /
            // Praises.audioPath into the polymorphic Sounds table. System voices
            // are re-created by the seeder; here we preserve only parent content.
            await m.createTable(sounds);

            // Parent-recorded item audio (non-asset paths) → user Sounds.
            final userItemAudio = await (select(items)
                  ..where((i) => i.audioPath.isNotNull()))
                .get();
            for (final row in userItemAudio) {
              final path = row.audioPath;
              if (path == null || path.startsWith('assets/')) continue;
              await into(sounds).insert(SoundsCompanion.insert(
                id: newId(),
                ownerType: SoundOwner.item,
                ownerId: row.id,
                audioPath: path,
                source: ContentSource.user,
              ));
            }

            // Parent-added praise clips → user Sounds (read the old column via
            // raw SQL since it's dropped from the Dart schema below).
            final userPraise = await customSelect(
              "SELECT id, audio_path FROM praises WHERE source = 'user'",
            ).get();
            for (final row in userPraise) {
              await into(sounds).insert(SoundsCompanion.insert(
                id: newId(),
                ownerType: SoundOwner.praise,
                ownerId: row.read<String>('id'),
                audioPath: row.read<String>('audio_path'),
                source: ContentSource.user,
              ));
            }

            // Drop the now-unused Praises.audioPath (safe rebuild — no inbound
            // FKs). Items.audioPath is left in place to avoid rebuilding the
            // FK-heavy items table; it's simply no longer read.
            await m.alterTable(TableMigration(praises));
          }
          if (from < 6) {
            await m.addColumn(childProfiles, childProfiles.rounds);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---- key/value settings helpers ----

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)
          ..where((t) => t.settingKey.equals(key)))
        .getSingleOrNull();
    return row?.settingValue;
  }

  Future<int?> getSettingInt(String key) async {
    final v = await getSetting(key);
    return v == null ? null : int.tryParse(v);
  }

  Future<void> setSetting(String key, String value) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(settingKey: key, settingValue: value),
    );
  }
}
