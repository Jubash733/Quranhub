import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'quran_api.g.dart';

@RestApi(baseUrl: "https://api.quran.com/api/v4/")
abstract class QuranApi {
  factory QuranApi(Dio dio, {String baseUrl}) = _QuranApi;

  @GET("chapters")
  Future<dynamic> getChapters();

  @GET("verses/by_chapter/{chapter_id}")
  Future<dynamic> getVersesByChapter(
    @Path("chapter_id") int chapterId, {
    @Query("language") String language = "ar",
    @Query("words") bool words = true,
    @Query("translations") int? translations,
    @Query("tafsirs") int? tafsirs,
  });

  @GET("quran/tafsirs/{tafsir_id}")
  Future<dynamic> getVerseTafsir(
    @Path("tafsir_id") int tafsirId,
    @Query("verse_key") String verseKey,
  );

  @GET("quran/translations/{translation_id}")
  Future<dynamic> getVerseTranslation(
    @Path("translation_id") int translationId,
    @Query("verse_key") String verseKey,
  );

  @GET("http://api.everyayah.com/data.json")
  Future<dynamic> getReciters();
}
