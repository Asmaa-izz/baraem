import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/data/repositories/sound_repository.dart';
import 'package:baraem/data/seed/content_seeder.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftSoundRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DriftSoundRepository(db);
  });

  tearDown(() async => db.close());

  Future<void> seedSystemVoice(String itemId, String voiceId, String label) {
    return db.into(db.sounds).insert(SoundsCompanion.insert(
          id: 'snd_item_${itemId}_$voiceId',
          ownerType: SoundOwner.item,
          ownerId: itemId,
          label: Value(label),
          audioPath: 'assets/content/fruits/$itemId/audio/$voiceId.mp3',
          source: ContentSource.system,
        ));
  }

  test('addUserSound stores a user clip under the right owner', () async {
    final s = await repo.addUserSound(
      ownerType: SoundOwner.item,
      ownerId: 'apple',
      audioPath: '/data/media/apple.m4a',
    );
    expect(s.ownerType, SoundOwner.item);
    expect(s.ownerId, 'apple');
    expect(s.source, ContentSource.user);
    expect(s.enabled, isTrue);

    final list = await repo.getEnabledSounds(SoundOwner.item, 'apple');
    expect(list.length, 1);
    expect(list.single.audioPath, '/data/media/apple.m4a');
  });

  test('getEnabledSounds filters by owner and enabled', () async {
    await seedSystemVoice('apple', 'sana', 'أنثى');
    await seedSystemVoice('apple', 'taim', 'ذكر');
    await seedSystemVoice('banana', 'sana', 'أنثى');

    final apple = await repo.getEnabledSounds(SoundOwner.item, 'apple');
    expect(apple.length, 2, reason: 'scoped to owner');

    // Soft-delete one system voice.
    await repo.setEnabled('snd_item_apple_taim', false);
    final appleAfter = await repo.getEnabledSounds(SoundOwner.item, 'apple');
    expect(appleAfter.length, 1);
    expect(appleAfter.single.id, 'snd_item_apple_sana');
  });

  test('setEnabled soft-toggles without deleting the row', () async {
    await seedSystemVoice('apple', 'sana', 'أنثى');
    await repo.setEnabled('snd_item_apple_sana', false);

    final rows = await db.select(db.sounds).get();
    expect(rows.length, 1, reason: 'row still present');
    expect(rows.single.enabled, isFalse);
  });

  test('deleteUserSound removes the row', () async {
    final s = await repo.addUserSound(
      ownerType: SoundOwner.praise,
      ownerId: 'shater',
      audioPath: '/data/media/x.m4a',
    );
    await repo.deleteUserSound(s.id);
    expect(await db.select(db.sounds).get(), isEmpty);
  });

  test('seeder registers a system voice per shipped clip, survives re-seed',
      () async {
    // Real bundle: the flutter test harness serves declared assets, so the
    // AssetManifest lists the shipped sana.mp3 / taim.mp3 for each item.
    await ContentSeeder(db).ensureSeeded();

    final cat = await repo.getEnabledSounds(SoundOwner.item, 'cat');
    expect(cat.length, greaterThanOrEqualTo(2),
        reason: 'both أنثى (سنا) + ذكر (تيم) voices seeded for an item');
    expect(cat.every((s) => s.source == ContentSource.system), isTrue);
    expect(cat.map((s) => s.audioPath),
        containsAll(['assets/content/animals/cat/audio/sana.mp3']));

    // Soft-delete one system voice, then re-seed (as on every launch): the
    // parent's choice must survive (insertOrIgnore).
    await repo.setEnabled('snd_item_cat_taim', false);
    await ContentSeeder(db).ensureSeeded();
    final after = await repo.getEnabledSounds(SoundOwner.item, 'cat');
    expect(after.map((s) => s.id), isNot(contains('snd_item_cat_taim')));
  });

  test('watchSounds emits ordered system-then-user clips', () async {
    await seedSystemVoice('apple', 'sana', 'أنثى');
    await repo.addUserSound(
      ownerType: SoundOwner.item,
      ownerId: 'apple',
      audioPath: '/data/media/mine.m4a',
    );

    final list = await repo.watchSounds(SoundOwner.item, 'apple').first;
    expect(list.length, 2);
    expect(list.first.source, ContentSource.system);
    expect(list.last.source, ContentSource.user);
  });
}
