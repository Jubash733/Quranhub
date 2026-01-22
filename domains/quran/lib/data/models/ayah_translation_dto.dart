import 'package:quran/data/models/surah_dto.dart';

class AyahTranslationDTO {
  AyahTranslationDTO({
    required this.surahNumber,
    required this.ayahNumber,
    required this.translation,
  });

  final int surahNumber;
  final int ayahNumber;
  final TranslationDTO translation;
}
