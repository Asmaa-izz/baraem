import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';
import '../utils/arabic_numbers.dart';

/// Filled/empty dots showing PIN entry progress.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.length, required this.filled});

  final int length;
  final int filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BaraemSpace.xs),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled ? colors.sage : Colors.transparent,
                border: Border.all(color: colors.lineStrong, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

/// A calm numeric keypad with large, rounded keys (Arabic-Indic digits).
class PinPad extends StatelessWidget {
  const PinPad({super.key, required this.onDigit, required this.onDelete});

  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (final d in row) _Key(digit: d, onDigit: onDigit)],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _KeySpacer(),
            _Key(digit: 0, onDigit: onDigit),
            _Key.icon(icon: Icons.backspace_outlined, onTap: onDelete),
          ],
        ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.digit, required this.onDigit})
      : icon = null,
        onTap = null;
  const _Key.icon({required this.icon, required this.onTap})
      : digit = null,
        onDigit = null;

  final int? digit;
  final ValueChanged<int>? onDigit;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(BaraemSpace.xs),
      child: Material(
        color: colors.card,
        shape: CircleBorder(side: BorderSide(color: colors.line)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: digit != null ? () => onDigit!(digit!) : onTap,
          child: SizedBox(
            width: BaraemSize.minTouch,
            height: BaraemSize.minTouch,
            child: Center(
              child: icon != null
                  ? Icon(icon, color: colors.ink2)
                  : Text(
                      toArabicDigits('$digit'),
                      style: const TextStyle(
                        fontFamily: kDisplayFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeySpacer extends StatelessWidget {
  const _KeySpacer();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(BaraemSpace.xs),
        child: SizedBox(width: BaraemSize.minTouch, height: BaraemSize.minTouch),
      );
}
