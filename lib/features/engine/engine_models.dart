import '../../data/models/domain.dart';

/// Whether the whole session is a free image browse (learn) or a test (quiz).
/// Chosen explicitly by the user on the home screen.
enum SessionMode { learn, quiz }

/// Whether the current trial shows the item (learn) or tests it (quiz).
enum TrialMode { display, quiz }

/// Difficulty band for distractor selection (errorless → harder over time).
enum Difficulty { easy, hard }

/// The engine's decision for the next trial: which state, which exemplar to
/// show, and whether to display or quiz it.
class NextItem {
  const NextItem({
    required this.state,
    required this.exemplar,
    required this.mode,
  });

  final LearningState state;
  final Exemplar exemplar;
  final TrialMode mode;
}

/// A rolling view of recent performance at the current choices-count, used to
/// decide whether to promote the number of quiz options.
class PerfWindow {
  const PerfWindow({
    required this.trialsAtCurrent,
    required this.recentAccuracy,
  });

  final int trialsAtCurrent;
  final double recentAccuracy;
}
