class TranslationCacheEntry {
  const TranslationCacheEntry({
    required this.text,
    required this.edition,
    required this.updatedAtMillis,
  });

  final String text;
  final String edition;
  final int updatedAtMillis;
}
