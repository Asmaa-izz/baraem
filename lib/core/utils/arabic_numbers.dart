/// Converts Western digits in [input] to Arabic-Indic digits (٠-٩).
///
/// Used for child-facing and parent-facing numerals so the RTL Arabic UI reads
/// naturally. The underlying values stay as normal integers.
String toArabicDigits(String input) {
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      buffer.write(arabic[rune - 0x30]);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Formats [n] as Arabic-Indic digits.
String arabicNumber(int n) => toArabicDigits('$n');
