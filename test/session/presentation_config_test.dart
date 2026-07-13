import 'package:baraem/core/theme/baraem_tokens.dart';
import 'package:baraem/data/models/enums.dart';
import 'package:baraem/features/session/presentation/presentation_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PresentationConfig.forMode', () {
    test('support mode is calmer and clearer', () {
      final c = PresentationConfig.forMode(ProfileMode.support);
      expect(c.advanceDelay, const Duration(milliseconds: 2200));
      expect(c.gentleCelebration, isTrue);
      expect(c.spotlightAnswer, isTrue);
      expect(c.choiceSpacing, BaraemSpace.lg);
    });

    test('normal mode keeps the default presentation', () {
      final c = PresentationConfig.forMode(ProfileMode.normal);
      expect(c.advanceDelay, const Duration(milliseconds: 1150));
      expect(c.gentleCelebration, isFalse);
      expect(c.spotlightAnswer, isFalse);
      expect(c.choiceSpacing, BaraemSpace.md);
    });

    test('support pauses longer than normal on a correct answer', () {
      final support = PresentationConfig.forMode(ProfileMode.support);
      final normal = PresentationConfig.forMode(ProfileMode.normal);
      expect(support.advanceDelay, greaterThan(normal.advanceDelay));
    });
  });
}
