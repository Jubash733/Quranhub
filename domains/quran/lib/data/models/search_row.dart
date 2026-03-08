class SearchRow {
  SearchRow({
    required this.surah,
    required this.ayah,
    required this.text,
    required this.surahNameAr,
    required this.surahNameEn,
    this.translation,
  });

  final int surah;
  final int ayah;
  final String text;
  final String surahNameAr;
  final String surahNameEn;
  final String? translation;

  factory SearchRow.fromMap(Map<String, dynamic> map) {
    return SearchRow(
      surah: map['surah'] as int,
      ayah: map['ayah'] as int,
      text: map['text'] as String,
      surahNameAr: map['surahNameAr'] as String? ?? '',
      surahNameEn: map['surahNameEn'] as String? ?? '',
      translation: map['translation'] as String?,
    );
  }
}
