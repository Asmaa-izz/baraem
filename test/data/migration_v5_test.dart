// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

/// Verifies the schema 4 → 5 upgrade: parent-recorded item/praise audio moves
/// into the new Sounds table, system audio is left for the seeder, and the
/// legacy Praises.audioPath column is dropped.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('baraem_mig');
    file = File('${dir.path}/v4.sqlite');

    // Hand-build a minimal v4 database (only the tables the migration touches).
    final raw = sqlite3.open(file.path);
    raw.execute('''
      CREATE TABLE categories (id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL,
        icon TEXT NOT NULL, order_index INTEGER NOT NULL, source TEXT NOT NULL);
      CREATE TABLE items (id TEXT NOT NULL PRIMARY KEY, label TEXT NOT NULL,
        category_id TEXT NOT NULL REFERENCES categories(id), speech TEXT,
        audio_path TEXT, source TEXT NOT NULL, order_index INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE praises (id TEXT NOT NULL PRIMARY KEY, label TEXT NOT NULL,
        audio_path TEXT NOT NULL, source TEXT NOT NULL,
        enabled INTEGER NOT NULL DEFAULT 1);
      INSERT INTO categories VALUES ('fruits','فواكه','🍎',0,'system');
      INSERT INTO items (id,label,category_id,source,audio_path)
        VALUES ('apple','تفاحة','fruits','user','/data/media/apple.m4a');
      INSERT INTO items (id,label,category_id,source,audio_path)
        VALUES ('banana','موز','fruits','system','assets/content/fruits/banana/audio/sana.mp3');
      INSERT INTO praises (id,label,audio_path,source)
        VALUES ('shater','شاطر','assets/content/praise/shater.mp3','system');
      INSERT INTO praises (id,label,audio_path,source)
        VALUES ('u1','برافو','/data/media/bravo.m4a','user');
      PRAGMA user_version = 4;
    ''');
    raw.close();
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('upgrade 4→5 migrates only parent audio into Sounds', () async {
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final sounds = await db.select(db.sounds).get();

    // Parent item recording migrated; system asset item left for the seeder.
    final itemSounds =
        sounds.where((s) => s.ownerType == SoundOwner.item).toList();
    expect(itemSounds.length, 1);
    expect(itemSounds.single.ownerId, 'apple');
    expect(itemSounds.single.audioPath, '/data/media/apple.m4a');
    expect(itemSounds.single.source, ContentSource.user);

    // Parent praise clip migrated; system praise clip left for the seeder.
    final praiseSounds =
        sounds.where((s) => s.ownerType == SoundOwner.praise).toList();
    expect(praiseSounds.length, 1);
    expect(praiseSounds.single.ownerId, 'u1');
    expect(praiseSounds.single.audioPath, '/data/media/bravo.m4a');

    // Praise words are preserved (only the audio column is dropped).
    final praiseCols = await db
        .customSelect('PRAGMA table_info(praises)')
        .map((r) => r.read<String>('name'))
        .get();
    expect(praiseCols, isNot(contains('audio_path')));
    expect(praiseCols, containsAll(['id', 'label', 'source', 'enabled']));

    final wordCount = (await db.select(db.praises).get()).length;
    expect(wordCount, 2, reason: 'both praise words kept');
  });
}
