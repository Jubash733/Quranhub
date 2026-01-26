class LocalAyahData {
  LocalAyahData({
    required this.surah,
    required this.ayah,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.textArabic,
    required this.translation,
    required this.tafsir,
  });

  final int surah;
  final int ayah;
  final String surahNameAr;
  final String surahNameEn;
  final String textArabic;
  final Map<String, String> translation;
  final Map<String, String> tafsir;

  factory LocalAyahData.fromJson(Map<String, dynamic> json) {
    final surahName = json['surahName'] as Map<String, dynamic>? ?? {};
    final translation = json['translation'] as Map<String, dynamic>? ?? {};
    final tafsir = json['tafsir'] as Map<String, dynamic>? ?? {};

    return LocalAyahData(
      surah: json['surah'] as int,
      ayah: json['ayah'] as int,
      surahNameAr: surahName['ar'] as String? ?? '',
      surahNameEn: surahName['en'] as String? ?? '',
      textArabic: json['text'] as String? ?? '',
      translation: translation.map((key, value) =>
          MapEntry(key, value == null ? '' : value.toString())),
      tafsir: tafsir.map((key, value) =>
          MapEntry(key, value == null ? '' : value.toString())),
    );
  }

  String key() => '$surah:$ayah';

  String? translationFor(String languageCode) =>
      translation[languageCode] ?? translation['ar'] ?? translation['en'];

  String? tafsirFor(String languageCode) =>
      tafsir[languageCode] ?? tafsir['ar'] ?? tafsir['en'];
}
