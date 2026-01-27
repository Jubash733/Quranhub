class QuranTextNormalizer {
  static final RegExp _diacritics =
      RegExp(r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06ED]');
  static final RegExp _tatweel = RegExp(r'\u0640');
  static final RegExp _whitespace = RegExp(r'\s+');
  static final RegExp _nonLetterDigits =
      RegExp(r'[^\u0600-\u06FF0-9\s]');

  static String normalizeArabic(String text) {
    var normalized = text.toLowerCase();
    normalized = normalized.replaceAll(_diacritics, '');
    normalized = normalized.replaceAll(_tatweel, '');
    normalized = normalized
        .replaceAll('\u0623', '\u0627')
        .replaceAll('\u0625', '\u0627')
        .replaceAll('\u0622', '\u0627')
        .replaceAll('\u0649', '\u064a')
        .replaceAll('\u0624', '\u0648')
        .replaceAll('\u0626', '\u064a')
        .replaceAll('\u0629', '\u0647');
    normalized = normalized.replaceAll(_nonLetterDigits, ' ');
    normalized = normalized.replaceAll(_whitespace, ' ').trim();
    return normalized;
  }

  static String buildFtsQuery(String text) {
    final normalized = normalizeArabic(text);
    if (normalized.isEmpty) {
      return '';
    }
    final tokens = normalized
        .split(' ')
        .where((token) => token.trim().isNotEmpty)
        .map((token) => '${token.trim()}*')
        .toList();
    if (tokens.isEmpty) {
      return '';
    }
    return tokens.join(' AND ');
  }
}
