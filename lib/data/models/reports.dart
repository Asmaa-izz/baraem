import 'enums.dart';

/// Aggregate counts + overall accuracy for a child (parent dashboard).
class ProgressSummary {
  const ProgressSummary({
    required this.newCount,
    required this.learning,
    required this.mastered,
    required this.archived,
    required this.totalTrials,
    required this.correctTrials,
  });

  final int newCount;
  final int learning;
  final int mastered;
  final int archived;
  final int totalTrials;
  final int correctTrials;

  int get totalItems => newCount + learning + mastered + archived;

  /// First-attempt accuracy across all logged trials (0..1), retries excluded
  /// by the query. Zero when there are no trials yet.
  double get accuracy => totalTrials == 0 ? 0 : correctTrials / totalTrials;
}

/// Per-item progress row.
class ItemProgress {
  const ItemProgress({
    required this.itemId,
    required this.label,
    required this.categoryId,
    required this.status,
    required this.leitnerBox,
    required this.timesSeen,
    required this.correct,
    required this.total,
  });

  final String itemId;
  final String label;
  final String categoryId;
  final ItemStatus status;
  final int leitnerBox;
  final int timesSeen;
  final int correct;
  final int total;

  double get accuracy => total == 0 ? 0 : correct / total;
}

/// Accuracy for one calendar day (learning curve over time).
class DailyAccuracy {
  const DailyAccuracy({
    required this.day,
    required this.total,
    required this.correct,
  });

  final DateTime day;
  final int total;
  final int correct;

  double get accuracy => total == 0 ? 0 : correct / total;
}
