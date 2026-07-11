import 'package:flutter/painting.dart';

/// Raw color constants from `docs/DESIGN.md` / `docs/design-direction.html`.
///
/// These are the source-of-truth hex values. Semantic access happens through
/// [BaraemColors] (a [ThemeExtension]); widgets should read `context.colors`,
/// not these constants directly.
abstract final class BaraemPalette {
  // ---- Light: warm neutrals ----
  static const groundL = Color(0xFFF5EDE2); // ground — screen background
  static const cardL = Color(0xFFFFFDF8); // card — surfaces
  static const inkL = Color(0xFF3B352E); // ink — primary text
  static const ink2L = Color(0xFF8A8175); // ink-2 — secondary text

  // ---- Light: garden accents ----
  static const sageL = Color(0xFF6FA47D); // primary · growth · correct
  static const sageDeepL = Color(0xFF5E9670); // deeper primary (buttons on white)
  static const skyL = Color(0xFF8FBEDC); // calm action · links · speaker
  static const apricotL = Color(0xFFF0B98D); // warmth · highlight
  static const honeyL = Color(0xFFF2CE7E); // reward · stars
  static const lavenderL = Color(0xFFB9A9D6); // secondary · classify

  // ---- Light: feedback (never red) ----
  static const correctL = Color(0xFF5E9670); // "صح"
  static const retryL = Color(0xFFE8B96A); // "جرّب تاني"

  // ---- Light: hairlines ----
  static const lineL = Color(0x1A3B352E); // rgba(59,53,46,.10)
  static const lineStrongL = Color(0x293B352E); // rgba(59,53,46,.16)
  static const glowL = Color(0x476FA47D); // sage @ .28 — correct ring

  // ---- Dark: warm night (not harsh black) ----
  static const groundD = Color(0xFF242019);
  static const cardD = Color(0xFF302A22);
  static const inkD = Color(0xFFEFE7DA);
  static const ink2D = Color(0xFFA99F90);

  static const sageD = Color(0xFF89C098);
  static const sageDeepD = Color(0xFF89C098);
  static const skyD = Color(0xFF9CC8E4);
  static const apricotD = Color(0xFFF2C09A);
  static const honeyD = Color(0xFFF2D488);
  static const lavenderD = Color(0xFFC6B6E2);

  static const correctD = Color(0xFF89C098);
  static const retryD = Color(0xFFEBC073);

  static const lineD = Color(0x1AEFE7DA);
  static const lineStrongD = Color(0x29EFE7DA);
  static const glowD = Color(0x4789C098);

  // ---- Fixed ----
  static const white = Color(0xFFFFFFFF);
  /// Text/icon color on top of the (light) dark-mode sage, which is a light tint.
  static const inkOnSageDark = Color(0xFF242019);
}
