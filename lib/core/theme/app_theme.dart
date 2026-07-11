import 'package:flutter/material.dart';

import 'baraem_colors.dart';
import 'baraem_shadows.dart';
import 'baraem_tokens.dart';

/// Font families (bundled locally in `assets/fonts`, declared in pubspec).
const String kDisplayFont = 'Baloo Bhaijaan 2'; // the word the child sees
const String kBodyFont = 'Tajawal'; // UI, body, reports

/// Builds the full app [ThemeData] for a given [brightness].
///
/// Material's [ColorScheme] carries the few colors framework widgets consume;
/// the richer "garden" palette lives in the [BaraemColors] extension.
ThemeData buildBaraemTheme(Brightness brightness) {
  final isLight = brightness == Brightness.light;
  final c = isLight ? BaraemColors.light : BaraemColors.dark;
  final shadows = isLight ? BaraemShadows.light : BaraemShadows.dark;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.sageDeep,
    onPrimary: c.onAccent,
    secondary: c.sky,
    onSecondary: c.onAccent,
    tertiary: c.lavender,
    onTertiary: c.ink,
    surface: c.card,
    onSurface: c.ink,
    surfaceContainerHighest: c.ground,
    surfaceContainerLow: c.card,
    onSurfaceVariant: c.ink2,
    outline: c.lineStrong,
    outlineVariant: c.line,
    // STRICT: never red. Framework "error" states surface as calm honey.
    error: c.retry,
    onError: c.ink,
  );

  final textTheme = _buildTextTheme(c.ink, c.ink2);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.ground,
    fontFamily: kBodyFont,
    textTheme: textTheme,
    splashFactory: InkSparkle.splashFactory,
    extensions: <ThemeExtension<dynamic>>[c, shadows],
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.sageDeep,
        foregroundColor: c.onAccent,
        minimumSize: const Size(BaraemSize.button, BaraemSize.button),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BaraemRadii.md),
        ),
        textStyle: const TextStyle(
          fontFamily: kBodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.sageDeep,
        minimumSize: const Size(BaraemSize.minTouch, BaraemSize.minTouch),
        textStyle: const TextStyle(
          fontFamily: kBodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.card,
      hintStyle: TextStyle(color: c.ink2, fontFamily: kBodyFont),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: BaraemSpace.md,
        vertical: BaraemSpace.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BaraemRadii.md),
        borderSide: BorderSide(color: c.lineStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BaraemRadii.md),
        borderSide: BorderSide(color: c.lineStrong),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BaraemRadii.md),
        borderSide: BorderSide(color: c.sage, width: 2),
      ),
    ),
    dividerColor: c.line,
    iconTheme: IconThemeData(color: c.ink),
  );
}

/// Display / heading styles use the rounded [kDisplayFont]; body/label use the
/// clean [kBodyFont]. The child's word uses [TextTheme.displayMedium] (≥ 32px);
/// UI text stays ≥ 18px for legibility (important for support-mode kids).
TextTheme _buildTextTheme(Color ink, Color ink2) {
  // Baloo Bhaijaan 2 is a variable font; drive its weight via the `wght` axis
  // as well as fontWeight so bold renders consistently across platforms.
  TextStyle display(double size) => TextStyle(
        fontFamily: kDisplayFont,
        fontSize: size,
        height: 1.15,
        fontWeight: FontWeight.w700,
        fontVariations: const [FontVariation('wght', 700)],
        color: ink,
      );

  TextStyle body(double size, FontWeight weight, {Color? color}) => TextStyle(
        fontFamily: kBodyFont,
        fontSize: size,
        height: 1.4,
        fontWeight: weight,
        color: color ?? ink,
      );

  return TextTheme(
    displayLarge: display(44),
    displayMedium: display(34), // the child's word
    displaySmall: display(30),
    headlineMedium: display(26), // quiz question "وين X؟"
    headlineSmall: display(22),
    titleLarge: display(22),
    titleMedium: display(19),
    bodyLarge: body(19, FontWeight.w500),
    bodyMedium: body(18, FontWeight.w400),
    bodySmall: body(15, FontWeight.w400, color: ink2),
    labelLarge: body(19, FontWeight.w700), // buttons
    labelMedium: body(15, FontWeight.w500, color: ink2),
  );
}

/// A [TextStyle] with tabular figures for parent-dashboard numbers
/// (DESIGN.md: use `tabular-nums`).
const TextStyle kTabularNumbers = TextStyle(
  fontFamily: kBodyFont,
  fontFeatures: [FontFeature.tabularFigures()],
);
