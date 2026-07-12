import 'dart:math';

import 'package:baraem/core/utils/clock.dart';
import 'package:baraem/data/models/domain.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/features/engine/engine_config.dart';
import 'package:baraem/features/engine/engine_models.dart';
import 'package:baraem/features/engine/learning_engine.dart';
import 'package:flutter_test/flutter_test.dart';

LearningState ls({
  String itemId = 'i',
  ItemStatus status = ItemStatus.learning,
  int box = 1,
  int consec = 0,
  int timesSeen = 0,
  DateTime? nextDue,
  String? lastExemplarId,
}) {
  return LearningState(
    id: 's_$itemId',
    childId: 'c',
    itemId: itemId,
    status: status,
    leitnerBox: box,
    consecutiveCorrect: consec,
    timesSeen: timesSeen,
    nextDue: nextDue,
    lastExemplarId: lastExemplarId,
  );
}

Item item(String id, {String cat = 'household'}) =>
    Item(id: id, label: id, categoryId: cat, source: ContentSource.system);

Exemplar ex(String id, {String itemId = 'i', bool img = true}) => Exemplar(
      id: id,
      itemId: itemId,
      imagePath: 'p/$id',
      order: 1,
      hasImage: img,
      source: ContentSource.system,
    );

ChildProfile profile({ProfileMode mode = ProfileMode.normal, int choices = 2}) =>
    ChildProfile(
      id: 'c',
      name: 'n',
      avatar: 'a',
      mode: mode,
      choicesCount: choices,
      sessionLength: 12,
      activeWindowSize: 5,
      masteryThreshold: 3,
    );

