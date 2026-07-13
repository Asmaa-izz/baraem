import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/data/seed/content_seeder.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // rootBundle serves declared assets in widget/flutter tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('seeds the real content.json (new subjects/speech schema) without error',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() async => db.close());

    // Must not throw (this is the boot path that was crashing).
    await ContentSeeder(db).ensureSeeded();

    final categories = await db.select(db.categories).get();
    expect(categories.map((c) => c.id), containsAll(['household', 'animals']));

    // Flexible to content growth (categories/items may be added over time).
    final items = await db.select(db.items).get();
    expect(items.length, greaterThanOrEqualTo(12));

    // `speech` was parsed for system items.
    final spoon = items.firstWhere((i) => i.id == 'spoon');
    expect(spoon.speech, isNotNull);
    expect(spoon.source, ContentSource.system);

    // Each item's `subjects` became exemplars.
    final spoonExemplars =
        await (db.select(db.exemplars)..where((e) => e.itemId.equals('spoon')))
            .get();
    expect(spoonExemplars, isNotEmpty);

    // `sections` (الجزء — cut-open views) become extra exemplars numbered after
    // the regular images, and flip `hasImage` on once the bundled file exists.
    final watermelonSection = await (db.select(db.exemplars)
          ..where((e) => e.id.equals('fruits_watermelon_6')))
        .getSingleOrNull();
    expect(watermelonSection, isNotNull);
    expect(watermelonSection!.orderIndex, 6);
    expect(watermelonSection.hasImage, isTrue);

    // Re-running is idempotent (no duplicates).
    await ContentSeeder(db).ensureSeeded();
    expect((await db.select(db.items).get()).length, items.length);
  });
}
