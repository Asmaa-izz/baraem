import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/data/repositories/praise_repository.dart';
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

  test('addUserPraise adds a user row', () async {
    final before = (await db.select(db.praises).get()).length;
    final added = await repo.addUserPraise(
      label: 'برافو حبيبي',
      audioPath: '/data/media/xyz.m4a',
    );
    expect(added.source, ContentSource.user);
    expect((await db.select(db.praises).get()).length, before + 1);
  });

  test('resetPraises re-enables system and removes user clips', () async {
    // Disable a system clip and add a user clip.
    final sys = (await repo.getEnabledPraises()).first;
    await repo.setEnabled(sys.id, false);
    await repo.addUserPraise(label: 'صوتي', audioPath: '/data/media/a.m4a');

    await repo.resetPraises();

    final all = await db.select(db.praises).get();
    expect(all.every((p) => p.source == ContentSource.system), isTrue,
        reason: 'user clips removed');
    expect(all.every((p) => p.enabled), isTrue,
        reason: 'all system clips re-enabled');
  });
}
