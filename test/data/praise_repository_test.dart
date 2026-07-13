import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/data/repositories/praise_repository.dart';
import 'package:baraem/data/repositories/sound_repository.dart';
import 'package:baraem/data/seed/content_seeder.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftPraiseRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DriftPraiseRepository(db);
    await ContentSeeder(db).ensureSeeded();
  });

  tearDown(() async => db.close());

  test('system praises are seeded and enabled', () async {
    final enabled = await repo.getEnabledPraises();
    expect(enabled.length, greaterThanOrEqualTo(6));
    expect(enabled.every((p) => p.source == ContentSource.system), isTrue);
  });

  test('soft-delete survives re-seeding (insertOrIgnore)', () async {
    final first = (await repo.getEnabledPraises()).first;
    await repo.setEnabled(first.id, false);

    // Re-seed (as happens on every launch) must NOT re-enable it.
    await ContentSeeder(db).ensureSeeded();

    final enabledIds = (await repo.getEnabledPraises()).map((p) => p.id);
    expect(enabledIds, isNot(contains(first.id)));
  });

  test('addUserPraiseWord adds a user word', () async {
    final before = (await db.select(db.praises).get()).length;
    final added = await repo.addUserPraiseWord(label: 'برافو حبيبي');
    expect(added.source, ContentSource.user);
    expect(added.label, 'برافو حبيبي');
    expect((await db.select(db.praises).get()).length, before + 1);
  });

  test('resetPraises re-enables system and removes user words', () async {
    // Disable a system word and add a user word (with a user voice clip).
    final sys = (await repo.getEnabledPraises()).first;
    await repo.setEnabled(sys.id, false);
    final word = await repo.addUserPraiseWord(label: 'صوتي');
    await DriftSoundRepository(db).addUserSound(
      ownerType: SoundOwner.praise,
      ownerId: word.id,
      audioPath: '/data/media/a.m4a',
    );

    await repo.resetPraises();

    final allWords = await db.select(db.praises).get();
    expect(allWords.every((p) => p.source == ContentSource.system), isTrue,
        reason: 'user words removed');
    expect(allWords.every((p) => p.enabled), isTrue,
        reason: 'all system words re-enabled');

    final userSounds = await (db.select(db.sounds)
          ..where((s) => s.source.equalsValue(ContentSource.user)))
        .get();
    expect(userSounds, isEmpty, reason: 'user voice clips removed');
  });
}
