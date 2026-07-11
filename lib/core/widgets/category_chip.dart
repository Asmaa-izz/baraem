import 'package:flutter/material.dart';

import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// A small pill label (the `.scr-cat` tag): card background, secondary ink,
/// hairline border. Optionally carries a leading category color dot.
class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, this.dotColor});

  final String label;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BaraemSpace.md,
        vertical: BaraemSpace.xs,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(BaraemRadii.pill),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: BaraemSpace.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colors.ink2,
            ),
          ),
        ],
      ),
    );
  }
}