void main() {
  final now = DateTime.utc(2026, 7, 11, 15, 30);
  final engine = LearningEngine(clock: FixedClock(now), random: Random(7));

  group('Leitner intervals (computeNextDue)', () {
    test('box 1 stays due now (same session)', () {
      expect(engine.computeNextDue(1, now), now);
    });
    test('boxes 2-5 snap to a future calendar day', () {
      expect(engine.computeNextDue(2, now), DateTime.utc(2026, 7, 12));
      expect(engine.computeNextDue(3, now), DateTime.utc(2026, 7, 14));
      expect(engine.computeNextDue(4, now), DateTime.utc(2026, 7, 18));
      expect(engine.computeNextDue(5, now), DateTime.utc(2026, 7, 25));
    });
  });

  group('applyAnswer', () {
    test('correct raises box, increments streak & timesSeen', () {
      final s = ls(box: 2, consec: 1, timesSeen: 4);
      final r = engine.applyAnswer(s, true, 3, now);
      expect(r.leitnerBox, 3);
      expect(r.consecutiveCorrect, 2);
      expect(r.timesSeen, 5);
      expect(r.nextDue, DateTime.utc(2026, 7, 14));
    });

    test('wrong resets box to 1 and streak to 0', () {
      final s = ls(box: 4, consec: 2, timesSeen: 9);
      final r = engine.applyAnswer(s, false, 3, now);
      expect(r.leitnerBox, 1);
      expect(r.consecutiveCorrect, 0);
      expect(r.nextDue, now); // box 1 → due now
    });

    test('box never exceeds 5', () {
      final r = engine.applyAnswer(ls(box: 5, consec: 4), true, 3, now);
      expect(r.leitnerBox, 5);
    });
  });

  group('mastery + status transitions', () {
    test('3 consecutive correct ⇒ mastered', () {
      var s = ls(status: ItemStatus.isNew, box: 1, consec: 0);
      s = engine.applyAnswer(s, true, 3, now); // 1
      expect(s.status, ItemStatus.learning);
      s = engine.applyAnswer(s, true, 3, now); // 2
      expect(s.status, ItemStatus.learning);
      s = engine.applyAnswer(s, true, 3, now); // 3 ⇒ mastered
      expect(s.status, ItemStatus.mastered);
      expect(s.consecutiveCorrect, 3);
    });

    test('mastered item regresses to learning on a miss', () {
      final s = ls(status: ItemStatus.mastered, box: 5, consec: 3);
      final r = engine.applyAnswer(s, false, 3, now);
      expect(r.status, ItemStatus.learning);
    });

    test('archived is terminal', () {
      final s = ls(status: ItemStatus.archived, box: 5, consec: 3);
      expect(engine.applyAnswer(s, true, 3, now).status, ItemStatus.archived);
    });
  });

  group('isStableForArchive', () {
    test('box 5 + streak ≥ threshold ⇒ stable', () {
      expect(engine.isStableForArchive(ls(box: 5, consec: 3), 3), isTrue);
      expect(engine.isStableForArchive(ls(box: 5, consec: 2), 3), isFalse);
      expect(engine.isStableForArchive(ls(box: 4, consec: 3), 3), isFalse);
    });
  });

  group('isGraduated (frees an active-window slot)', () {
    test('mastered AND box ≥ kGraduateBox ⇒ graduated', () {
      expect(
          engine.isGraduated(ls(status: ItemStatus.mastered, box: kGraduateBox)),
          isTrue);
      expect(engine.isGraduated(ls(status: ItemStatus.mastered, box: 5)), isTrue);
    });

    test('mastered but still in a low box ⇒ not yet graduated', () {
      expect(engine.isGraduated(ls(status: ItemStatus.mastered, box: 1)), isFalse);
      expect(engine.isGraduated(ls(status: ItemStatus.mastered, box: 2)), isFalse);
    });

    test('a high box without mastery does not graduate', () {
      expect(engine.isGraduated(ls(status: ItemStatus.learning, box: 5)), isFalse);
      expect(engine.isGraduated(ls(status: ItemStatus.isNew, box: 5)), isFalse);
    });
  });

  group('itemWeight', () {
    test('recently-seen items are suppressed', () {
      final w = engine.itemWeight(ls(itemId: 'x', nextDue: now), now, {'x'});
      expect(w, lessThan(0.01));
    });
    test('due items weigh more than not-yet-due', () {
      final due = engine.itemWeight(
          ls(itemId: 'a', box: 2, nextDue: now.subtract(const Duration(days: 1))),
          now,
          {});
      final future = engine.itemWeight(
          ls(itemId: 'b', box: 2, nextDue: now.add(const Duration(days: 5))),
          now,
          {});
      expect(due, greaterThan(future));
    });
    test('weaker (lower box) weighs more than stronger', () {
      final weak = engine.itemWeight(ls(itemId: 'a', box: 1, nextDue: now), now, {});
      final strong = engine.itemWeight(ls(itemId: 'b', box: 4, nextDue: now), now, {});
      expect(weak, greaterThan(strong));
    });
  });

  group('pickExemplar', () {
    test('prefers exemplars that have a real image', () {
      final chosen = engine.pickExemplar([
        ex('noimg', img: false),
        ex('withimg', img: true),
      ]);
      expect(chosen.id, 'withimg');
    });
    test('avoids the last-shown exemplar when alternatives exist', () {
      final chosen = engine.pickExemplar(
        [ex('one'), ex('two')],
        avoid: 'one',
      );
      expect(chosen.id, 'two');
    });
  });

  group('decideMode', () {
    final cfg = ProfileConfig.forProfile(profile());
    test('new item under exposure count ⇒ display', () {
      expect(engine.decideMode(ls(status: ItemStatus.isNew, timesSeen: 0), cfg),
          TrialMode.display);
    });
    test('new item at/over exposure count ⇒ quiz', () {
      expect(engine.decideMode(ls(status: ItemStatus.isNew, timesSeen: 1), cfg),
          TrialMode.quiz);
    });
    test('learning item ⇒ quiz', () {
      expect(engine.decideMode(ls(status: ItemStatus.learning), cfg),
          TrialMode.quiz);
    });
  });

  group('pickDistractors', () {
    final household = [
      item('spoon'),
      item('fork'),
      item('cup'),
      item('plate'),
      item('pot'),
    ];
    test('all distractors come from the same category, correct count', () {
      final d = engine.pickDistractors(item('spoon'), household, 3, Difficulty.easy);
      expect(d.length, 2);
      expect(d.every((i) => i.id != 'spoon'), isTrue);
    });
    test('easy difficulty avoids the confusable item (fork) for a 2-choice quiz',
        () {
      final d = engine.pickDistractors(item('spoon'), household, 2, Difficulty.easy);
      expect(d.single.id, isNot('fork'));
    });
    test('hard difficulty includes the confusable item', () {
      final d = engine.pickDistractors(item('spoon'), household, 2, Difficulty.hard);
      expect(d.single.id, 'fork');
    });
  });

  group('nextChoicesCount (errorless progression)', () {
    test('normal: promotes 2→3 once trials & accuracy are met', () {
      final cfg = ProfileConfig.forProfile(profile(choices: 2));
      final r = engine.nextChoicesCount(
          cfg, const PerfWindow(trialsAtCurrent: 6, recentAccuracy: 0.9));
      expect(r, 3);
    });
    test('does not promote before enough trials', () {
      final cfg = ProfileConfig.forProfile(profile(choices: 2));
      final r = engine.nextChoicesCount(
          cfg, const PerfWindow(trialsAtCurrent: 3, recentAccuracy: 0.95));
      expect(r, 2);
    });
    test('caps at maxChoices (normal = 4)', () {
      final cfg = ProfileConfig.forProfile(profile(choices: 4));
      final r = engine.nextChoicesCount(
          cfg, const PerfWindow(trialsAtCurrent: 20, recentAccuracy: 1.0));
      expect(r, 4);
    });
    test('support stays low longer (needs 12 trials, caps at 3)', () {
      final cfg = ProfileConfig.forProfile(
          profile(mode: ProfileMode.support, choices: 2));
      expect(
        engine.nextChoicesCount(
            cfg, const PerfWindow(trialsAtCurrent: 6, recentAccuracy: 0.95)),
        2, // 6 < 12 → no promotion yet
      );
      expect(
        engine.nextChoicesCount(
            cfg, const PerfWindow(trialsAtCurrent: 12, recentAccuracy: 0.95)),
        3,
      );
    });
    test('eases back below 2 never happens', () {
      final cfg = ProfileConfig.forProfile(profile(choices: 2));
      final r = engine.nextChoicesCount(
          cfg, const PerfWindow(trialsAtCurrent: 8, recentAccuracy: 0.3));
      expect(r, 2);
    });
  });
}
