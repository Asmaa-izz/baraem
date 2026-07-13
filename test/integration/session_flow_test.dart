import 'dart:math';

import 'package:baraem/app/providers.dart';
import 'package:baraem/core/utils/clock.dart';
import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/features/engine/engine_models.dart';
import 'package:baraem/features/engine/session_controller.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Seeds a small content set directly (no assets needed).
Future<void> seedTestContent(AppDatabase db) async {
  await db.into(db.categories).insert(CategoriesCompanion.insert(
        id: 'household',
        name: 'أدوات المنزل',
        icon: '🍽️',
        orderIndex: 1,
        source: ContentSource.system,
      ));
  const items = ['spoon', 'fork', 'cup', 'plate', 'pot', 'bottle'];
  for (final id in items) {
    await db.into(db.items).insert(ItemsCompanion.insert(
          id: id,
          label: id,
          categoryId: 'household',
          source: ContentSource.system,
        ));
    for (var n = 1; n <= 2; n++) {
      await db.into(db.exemplars).insert(ExemplarsCompanion.insert(
            id: '${id}_$n',
            itemId: id,
            imagePath: 'assets/content/household/$id/$n.jpg',
            orderIndex: Value(n),
            hasImage: const Value(false),
            source: ContentSource.system,
          ));
    }
  }
}

/// Seeds two categories so scoping can be verified.
Future<void> seedTwoCategories(AppDatabase db) async {
  Future<void> cat(String id, int order, List<String> items) async {
    await db.into(db.categories).insert(CategoriesCompanion.insert(
        id: id, name: id, icon: '🔷', orderIndex: order, source: ContentSource.system));
    for (final it in items) {
      await db.into(db.items).insert(ItemsCompanion.insert(
          id: it, label: it, categoryId: id, source: ContentSource.system));
      await db.into(db.exemplars).insert(ExemplarsCompanion.insert(
          id: '${it}_1',
          itemId: it,
          imagePath: 'p/$it',
          orderIndex: const Value(1),
          hasImage: const Value(false),
          source: ContentSource.system));
    }
  }

  await cat('household', 1, ['spoon', 'fork', 'cup']);
  await cat('animals', 2, ['cat', 'dog', 'bird']);
}

/// Seeds one category with 8 items whose curated [orderIndex] is deliberately
/// the REVERSE of alphabetical id, so tests can prove the active window follows
/// curated order, not id. Curated order: h, g, f, e, d, c, b, a.
Future<void> seedOrderedItems(AppDatabase db) async {
  await db.into(db.categories).insert(CategoriesCompanion.insert(
        id: 'household',
        name: 'أدوات المنزل',
        icon: '🍽️',
        orderIndex: 1,
        source: ContentSource.system,
      ));
  const ordered = ['h', 'g', 'f', 'e', 'd', 'c', 'b', 'a'];
  for (var i = 0; i < ordered.length; i++) {
    final id = ordered[i];
    await db.into(db.items).insert(ItemsCompanion.insert(
          id: id,
          label: id,
          categoryId: 'household',
          source: ContentSource.system,
          orderIndex: Value(i),
        ));
    await db.into(db.exemplars).insert(ExemplarsCompanion.insert(
          id: '${id}_1',
          itemId: id,
          imagePath: 'p/$id',
          orderIndex: const Value(1),
          hasImage: const Value(false),
          source: ContentSource.system,
        ));
  }
}

