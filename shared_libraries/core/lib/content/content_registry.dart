class ContentRegistry {
  static const List<String> allowedDomains = [
    'www.gutenberg.org',
    'api.quran.com',
    'download.quran.com',
    'everyayah.com',
  ];

  static const List<String> allowedAssetSources = [
    'assets/packs/',
    'assets/images/',
    'assets/fonts/',
  ];

  static bool isUrlAllowed(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return false;
    return allowedDomains.any((domain) => uri.host.endsWith(domain));
  }
}
