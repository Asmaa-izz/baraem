import 'package:flutter/material.dart';

import 'baraem_colors.dart';
import 'baraem_shadows.dart';

/// Ergonomic access to the Baraem theme extensions and text styles.
extension BaraemContext on BuildContext {
  BaraemColors get colors => Theme.of(this).extension<BaraemColors>()!;
  BaraemShadows get shadows => Theme.of(this).extension<BaraemShadows>()!;
  TextTheme get texts => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
