import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/app_theme.dart';
import '../theme/context_ext.dart';

enum FeedbackKind { none, correct, hint }

/// Height-reserving feedback line under the quiz choices. Correct → sage-deep
/// "أحسنت!"; wrong → honey "جرّب تاني". Never red, never a failure symbol.
class FeedbackBanner extends StatelessWidget {
  const FeedbackBanner({super.key, required this.kind, this.text});

  final FeedbackKind kind;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (kind) {
      FeedbackKind.correct => colors.sageDeep,
      FeedbackKind.hint => colors.retry,
      FeedbackKind.none => Colors.transparent,
    };

    return SizedBox(
      height: 52,
      child: Center(
        child: AnimatedSwitcher(
          duration: motionDuration(context, BaraemMotion.feedback),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: kind == FeedbackKind.none || text == null
              ? const SizedBox.shrink()
              : Row(
                  key: ValueKey('$kind$text'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kind == FeedbackKind.correct ? '🎉 ' : '💡 ',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      text!,
                      style: TextStyle(
                        fontFamily: kDisplayFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
