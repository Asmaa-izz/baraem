import 'package:flutter/material.dart';

import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// The surface primitive: card background, large rounded corners, a soft
/// shadow and a hairline border. Optionally tappable with a matching ink ripple.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(BaraemSpace.md),
    this.radius = BaraemRadii.lg,
    this.onTap,
    this.borderColor,
    this.borderWidth = 1,
    this.color,
    this.shadow = true,
    this.startBorderAccent,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double borderWidth;
  final Color? color;
  final bool shadow;

  /// A 4px accent bar on the inline-start edge (used by category cards).
  final Color? startBorderAccent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final br = BorderRadius.circular(radius);

    Widget content = Padding(padding: padding, child: child);

    if (startBorderAccent != null) {
      content = Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: startBorderAccent!, width: 4),
          ),
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.card,
        borderRadius: br,
        border: Border.all(
          color: borderColor ?? colors.line,
          width: borderWidth,
        ),
        boxShadow: shadow ? context.shadows.soft : null,
      ),
      child: ClipRRect(
        borderRadius: br,
        child: onTap == null
            ? content
            : Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap, child: content),
              ),
      ),
    );
  }
}
