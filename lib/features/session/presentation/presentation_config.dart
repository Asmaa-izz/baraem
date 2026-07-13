import '../../../core/theme/baraem_tokens.dart';
import '../../../data/models/enums.dart';

/// Per-mode child-facing presentation tuning. Support mode is calmer and
/// clearer: more time to absorb the answer, a gentler celebration (less
/// sensory load — PRD "تقليل المشتّتات"), a spotlight that dims the wrong
/// choices, and more breathing room between tiles.
///
/// Mirrors the engine's [ProfileConfig.forProfile] pattern so presentation
/// forks on mode in one pure, testable place — no magic numbers in the widgets.
class PresentationConfig {
  const PresentationConfig({
    required this.advanceDelay,
    required this.gentleCelebration,
    required this.spotlightAnswer,
    required this.choiceSpacing,
  });

  /// Pause on a correct answer before auto-advancing.
  final Duration advanceDelay;

  /// Softer, fewer sparkles instead of the full 6-star burst.
  final bool gentleCelebration;

  /// On hint/correct, dim the non-answer tiles so the right one stands out.
  final bool spotlightAnswer;

  /// Grid spacing between quiz choice tiles.
  final double choiceSpacing;

  factory PresentationConfig.forMode(ProfileMode mode) {
    final support = mode == ProfileMode.support;
    return PresentationConfig(
      advanceDelay: Duration(milliseconds: support ? 2200 : 1150),
      gentleCelebration: support,
      spotlightAnswer: support,
      choiceSpacing: support ? BaraemSpace.lg : BaraemSpace.md,
    );
  }
}
