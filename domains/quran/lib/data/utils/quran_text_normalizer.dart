class QuranTextNormalizer {
  static final RegExp _diacritics =
      RegExp(r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06ED]');
  static final RegExp _tatweel = RegExp(r'\u0640');
  static final RegExp _whitespace = RegExp(r'\s+');
  static final RegExp _nonArabicLettersDigits =
      RegExp(r'[^\u0600-\u06FF0-9\s]');
  static final RegExp _nonSearchChars =
      RegExp(r'[^a-zA-Z\u0600-\u06FF0-9\s]');

  static bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  static String normalizeArabic(String text) {
    return _normalize(text, allowLatin: false);
  }

  static String normalizeForSearch(String text) {
    return _normalize(text, allowLatin: true);
  }

  static List<String> tokenize(String text) {
    final normalized = normalizeForSearch(text);
    if (normalized.isEmpty) return [];
    return normalized
        .split(' ')
        .where((token) => token.trim().isNotEmpty)
        .toList();
  }

  static String buildColumnQuery(String column, List<String> tokens) {
    final safeTokens = tokens.map((t) => '${t.trim()}*').toList();
    if (safeTokens.isEmpty) return '';
    return safeTokens.map((t) => '$column:$t').join(' AND ');
  }

  static String buildMultiColumnQuery(
    List<String> tokens,
    List<String> columns,
  ) {
    final clauses = columns
        .map((column) => buildColumnQuery(column, tokens))
        .where((clause) => clause.trim().isNotEmpty)
        .map((clause) => '($clause)')
        .toList();
    if (clauses.isEmpty) return '';
    return clauses.join(' OR ');
  }

  static String _normalize(String text, {required bool allowLatin}) {
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
    normalized = normalized.replaceAll(
      allowLatin ? _nonSearchChars : _nonArabicLettersDigits,
      ' ',
    );
    normalized = normalized.replaceAll(_whitespace, ' ').trim();
    return normalized;
  }
}
