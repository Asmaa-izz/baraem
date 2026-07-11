import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// Shown in place of a missing content image. Uses a per-seed calm pastel
/// background plus the item's emoji, so tiles stay visually distinguishable
/// (crucial in quiz mode, where two identical tiles would be unwinnable) and
/// never reveal the item's word.
class EmojiFallback extends StatelessWidget {
  const EmojiFallback({
    super.key,
    required this.emoji,
    this.seed = '',
    this.fontSize,
  });

  final String emoji;
  final String seed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = [
      colors.sage,
      colors.sky,
      colors.apricot,
      colors.honey,
      colors.lavender,
    ];
    final idx = (seed.isEmpty ? emoji : seed).hashCode.abs() % palette.length;
    final tint = palette[idx];
    final bg = Color.alphaBlend(tint.withValues(alpha: 0.16), colors.card);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = fontSize ??
            (constraints.hasBoundedHeight
                ? constraints.maxHeight * 0.42
                : 56.0);
        return Container(
          color: bg,
          alignment: Alignment.center,
          child: Text(emoji, style: TextStyle(fontSize: size, height: 1)),
        );
      },
    );
  }
}
