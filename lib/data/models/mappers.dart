import '../db/app_database.dart';
import 'domain.dart';

/// Maps generated Drift rows to plain domain models.

extension CategoryRowMapper on CategoryRow {
  Category toDomain() => Category(
        id: id,
        name: name,
        icon: icon,
        order: orderIndex,
        source: source,
      );
}

extension ItemRowMapper on ItemRow {
  Item toDomain() => Item(
        id: id,
        label: label,
        categoryId: categoryId,
        source: source,
        speech: speech,
        audioPath: audioPath,
      );
}

extension ExemplarRowMapper on ExemplarRow {
  Exemplar toDomain() => Exemplar(
        id: id,
        itemId: itemId,
        imagePath: imagePath,
        audioPath: audioPath,
        order: orderIndex,
        hasImage: hasImage,
        source: source,
      );
}

extension ChildProfileRowMapper on ChildProfileRow {
  ChildProfile toDomain() => ChildProfile(
        id: id,
        name: name,
        avatar: avatar,
        mode: mode,
        choicesCount: choicesCount,
        sessionLength: sessionLength,
        activeWindowSize: activeWindowSize,
        masteryThreshold: masteryThreshold,
      );
}

extension LearningStateRowMapper on LearningStateRow {
  LearningState toDomain() => LearningState(
        id: id,
        childId: childId,
        itemId: itemId,
        status: status,
        leitnerBox: leitnerBox,
        consecutiveCorrect: consecutiveCorrect,
        timesSeen: timesSeen,
        lastSeen: lastSeen,
        nextDue: nextDue,
        lastExemplarId: lastExemplarId,
        admittedAt: admittedAt,
      );
}

extension PraiseRowMapper on PraiseRow {
  Praise toDomain() => Praise(
        id: id,
        label: label,
        audioPath: audioPath,
        source: source,
        enabled: enabled,
      );
}

extension SessionRowMapper on SessionRow {
  SessionInfo toDomain() => SessionInfo(
        id: id,
        childId: childId,
        startedAt: startedAt,
        endedAt: endedAt,
        itemsSeen: itemsSeen,
        correctCount: correctCount,
      );
}