void main() {
  test('active window admits only activeWindowSize items, in curated order',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(4)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedOrderedItems(db); // 8 items, window default 5
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🐨', mode: ProfileMode.normal);
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(selectedCategoryProvider.notifier).select('household');
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.quiz);

    await container.read(sessionControllerProvider(profile.id).future);

    final active =
        await container.read(learningRepositoryProvider).getActiveStates(profile.id);
    expect(active.length, 5, reason: 'only the window fills, not all 8 items');
    expect(active.map((s) => s.itemId).toSet(), {'h', 'g', 'f', 'e', 'd'},
        reason: 'the first 5 by curated orderIndex, not by id');
  });

  test('a new item is admitted only after a current one solidly graduates',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(6)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedOrderedItems(db);
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🐼', mode: ProfileMode.normal);
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(selectedCategoryProvider.notifier).select('household');
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.quiz);

    final learn = container.read(learningRepositoryProvider);
    await container.read(sessionControllerProvider(profile.id).future);
    expect((await learn.getActiveStates(profile.id)).length, 5);

    // A brand-new item must NOT appear just because the child answered a few
    // correct: mastery alone (low box) does not free a slot.
    final justMastered = (await learn.getState(profile.id, 'h'))!
        .copyWith(status: ItemStatus.mastered, leitnerBox: 2, consecutiveCorrect: 3);
    await learn.upsertState(justMastered);
    container.invalidate(sessionControllerProvider(profile.id));
    await container.read(sessionControllerProvider(profile.id).future);
    expect((await learn.getActiveStates(profile.id)).length, 5,
        reason: 'mastered-but-not-durable still occupies its slot');

    // Now let it graduate durably (mastered + box ≥ kGraduateBox) → a slot frees
    // and the next curated item ("c") is admitted.
    final graduated = (await learn.getState(profile.id, 'h'))!
        .copyWith(status: ItemStatus.mastered, leitnerBox: 5, consecutiveCorrect: 3);
    await learn.upsertState(graduated);
    container.invalidate(sessionControllerProvider(profile.id));
    await container.read(sessionControllerProvider(profile.id).future);

    final active = await learn.getActiveStates(profile.id);
    expect(active.map((s) => s.itemId), contains('c'),
        reason: 'the next curated item is admitted after graduation');
    expect(active.length, 6, reason: '4 occupants + graduated h + newly admitted c');
  });

  test('learn mode is scoped to the chosen category and never quizzes',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(2)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedTwoCategories(db);
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🐨', mode: ProfileMode.normal);
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(selectedCategoryProvider.notifier).select('animals');
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.learn);

    final ctrl = container.read(sessionControllerProvider(profile.id).notifier);
    var s = await container.read(sessionControllerProvider(profile.id).future);

    final shownCategories = <String>{};
    var guard = 0;
    while (!s.isFinished && guard++ < 50) {
      expect(s.mode, TrialMode.display, reason: 'learn mode never quizzes');
      shownCategories.add(s.item.categoryId);
      await ctrl.advance();
      s = container.read(sessionControllerProvider(profile.id)).value!;
    }
    expect(shownCategories, {'animals'}, reason: 'only the chosen category shows');
  });

  test('learn rounds: each active-window item is shown `rounds` times',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(7)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedTestContent(db); // 6 items; window default 5
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🐨', mode: ProfileMode.normal);
    await container
        .read(profileRepositoryProvider)
        .updateProfile(profile.copyWith(rounds: 3));
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(selectedCategoryProvider.notifier).select('household');
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.learn);

    final ctrl = container.read(sessionControllerProvider(profile.id).notifier);
    var s = await container.read(sessionControllerProvider(profile.id).future);
    expect(s.total, 15, reason: '5 window items × 3 rounds');

    final counts = <String, int>{};
    var total = 0;
    var guard = 0;
    while (!s.isFinished && guard++ < 200) {
      expect(s.mode, TrialMode.display);
      counts[s.item.id] = (counts[s.item.id] ?? 0) + 1;
      total++;
      await ctrl.advance();
      s = container.read(sessionControllerProvider(profile.id)).value!;
    }

    expect(total, 15, reason: 'screens = 5 window items × 3 rounds');
    expect(counts.length, 5, reason: 'only the 5 active-window items appear');
    expect(counts.values, everyElement(3),
        reason: 'each active item is shown exactly `rounds` (3) times');
  });

  test('quiz mode is scoped to the chosen category (no cross-category leak)',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(5)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedTwoCategories(db);
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🐱', mode: ProfileMode.normal);
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(selectedCategoryProvider.notifier).select('household');
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.quiz);

    final ctrl = container.read(sessionControllerProvider(profile.id).notifier);
    var s = await container.read(sessionControllerProvider(profile.id).future);

    final targets = <String>{};
    var guard = 0;
    while (!s.isFinished && guard++ < 80) {
      expect(s.mode, TrialMode.quiz);
      targets.add(s.item.categoryId);
      for (final o in s.options) {
        expect(o.item.categoryId, 'household', reason: 'distractors stay in category');
      }
      await ctrl.answer(s.item.id);
      await ctrl.advance();
      s = container.read(sessionControllerProvider(profile.id)).value!;
    }
    expect(targets, {'household'}, reason: 'only the chosen category is quizzed');
  });

  test('end-to-end: a full session runs, persists, and completes', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(1)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedTestContent(db);

    final profile = await container.read(profileRepositoryProvider).createProfile(
          name: 'براعم',
          avatar: '🐣',
          mode: ProfileMode.normal,
        );
    // A longer session so several items can reach mastery (3 correct quizzes).
    await container
        .read(profileRepositoryProvider)
        .updateProfile(profile.copyWith(sessionLength: 40));
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.quiz);

    final ctrl = container.read(sessionControllerProvider(profile.id).notifier);
    var s = await container.read(sessionControllerProvider(profile.id).future);

    // The window filled from the seeded category.
    expect(await container.read(learningRepositoryProvider).countActive(profile.id),
        greaterThan(0));

    // Always answer correctly, mimicking the UI: answer → advance on correct,
    // just advance on a display trial.
    var guard = 0;
    while (!s.isFinished && guard++ < 500) {
      if (s.mode == TrialMode.quiz) {
        await ctrl.answer(s.item.id); // correct
        await ctrl.advance();
      } else {
        await ctrl.advance();
      }
      s = container.read(sessionControllerProvider(profile.id)).value!;
    }

    expect(s.isFinished, isTrue, reason: 'session should complete');
    expect(guard, lessThan(500), reason: 'no infinite loop');

    // Trials were logged and the session was closed.
    final trials = await db.select(db.trialLogs).get();
    expect(trials, isNotEmpty);
    final sessions = await db.select(db.sessions).get();
    expect(sessions.single.endedAt, isNotNull);
    expect(sessions.single.itemsSeen, greaterThan(0));

    // Answering everything correctly should master several items.
    final states = await db.select(db.learningStates).get();
    final mastered = states
        .where((st) =>
            st.status == ItemStatus.mastered || st.status == ItemStatus.archived)
        .length;
    expect(mastered, greaterThan(0), reason: 'correct answers should master items');
  });

  test('errorless: a wrong answer demotes once, then retry succeeds', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(FixedClock(DateTime.utc(2026, 7, 11))),
      randomProvider.overrideWithValue(Random(3)),
    ]);
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    await seedTestContent(db);
    final profile = await container
        .read(profileRepositoryProvider)
        .createProfile(name: 'ط', avatar: '🦊', mode: ProfileMode.normal);
    container.read(currentProfileIdProvider.notifier).select(profile.id);
    container.read(sessionModeControllerProvider.notifier).set(SessionMode.quiz);

    final ctrl = container.read(sessionControllerProvider(profile.id).notifier);
    var s = await container.read(sessionControllerProvider(profile.id).future);

    // Advance to the first quiz trial.
    var guard = 0;
    while (s.mode != TrialMode.quiz && !s.isFinished && guard++ < 50) {
      await ctrl.advance();
      s = container.read(sessionControllerProvider(profile.id)).value!;
    }
    expect(s.mode, TrialMode.quiz);

    // Tap a wrong option → gentle hint, correct answer revealed, no crash.
    final wrong = s.options.firstWhere((o) => o.item.id != s.item.id);
    await ctrl.answer(wrong.item.id);
    s = container.read(sessionControllerProvider(profile.id)).value!;
    expect(s.phase, SessionPhase.hint);

    // Retry with the correct answer → accepted.
    await ctrl.answer(s.item.id);
    s = container.read(sessionControllerProvider(profile.id)).value!;
    expect(s.phase, SessionPhase.correct);

    // The wrong attempt was logged; the retry is flagged.
    final trials = await db.select(db.trialLogs).get();
    expect(trials.any((t) => !t.correct), isTrue, reason: 'the miss was logged');
    expect(trials.any((t) => t.isRetry), isTrue, reason: 'the retry was flagged');
  });
}
