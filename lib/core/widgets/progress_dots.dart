import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// Session progress dots. The active dot is sage; the rest are faint hairlines.
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    super.key,
    required this.count,
    required this.index,
    this.maxDots = 8,
  });

  final int count;
  final int index;
  final int maxDots;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shown = count.clamp(1, maxDots);
    final activeDot = count <= maxDots
        ? index
        : (index * maxDots ~/ count).clamp(0, shown - 1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < shown; i++)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 5),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == activeDot ? colors.sage : colors.lineStrong,
              ),
            ),
          ),
      ],
    );
  }
}
