import 'package:flutter/material.dart';

import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// The app's calm, large-target button. Min height 64 for small fingers,
/// rounded, no harsh elevation. Icons use directional placement so "forward"
/// reads correctly under RTL.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.trailingIcon,
    this.leadingIcon,
    this.fullWidth = false,
    this.minHeight = BaraemSize.button,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.leadingIcon,
    this.fullWidth = true,
    this.minHeight = BaraemSize.button,
  }) : variant = AppButtonVariant.primary;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final bool fullWidth;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (bg, fg) = switch (variant) {
      AppButtonVariant.primary => (colors.sageDeep, colors.onAccent),
      AppButtonVariant.secondary => (colors.sky, colors.onAccent),
      AppButtonVariant.ghost => (Colors.transparent, colors.sageDeep),
    };
    final disabled = onPressed == null;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, color: fg, size: 24),
          const SizedBox(width: BaraemSpace.sm),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: fg,
            ),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: BaraemSpace.sm),
          Icon(trailingIcon, color: fg, size: 24),
        ],
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(BaraemRadii.md),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(BaraemRadii.md),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: BaraemSpace.lg,
              vertical: BaraemSpace.sm,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
