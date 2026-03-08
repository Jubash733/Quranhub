class Verse {
  final int id;
  final int verseNumber;
  final String text;
  final String? translation;
  final String? tafsir;

  Verse({
    required this.id,
    required this.verseNumber,
    required this.text,
    this.translation,
    this.tafsir,
  });
}
