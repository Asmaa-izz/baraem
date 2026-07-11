import 'dart:math';

import '../../core/utils/clock.dart';
import '../../data/models/domain.dart';
import '../../data/models/enums.dart';
import 'engine_config.dart';
import 'engine_models.dart';

/// Leitner review intervals in days per box (PRD §8).
const Map<int, int> kLeitnerDays = {1: 0, 2: 1, 3: 3, 4: 7, 5: 14};

/// Curated confusable pairs (bidirectional). Early quizzes avoid these so the
/// child rarely errors (errorless learning); later quizzes prefer them.
const Map<String, Set<String>> kConfusables = {
  'spoon': {'fork'},
  'fork': {'spoon'},
  'cup': {'bottle'},
  'bottle': {'cup'},
  'plate': {'pot'},
  'pot': {'plate'},
  'cat': {'dog', 'rabbit'},
  'dog': {'cat'},
  'rabbit': {'cat'},
  'bird': {'duck'},
  'duck': {'bird'},
};

/// Pure learning logic (PRD §8). Deterministic given an injected [Clock] and
/// [Random] — no database, no async — so every rule is unit-testable.
class LearningEngine {
  LearningEngine({required this.clock, Random? random})
      : random = random ?? Random();

  final Clock clock;
  final Random random;

  // ---- Leitner / spaced repetition ----

  /// Next review time. Box 1 stays due now (same session); boxes 2–5 snap to a
  /// future calendar day so "due today" is stable regardless of the hour.
  DateTime computeNextDue(int box, DateTime now) {
    final days = kLeitnerDays[box] ?? 0;
    if (days == 0) return now;
    final startOfToday = DateTime.utc(now.year, now.month, now.day);
    return startOfToday.add(Duration(days: days));
  }

  // ---- answer application + mastery ----

  LearningState applyAnswer(
    LearningState s,
    bool correct,
    int masteryThreshold,
    DateTime now,
  ) {
    final box = correct ? min(s.leitnerBox + 1, 5) : 1;
    final consec = correct ? s.consecutiveCorrect + 1 : 0;
    return s.copyWith(
      leitnerBox: box,
      consecutiveCorrect: consec,
      timesSeen: s.timesSeen + 1,
      lastSeen: now,
      nextDue: computeNextDue(box, now),
      status: _deriveStatus(s.status, consec, masteryThreshold),
    );
  }

  ItemStatus _deriveStatus(ItemStatus cur, int consec, int threshold) {
    if (cur == ItemStatus.archived) return cur; // archive is terminal
    if (consec >= threshold) return ItemStatus.mastered;
    if (cur == ItemStatus.isNew) return ItemStatus.learning;
    if (cur == ItemStatus.mastered) return ItemStatus.learning; // regressed
    return cur;
  }

  /// A mastered item is archived once it also reaches box 5 and is stable.
  bool isStableForArchive(LearningState s, int masteryThreshold) =>
      s.leitnerBox >= 5 && s.consecutiveCorrect >= masteryThreshold;

  // ---- next-item weighted selection ----

  double itemWeight(LearningState s, DateTime now, Set<String> recent) {
    if (recent.contains(s.itemId)) return 0.001; // avoid immediate repeat
    var w = 1.0;
    final due = s.nextDue ?? now;
    if (!due.isAfter(now)) {
      final overdue = now.difference(due).inDays;
      w *= 3.0 + min(overdue, 7) * 0.5; // due/overdue first
    } else {
      w *= 0.4; // not yet due → low but non-zero
    }
    w *= (6 - s.leitnerBox); // weaker (lower box) weighs more
    if (s.status == ItemStatus.isNew) w *= 2.0;
    if (s.status == ItemStatus.mastered) w *= 0.5;
    return w <= 0 ? 0.001 : w;
  }

  /// Picks the next non-archived state by weighted random. Caller guarantees a
  /// non-empty [pool].
  LearningState selectNextState(
    List<LearningState> pool,
    Set<String> recent,
    DateTime now,
  ) {
    final live = pool.where((s) => s.status != ItemStatus.archived).toList();
    final weights = [for (final s in live) itemWeight(s, now, recent)];
    return _weightedPick(live, weights);
  }

  LearningState _weightedPick(List<LearningState> items, List<double> weights) {
    final total = weights.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return items[random.nextInt(items.length)];
    var r = random.nextDouble() * total;
    for (var i = 0; i < items.length; i++) {
      r -= weights[i];
      if (r <= 0) return items[i];
    }
    return items.last;
  }

  /// Rotates exemplars to teach generalization: prefer real images, and avoid
  /// showing the same exemplar twice in a row (PRD §3 multiple-exemplar).
  Exemplar pickExemplar(List<Exemplar> exemplars, {String? avoid}) {
    if (exemplars.isEmpty) {
      throw StateError('pickExemplar requires at least one exemplar');
    }
    final withImage = exemplars.where((e) => e.hasImage).toList();
    final pool = withImage.isNotEmpty ? withImage : exemplars;
    final candidates = pool.where((e) => e.id != avoid).toList();
    final choose = candidates.isNotEmpty ? candidates : pool;
    return choose[random.nextInt(choose.length)];
  }

  TrialMode decideMode(LearningState s, ProfileConfig cfg) {
    if (s.status == ItemStatus.isNew && s.timesSeen < cfg.exposuresBeforeQuiz) {
      return TrialMode.display; // errorless exposure before the first quiz
    }
    return TrialMode.quiz;
  }

  // ---- distractor selection ----

  int confusability(String a, String b) =>
      (kConfusables[a]?.contains(b) ?? false) ? 1 : 0;

  Difficulty difficultyFor(LearningState target) =>
      target.leitnerBox <= 2 ? Difficulty.easy : Difficulty.hard;

  /// Distractors from the SAME category only, difficulty-progressive: easy →
  /// least-confusable first; hard → most-confusable. Shuffled within the band.
  List<Item> pickDistractors(
    Item target,
    List<Item> sameCategory,
    int choicesCount,
    Difficulty difficulty,
  ) {
    final others = sameCategory.where((i) => i.id != target.id).toList();
    final n = choicesCount - 1;
    if (others.length <= n) return others..shuffle(random);
    others.sort(
      (a, b) => confusability(target.id, a.id)
          .compareTo(confusability(target.id, b.id)),
    );
    final band = difficulty == Difficulty.easy
        ? others.take(n).toList()
        : others.reversed.take(n).toList();
    band.shuffle(random);
    return band;
  }

  // ---- errorless: choices-count progression ----

  int nextChoicesCount(ProfileConfig cfg, PerfWindow perf) {
    if (perf.trialsAtCurrent >= cfg.promoteAfterTrials &&
        perf.recentAccuracy >= cfg.promoteAccuracy) {
      return min(cfg.choicesCount + 1, cfg.maxChoices);
    }
    if (perf.recentAccuracy < 0.5) {
      return max(2, cfg.choicesCount - 1); // ease back, never below 2
    }
    return cfg.choicesCount;
  }
}
