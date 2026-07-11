import 'package:flutter/material.dart';

import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';

/// The base screen surface: ground background, safe area, and consistent
/// directional padding. Keeps one focused layout with generous whitespace.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(BaraemSpace.lg),
    this.top,
    this.safeArea = true,
    this.maxWidth = 720,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Optional row pinned above [child] (e.g. category chip + progress dots).
  final Widget? top;
  final bool safeArea;

  /// Caps content width and centers it on wide (web) screens.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding,
      child: top == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                top!,
                const SizedBox(height: BaraemSpace.md),
                Expanded(child: child),
              ],
            ),
    );
    if (maxWidth != null) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: content,
        ),
      );
    }
    if (safeArea) content = SafeArea(child: content);
    return Scaffold(backgroundColor: context.colors.ground, body: content);
  }
}
