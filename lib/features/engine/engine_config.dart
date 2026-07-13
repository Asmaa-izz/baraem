import '../../data/models/domain.dart';
import '../../data/models/enums.dart';

/// Per-profile tuning for the learning engine. Support mode is gentler:
/// fewer choices for longer, more exposures before quizzing, slower promotion.
class ProfileConfig {
  const ProfileConfig({
    required this.mode,
    required this.sessionLength,
    required this.activeWindowSize,
    required this.masteryThreshold,
    required this.rounds,
    required this.choicesCount,
    required this.maxChoices,
    required this.exposuresBeforeQuiz,
    required this.promoteAfterTrials,
    required this.promoteAccuracy,
    required this.recentAvoid,
  });

  final ProfileMode mode;
  final int sessionLength;
  final int activeWindowSize;
  final int masteryThreshold;

  /// Learn-mode repeat factor (browse screens = active window × rounds).
  final int rounds;

  /// Current number of quiz options (starts at 2 — errorless learning).
  final int choicesCount;
  final int maxChoices;

  /// Display exposures a brand-new item gets before it is first quizzed.
  final int exposuresBeforeQuiz;

  /// Minimum trials at the current [choicesCount] before it may be promoted.
  final int promoteAfterTrials;

  /// Recent accuracy required to promote choicesCount (2 → 3 → 4).
  final double promoteAccuracy;

  /// How many recent items to avoid repeating immediately.
  final int recentAvoid;

  factory ProfileConfig.forProfile(ChildProfile p) {
    final support = p.mode == ProfileMode.support;
    return ProfileConfig(
      mode: p.mode,
      sessionLength: p.sessionLength,
      activeWindowSize: p.activeWindowSize,
      masteryThreshold: p.masteryThreshold,
      rounds: p.rounds,
      choicesCount: p.choicesCount,
      maxChoices: support ? 3 : 4,
      exposuresBeforeQuiz: support ? 2 : 1,
      promoteAfterTrials: support ? 12 : 6,
      promoteAccuracy: support ? 0.90 : 0.85,
      recentAvoid: 2,
    );
  }
}
