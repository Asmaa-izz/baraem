import 'package:drift/drift.dart';

import '../models/enums.dart';

/// Drift schema for Baraem, mirroring PRD §9. Generated data classes are named
/// `*Row` (via [DataClassName]) to avoid clashing with the plain domain models
/// in `../models/domain.dart`.

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get orderIndex => integer()(); // 'order' is SQL-reserved
  TextColumn get source => textEnum<ContentSource>()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ItemRow')
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get categoryId => text().references(Categories, #id)();

  /// Vocalized (diacritized) form for clearer TTS; null falls back to [label].
  TextColumn get speech => text().nullable()();

  /// Per-item audio: a bundled asset (system) or a recorded file (user); null
  /// falls back to TTS.
  TextColumn get audioPath => text().nullable()();
  TextColumn get source => textEnum<ContentSource>()();

  /// Curated introduction order within the category (drives the growing active
  /// window). Items surface in this order, not alphabetical-by-id.
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExemplarRow')
@TableIndex(name: 'idx_exemplar_item', columns: {#itemId})
class Exemplars extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id)();
  TextColumn get imagePath => text()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  /// Whether the image asset actually shipped (set at seed via AssetManifest).
  BoolColumn get hasImage => boolean().withDefault(const Constant(false))();
  TextColumn get source => textEnum<ContentSource>()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ChildProfileRow')
class ChildProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text()();
  TextColumn get mode => textEnum<ProfileMode>()();
  IntColumn get choicesCount => integer().withDefault(const Constant(2))();
  IntColumn get sessionLength => integer().withDefault(const Constant(12))();
  IntColumn get activeWindowSize => integer().withDefault(const Constant(5))();
  IntColumn get masteryThreshold => integer().withDefault(const Constant(3))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LearningStateRow')
@TableIndex(name: 'idx_ls_child_item', unique: true, columns: {#childId, #itemId})
@TableIndex(name: 'idx_ls_due', columns: {#childId, #status, #nextDue})
class LearningStates extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().references(ChildProfiles, #id)();
  TextColumn get itemId => text().references(Items, #id)();
  TextColumn get status => textEnum<ItemStatus>()();
  IntColumn get leitnerBox => integer().withDefault(const Constant(1))();
  IntColumn get consecutiveCorrect => integer().withDefault(const Constant(0))();
  IntColumn get timesSeen => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSeen => dateTime().nullable()();
  DateTimeColumn get nextDue => dateTime().nullable()();
  TextColumn get lastExemplarId => text().nullable()();
  DateTimeColumn get admittedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SessionRow')
@TableIndex(name: 'idx_session_child', columns: {#childId, #startedAt})
class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().references(ChildProfiles, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get itemsSeen => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TrialLogRow')
@TableIndex(name: 'idx_trial_child_time', columns: {#childId, #timestamp})
@TableIndex(name: 'idx_trial_session', columns: {#sessionId})
class TrialLogs extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().references(ChildProfiles, #id)();
  TextColumn get sessionId => text().references(Sessions, #id)();
  TextColumn get itemId => text().references(Items, #id)(); // target
  TextColumn get chosenItemId => text().references(Items, #id)();
  BoolColumn get correct => boolean()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get exemplarId => text().nullable()();
  IntColumn get choicesCount => integer().withDefault(const Constant(2))();
  BoolColumn get isRetry => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Simple key/value store for app-level settings: hashed parent PIN,
/// seed_version, mute flag, theme override (PRD §14).
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

/// Encouragement clips played on a correct answer. Managed by the parent:
/// [enabled] false is a soft delete (hidden from playback, restorable);
/// [source] user rows are parent-recorded and removed on reset-to-defaults.
@DataClassName('PraiseRow')
class Praises extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get audioPath => text()(); // asset (system) or file path (user)
  TextColumn get source => textEnum<ContentSource>()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
