import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../theme/context_ext.dart';

/// The calm "listen" affordance: a sky circle with a speaker glyph. Gently
/// pulses while audio plays (unless reduced-motion is on).
class SpeakerButton extends StatelessWidget {
  const SpeakerButton({
    super.key,
    required this.onPressed,
    this.isPlaying = false,
    this.diameter = 56,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final bool isPlaying;
  final double diameter;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget button = Material(
      color: colors.sky,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: Icon(
            isPlaying ? Icons.volume_up_rounded : Icons.volume_up_rounded,
            color: colors.onAccent,
            size: diameter * 0.45,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    if (isPlaying && motionOn(context)) {
      button = TweenAnimationBuilder<double>(
        key: const ValueKey('pulse'),
        tween: Tween(begin: 0.96, end: 1.04),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: button,
      );
    }
    return button;
  }
}
