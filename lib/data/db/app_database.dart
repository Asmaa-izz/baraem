import 'package:drift/drift.dart';

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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  /// In-memory database for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

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
