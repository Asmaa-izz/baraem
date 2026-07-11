import 'package:flutter/material.dart';

/// Gentle, slow motion vocabulary (DESIGN.md: "حركة لطيفة وبطيئة").
abstract final class BaraemMotion {
  static const Duration enter = Duration(milliseconds: 400);
  static const Duration crossFade = Duration(milliseconds: 320);
  static const Duration grow = Duration(milliseconds: 700);
  static const Duration feedback = Duration(milliseconds: 300);
  static const Duration stagger = Duration(milliseconds: 60);

  /// No bounce/overshoot — calm easing only.
  static const Curve curve = Curves.easeOutCubic;
}

/// Whether animations should play. Honors the OS "reduce motion" accessibility
/// setting and, on web, `prefers-reduced-motion: reduce`.
bool motionOn(BuildContext context) => !MediaQuery.of(context).disableAnimations;

/// A duration that collapses to [Duration.zero] when reduced-motion is on, so
/// the end-state renders instantly instead of animating.
Duration motionDuration(BuildContext context, Duration d) =>
    motionOn(context) ? d : Duration.zero;
