class QuranTextNormalizer {
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
    String normalized = text;

    // Remove Diacritics (Tashkeel)
    // Fatha, Damma, Kasra, Sukun, Shadda, Tanween, etc.
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');

    // Remove Tatweel (Kashida)
    normalized = normalized.replaceAll('\u0640', '');

    // Normalize Aleph
    // (أ - إ - آ) -> (ا)
    normalized =
        normalized.replaceAll(RegExp(r'[\u0622\u0623\u0625\u0671]'), '\u0627');

    // Normalize Ya/Aleph Maqsura
    // (ى) -> (ي)
    normalized = normalized.replaceAll('\u0649', '\u064A');

    // Normalize Ta Marbuta
    // (ة) -> (ه)
    normalized = normalized.replaceAll('\u0629', '\u0647');

    // Normalize Waw with Hamza
    // (ؤ) -> (و)
    normalized = normalized.replaceAll('\u0624', '\u0648');

    // Normalize Ya with Hamza
    // (13) -> (ي)
    normalized = normalized.replaceAll('\u0626', '\u064A');

    if (allowLatin) {
      normalized = normalized.toLowerCase();
      // Allow Arabic letters, English letters, and numbers
      normalized =
          normalized.replaceAll(RegExp(r'[^a-zA-Z\u0600-\u06FF0-9\s]'), ' ');
    } else {
      // Allow only Arabic letters and numbers
      normalized = normalized.replaceAll(RegExp(r'[^\u0600-\u06FF0-9\s]'), ' ');
    }

    // Collapse multiple spaces into one
    return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
