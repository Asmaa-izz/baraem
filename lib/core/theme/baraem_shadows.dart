import 'package:flutter/material.dart';

/// Soft elevation shadows from `docs/design-direction.html` (`--shadow`,
/// `--shadow-soft`). Brightness-variant, so a [ThemeExtension].
@immutable
class BaraemShadows extends ThemeExtension<BaraemShadows> {
  const BaraemShadows({required this.soft, required this.regular});

  /// Subtle lift for cards/tiles (`--shadow-soft`).
  final List<BoxShadow> soft;

  /// Stronger lift for floating containers (`--shadow`).
  final List<BoxShadow> regular;

  static const light = BaraemShadows(
    soft: [
      BoxShadow(
        color: Color(0x0F3B352E), // rgba(59,53,46,.06)
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
    regular: [
      BoxShadow(
        color: Color(0x173B352E), // rgba(59,53,46,.09)
        blurRadius: 22,
        offset: Offset(0, 6),
      ),
    ],
  );

  static const dark = BaraemShadows(
    soft: [
      BoxShadow(
        color: Color(0x47000000), // rgba(0,0,0,.28)
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
    regular: [
      BoxShadow(
        color: Color(0x59000000), // rgba(0,0,0,.35)
        blurRadius: 24,
        offset: Offset(0, 6),
      ),
    ],
  );

  @override
  BaraemShadows copyWith({List<BoxShadow>? soft, List<BoxShadow>? regular}) {
    return BaraemShadows(soft: soft ?? this.soft, regular: regular ?? this.regular);
  }

  @override
  BaraemShadows lerp(ThemeExtension<BaraemShadows>? other, double t) {
    if (other is! BaraemShadows) return this;
    return BaraemShadows(
      soft: BoxShadow.lerpList(soft, other.soft, t) ?? soft,
      regular: BoxShadow.lerpList(regular, other.regular, t) ?? regular,
    );
  }
}
