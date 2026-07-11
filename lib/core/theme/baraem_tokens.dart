/// Brightness-invariant design tokens from `docs/DESIGN.md`.
///
/// Radii, spacing and sizes do not change between light and dark, so they are
/// plain constants rather than a [ThemeExtension].
library;

abstract final class BaraemRadii {
  static const double sm = 12; // --r-sm
  static const double md = 18; // --r-md
  static const double lg = 26; // --r-lg
  static const double container = 32; // device / large containers
  static const double pill = 999; // fully rounded chips/avatars
}

abstract final class BaraemSpace {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 32;
  static const double xxl = 48;
}

abstract final class BaraemSize {
  /// Minimum touch target for small fingers (DESIGN.md: ≥ 64px).
  static const double minTouch = 64;
  static const double button = 64;
  static const double speaker = 64;
  static const double tick = 28; // correct-badge circle
  static const double avatar = 96;
  static const double categoryDot = 12;
}
