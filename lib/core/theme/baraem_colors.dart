import 'package:flutter/material.dart';

import 'baraem_palette.dart';

/// The full "garden" semantic palette, exposed as a [ThemeExtension] so widgets
/// can read `Theme.of(context).extension<BaraemColors>()!` (see
/// `context.colors` in `context_ext.dart`) for the colors Material's
/// [ColorScheme] does not model.
@immutable
class BaraemColors extends ThemeExtension<BaraemColors> {
  const BaraemColors({
    required this.ground,
    required this.card,
    required this.ink,
    required this.ink2,
    required this.sage,
    required this.sageDeep,
    required this.sky,
    required this.apricot,
    required this.honey,
    required this.lavender,
    required this.correct,
    required this.retry,
    required this.line,
    required this.lineStrong,
    required this.glow,
    required this.onAccent,
  });

  final Color ground;
  final Color card;
  final Color ink;
  final Color ink2;

  final Color sage;
  final Color sageDeep;
  final Color sky;
  final Color apricot;
  final Color honey;
  final Color lavender;

  /// Feedback colors — strictly no red anywhere in the app.
  final Color correct;
  final Color retry;

  final Color line;
  final Color lineStrong;

  /// Sage at low alpha — the soft ring around a correct choice.
  final Color glow;

  /// Text/icon color to place on top of a filled accent (sage/sky) surface.
  final Color onAccent;

  /// Guidance color for a content category (DESIGN.md "لون لكل مجموعة").
  Color category(String id) => switch (id) {
        'household' => sage, // أدوات المطبخ
        'animals' => sky, // حيوانات
        'birds' => lavender, // الطيور
        'home' => sageDeep, // أدوات المنزل
        'fruits' => apricot, // فواكه
        'vegetables' => honey, // الخضراوات
        'colors' => lavender, // ألوان وأشكال
        _ => sage,
      };

  static const light = BaraemColors(
    ground: BaraemPalette.groundL,
    card: BaraemPalette.cardL,
    ink: BaraemPalette.inkL,
    ink2: BaraemPalette.ink2L,
    sage: BaraemPalette.sageL,
    sageDeep: BaraemPalette.sageDeepL,
    sky: BaraemPalette.skyL,
    apricot: BaraemPalette.apricotL,
    honey: BaraemPalette.honeyL,
    lavender: BaraemPalette.lavenderL,
    correct: BaraemPalette.correctL,
    retry: BaraemPalette.retryL,
    line: BaraemPalette.lineL,
    lineStrong: BaraemPalette.lineStrongL,
    glow: BaraemPalette.glowL,
    onAccent: BaraemPalette.white,
  );

  static const dark = BaraemColors(
    ground: BaraemPalette.groundD,
    card: BaraemPalette.cardD,
    ink: BaraemPalette.inkD,
    ink2: BaraemPalette.ink2D,
    sage: BaraemPalette.sageD,
    sageDeep: BaraemPalette.sageDeepD,
    sky: BaraemPalette.skyD,
    apricot: BaraemPalette.apricotD,
    honey: BaraemPalette.honeyD,
    lavender: BaraemPalette.lavenderD,
    correct: BaraemPalette.correctD,
    retry: BaraemPalette.retryD,
    line: BaraemPalette.lineD,
    lineStrong: BaraemPalette.lineStrongD,
    glow: BaraemPalette.glowD,
    // Dark-mode sage is a light tint → dark ink reads better on it.
    onAccent: BaraemPalette.inkOnSageDark,
  );

  @override
  BaraemColors copyWith({
    Color? ground,
    Color? card,
    Color? ink,
    Color? ink2,
    Color? sage,
    Color? sageDeep,
    Color? sky,
    Color? apricot,
    Color? honey,
    Color? lavender,
    Color? correct,
    Color? retry,
    Color? line,
    Color? lineStrong,
    Color? glow,
    Color? onAccent,
  }) {
    return BaraemColors(
      ground: ground ?? this.ground,
      card: card ?? this.card,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      sage: sage ?? this.sage,
      sageDeep: sageDeep ?? this.sageDeep,
      sky: sky ?? this.sky,
      apricot: apricot ?? this.apricot,
      honey: honey ?? this.honey,
      lavender: lavender ?? this.lavender,
      correct: correct ?? this.correct,
      retry: retry ?? this.retry,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      glow: glow ?? this.glow,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  BaraemColors lerp(ThemeExtension<BaraemColors>? other, double t) {
    if (other is! BaraemColors) return this;
    return BaraemColors(
      ground: Color.lerp(ground, other.ground, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      sage: Color.lerp(sage, other.sage, t)!,
      sageDeep: Color.lerp(sageDeep, other.sageDeep, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      apricot: Color.lerp(apricot, other.apricot, t)!,
      honey: Color.lerp(honey, other.honey, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      correct: Color.lerp(correct, other.correct, t)!,
      retry: Color.lerp(retry, other.retry, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}
