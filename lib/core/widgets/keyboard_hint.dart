import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// A faint keyboard hint, shown only on web where a keyboard is present.
class KeyboardHint extends StatelessWidget {
  const KeyboardHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 13,
        color: context.colors.ink2,
      ),
    );
  }
}
