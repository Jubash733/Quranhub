import '../../entities/surah.dart';
import '../../entities/verse.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<List<Verse>> getVersesBySurah(int surahId, {int? translations, int? tafsirs});
  Future<String> getAudioUrl(String reciter, String surahAyah);
  Future<String> getVerseTafsir(String verseKey, int tafsirId);
  Future<String> getVerseTranslation(String verseKey, int translationId);
}
