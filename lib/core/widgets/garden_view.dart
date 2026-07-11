import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// The cumulative reward: a garden that grows one plant per mastered word.
/// No points, no timer, no loss — pure positive accumulation (DESIGN.md).
class GardenView extends StatelessWidget {
  const GardenView({
    super.key,
    required this.count,
    this.newlyEarnedIndex,
  });

  final int count;

  /// Index of the plant earned just now; it sprouts with a gentle grow.
  final int? newlyEarnedIndex;

  static const _plants = ['🌱', '🌿', '🌷', '🌻', '🌼', '🪴', '🌸', '🍀'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BaraemSpace.lg),
      decoration: BoxDecoration(
        color: Color.alphaBlend(colors.sage.withValues(alpha: 0.12), colors.card),
        borderRadius: BorderRadius.circular(BaraemRadii.container),
        border: Border.all(color: colors.line),
      ),
      child: count == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🌱', style: TextStyle(fontSize: 56, color: colors.ink2)),
                const SizedBox(height: BaraemSpace.sm),
                Text('حديقتك تنتظر أول كلمة', style: context.texts.bodyMedium),
              ],
            )
          : Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: BaraemSpace.sm,
              runSpacing: BaraemSpace.sm,
              children: [
                for (var i = 0; i < count; i++)
                  _Plant(
                    emoji: _plants[i % _plants.length],
                    isNew: i == newlyEarnedIndex,
                  ),
              ],
            ),
    );
  }
}

class _Plant extends StatelessWidget {
  const _Plant({required this.emoji, required this.isNew});

  final String emoji;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    Widget plant = Text(emoji, style: const TextStyle(fontSize: 40, height: 1));
    if (isNew && motionOn(context)) {
      plant = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.6, end: 1),
        duration: BaraemMotion.grow,
        curve: BaraemMotion.curve,
        builder: (context, v, child) => Transform.scale(
          scale: v,
          alignment: Alignment.bottomCenter,
          child: Opacity(opacity: v.clamp(0, 1), child: child),
        ),
        child: plant,
      );
    }
    return plant;
  }
}
