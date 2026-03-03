/// Normalizes Arabic text for search: remove diacritics (tashkeel),
/// normalize alef/yeh/hamza variants so search matches regardless of form.
String normalizeArabic(String text) {
  if (text.isEmpty) return text;
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    final c = String.fromCharCode(rune);
    if (_isTashkeel(c)) continue;
    buffer.write(_normalizeChar(c));
  }
  return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
}

bool _isTashkeel(String c) {
  const tashkeel = [
    '\u064B', '\u064C', '\u064D', '\u064E', '\u064F', '\u0650',
    '\u0651', '\u0652', '\u0653', '\u0654', '\u0655', '\u0656',
    '\u0657', '\u0658', '\u0659', '\u065A', '\u065B', '\u065C',
    '\u065D', '\u065E', '\u065F',
  ];
  return tashkeel.contains(c);
}

String _normalizeChar(String c) {
  switch (c) {
    case 'أ':
    case 'إ':
    case 'آ':
    case 'ٱ':
      return 'ا';
    case 'ة':
      return 'ه';
    case 'ى':
      return 'ي';
    case 'ؤ':
      return 'و';
    case 'ئ':
      return 'ي';
    default:
      return c;
  }
}
