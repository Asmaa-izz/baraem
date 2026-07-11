import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// Visual state of a quiz choice. There is no "wrong" state that punishes:
/// a wrong tap shows a gentle honey [hint] and the correct card is revealed.
enum ChoiceState { idle, correct, hint }

/// A quiz answer tile. Idle = neutral bordered card; correct = sage border +
/// soft glow ring + ✓ tick; hint = calm honey outline (never red).
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.child,
    required this.onTap,
    this.state = ChoiceState.idle,
    this.focused = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final ChoiceState state;

  /// Keyboard focus highlight (sky ring) for web users.
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final br = BorderRadius.circular(BaraemRadii.lg);

    final (borderColor, borderWidth) = switch (state) {
      ChoiceState.idle => (colors.lineStrong, 2.0),
      ChoiceState.correct => (colors.sage, 3.0),
      ChoiceState.hint => (colors.retry, 3.0),
    };

    final boxShadow = <BoxShadow>[
      ...context.shadows.soft,
      if (state == ChoiceState.correct)
        BoxShadow(color: colors.glow, blurRadius: 0, spreadRadius: 4),
      if (focused && state == ChoiceState.idle)
        BoxShadow(
          color: colors.sky.withValues(alpha: 0.5),
          blurRadius: 0,
          spreadRadius: 3,
        ),
    ];

    final card = AspectRatio(
      aspectRatio: 1,
      child: AnimatedContainer(
        duration: motionDuration(context, BaraemMotion.feedback),
        curve: BaraemMotion.curve,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: br,
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: br,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  if (state == ChoiceState.correct)
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 8,
                      start: 8,
                      child: const _Tick(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // A gentle one-shot "pop" when this tile becomes the correct answer.
    if (state == ChoiceState.correct && motionOn(context)) {
      return TweenAnimationBuilder<double>(
        key: const ValueKey('pop'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
        builder: (context, t, child) {
          // up to 1.06 then back to 1.0
          final scale = 1 + 0.06 * (t < 0.5 ? t * 2 : (1 - t) * 2);
          return Transform.scale(scale: scale, child: child);
        },
        child: card,
      );
    }
    return card;
  }
}

/// The gentle ✓ badge shown on the correct choice.
class _Tick extends StatelessWidget {
  const _Tick();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget tick = Container(
      width: BaraemSize.tick,
      height: BaraemSize.tick,
      decoration: BoxDecoration(color: colors.sageDeep, shape: BoxShape.circle),
      child: Icon(Icons.check_rounded, size: 18, color: colors.onAccent),
    );
    if (motionOn(context)) {
      tick = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.7, end: 1),
        duration: BaraemMotion.feedback,
        curve: BaraemMotion.curve,
        builder: (context, v, child) =>
            Transform.scale(scale: v, child: Opacity(opacity: v, child: child)),
        child: tick,
      );
    }
    return tick;
  }
}
