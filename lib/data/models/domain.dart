import 'enums.dart';

/// Plain, immutable domain models. Repositories map Drift rows to these so the
/// engine and UI never depend on generated Drift classes.

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.order,
    required this.source,
  });

  final String id;
  final String name;
  final String icon;
  final int order;
  final ContentSource source;
}

class Item {
  const Item({
    required this.id,
    required this.label,
    required this.categoryId,
    required this.source,
    this.speech,
    this.orderIndex = 0,
  });

  final String id;
  final String label;
  final String categoryId;
  final ContentSource source;

  /// Vocalized form for TTS; falls back to [label] when null.
  final String? speech;

  /// Curated introduction order within the category (drives the active window).
  final int orderIndex;

  /// The text to pronounce for this item.
  String get spoken => speech ?? label;
}

class Exemplar {
  const Exemplar({
    required this.id,
    required this.itemId,
    required this.imagePath,
    required this.order,
    required this.hasImage,
    required this.source,
    this.audioPath,
  });

  final String id;
  final String itemId;
  final String imagePath;
  final String? audioPath;
  final int order;

  /// Whether [imagePath] actually shipped as a bundled asset (computed at seed
  /// time). When false the UI shows an emoji fallback instead.
  final bool hasImage;
  final ContentSource source;
}

class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mode,
    required this.choicesCount,
    required this.sessionLength,
    required this.activeWindowSize,
    required this.masteryThreshold,
  });

  final String id;
  final String name;
  final String avatar;
  final ProfileMode mode;
  final int choicesCount;
  final int sessionLength;
  final int activeWindowSize;
  final int masteryThreshold;

  ChildProfile copyWith({
    String? name,
    String? avatar,
    ProfileMode? mode,
    int? choicesCount,
    int? sessionLength,
    int? activeWindowSize,
    int? masteryThreshold,
  }) {
    return ChildProfile(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      mode: mode ?? this.mode,
      choicesCount: choicesCount ?? this.choicesCount,
      sessionLength: sessionLength ?? this.sessionLength,
      activeWindowSize: activeWindowSize ?? this.activeWindowSize,
      masteryThreshold: masteryThreshold ?? this.masteryThreshold,
    );
  }
}

/// Per-child × item learning state — the engine's working record.
class LearningState {
  const LearningState({
    required this.id,
    required this.childId,
    required this.itemId,
    required this.status,
    required this.leitnerBox,
    required this.consecutiveCorrect,
    required this.timesSeen,
    this.lastSeen,
    this.nextDue,
    this.lastExemplarId,
    this.admittedAt,
  });

  final String id;
  final String childId;
  final String itemId;
  final ItemStatus status;
  final int leitnerBox; // 1..5
  final int consecutiveCorrect;
  final int timesSeen;
  final DateTime? lastSeen;
  final DateTime? nextDue;
  final String? lastExemplarId;
  final DateTime? admittedAt;

  LearningState copyWith({
    ItemStatus? status,
    int? leitnerBox,
    int? consecutiveCorrect,
    int? timesSeen,
    DateTime? lastSeen,
    DateTime? nextDue,
    String? lastExemplarId,
    DateTime? admittedAt,
  }) {
    return LearningState(
      id: id,
      childId: childId,
      itemId: itemId,
      status: status ?? this.status,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      timesSeen: timesSeen ?? this.timesSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      nextDue: nextDue ?? this.nextDue,
      lastExemplarId: lastExemplarId ?? this.lastExemplarId,
      admittedAt: admittedAt ?? this.admittedAt,
    );
  }
}

class SessionInfo {
  const SessionInfo({
    required this.id,
    required this.childId,
    required this.startedAt,
    this.endedAt,
    this.itemsSeen = 0,
    this.correctCount = 0,
  });

  final String id;
  final String childId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int itemsSeen;
  final int correctCount;
}

/// An encouragement *word* (e.g. «شاطر»). Its voice clips live in [Sound]s.
class Praise {
  const Praise({
    required this.id,
    required this.label,
    required this.source,
    required this.enabled,
  });

  final String id;
  final String label;
  final ContentSource source;
  final bool enabled;
}

/// One voice clip for an item or praise word. Many can share an owner; a random
/// enabled one is played. [audioPath] may be a bundled asset, a `data:` URI, or
/// a native file path.
class Sound {
  const Sound({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.audioPath,
    required this.source,
    required this.enabled,
    this.label,
    this.orderIndex = 0,
  });

  final String id;
  final SoundOwner ownerType;
  final String ownerId;
  final String? label;
  final String audioPath;
  final ContentSource source;
  final bool enabled;
  final int orderIndex;

  bool get isAsset => audioPath.startsWith('assets/');
}

class TrialLog {
  const TrialLog({
    required this.id,
    required this.childId,
    required this.sessionId,
    required this.itemId,
    required this.chosenItemId,
    required this.correct,
    required this.timestamp,
    required this.choicesCount,
    this.exemplarId,
    this.isRetry = false,
  });

  final String id;
  final String childId;
  final String sessionId;
  final String itemId; // the target / correct answer
  final String chosenItemId; // what the child tapped
  final bool correct;
  final DateTime timestamp;
  final int choicesCount;
  final String? exemplarId;
  final bool isRetry;
}
