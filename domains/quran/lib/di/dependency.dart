import 'package:dependencies/get_it/get_it.dart';
import 'package:quran/data/data_sources/quran_local_data_source.dart';
import 'package:quran/data/data_sources/quran_remote_data_source.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_remote_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/data/data_sources/tafsir_local_data_source.dart';
import 'package:quran/data/data_sources/translation_local_data_source.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/repositories/quran_repository_impl.dart';
import 'package:quran/data/repositories/search_repository_impl.dart';
import 'package:quran/data/repositories/ai_assistant_repository_impl.dart';
import 'package:quran/data/repositories/tafsir_repository_impl.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/repositories/quran_repository.dart';
import 'package:quran/domain/repositories/search_repository.dart';
import 'package:quran/domain/repositories/ai_assistant_repository.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';
import 'package:quran/domain/repositories/translation_repository.dart';
import 'package:quran/domain/usecases/get_ayah_translation_usecase.dart';
import 'package:quran/domain/usecases/get_ayah_tafsir_usecase.dart';
import 'package:quran/domain/usecases/search_verses_usecase.dart';
import 'package:quran/domain/usecases/get_ai_tadabbur_usecase.dart';
import 'package:quran/domain/usecases/get_bookmark_verses_usecase.dart';
import 'package:quran/domain/usecases/get_detail_surah_usecase.dart';
import 'package:quran/domain/usecases/get_juz_usecase.dart';
import 'package:quran/domain/usecases/get_last_read_usecase.dart';
import 'package:quran/domain/usecases/get_surah_usecase.dart';
import 'package:quran/domain/usecases/remove_bookmark_verses_usecase.dart';
import 'package:quran/domain/usecases/save_bookmark_verses_usecase.dart';
import 'package:quran/domain/usecases/save_last_read_usecase.dart';
import 'package:quran/domain/usecases/status_bookmark_verse_usecase.dart';
import 'package:quran/domain/usecases/update_last_read_usecase.dart';

class RegisterQuranModule {
  RegisterQuranModule() {
    _registerCore();
  }

  void _registerCore() {
    /// Database
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

    /// Remote Data Source
    sl.registerLazySingleton<QuranRemoteDataSource>(
        () => QuranRemoteDataSourceImpl(dio: sl()));

    /// Local Data Source
    sl.registerLazySingleton<QuranLocalDataSource>(
        () => QuranLocalDataSourceImpl(databaseHelper: sl()));

    /// Asset Data Source
    sl.registerLazySingleton<QuranAssetDataSource>(
        () => QuranAssetDataSourceImpl());

    /// Translation Local Data Source
    sl.registerLazySingleton<TranslationLocalDataSource>(
        () => TranslationLocalDataSource(assetDataSource: sl()));

    /// Tafsir Local Data Source
    sl.registerLazySingleton<TafsirLocalDataSource>(
        () => TafsirLocalDataSource(assetDataSource: sl()));

    /// Translation Data Source
    sl.registerLazySingleton<TranslationRemoteDataSource>(
        () => TranslationRemoteDataSourceImpl(dio: sl()));

    /// AI Data Source
    sl.registerLazySingleton<AiAssistantRemoteDataSource>(
        () => AiAssistantRemoteDataSourceImpl(dio: sl()));
    sl.registerLazySingleton<AiAssistantLocalDataSource>(
        () => AiAssistantLocalDataSource());

    /// Repository
    sl.registerLazySingleton<QuranRepository>(() =>
        QuranRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
    sl.registerLazySingleton<TranslationRepository>(
        () => TranslationRepositoryImpl(
              remoteDataSource: sl(),
              localDataSource: sl(),
            ));
    sl.registerLazySingleton<TafsirRepository>(
        () => TafsirRepositoryImpl(localDataSource: sl()));
    sl.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(assetDataSource: sl()));
    sl.registerLazySingleton<AiAssistantRepository>(
        () => AiAssistantRepositoryImpl(
              localDataSource: sl(),
              remoteDataSource: sl(),
              assetDataSource: sl(),
              translationLocalDataSource: sl(),
              tafsirLocalDataSource: sl(),
            ));
    /// Use Case
    sl.registerLazySingleton<GetSurahUsecase>(
        () => GetSurahUsecase(repository: sl()));

    sl.registerLazySingleton<GetDetailSurahUsecase>(
        () => GetDetailSurahUsecase(repository: sl()));

    sl.registerLazySingleton<GetJuzUsecase>(
        () => GetJuzUsecase(repository: sl()));

    sl.registerLazySingleton<GetAyahTranslationUsecase>(
        () => GetAyahTranslationUsecase(repository: sl()));
    sl.registerLazySingleton<GetAyahTafsirUsecase>(
        () => GetAyahTafsirUsecase(repository: sl()));
    sl.registerLazySingleton<SearchVersesUsecase>(
        () => SearchVersesUsecase(repository: sl()));
    sl.registerLazySingleton<GetAiTadabburUsecase>(
        () => GetAiTadabburUsecase(repository: sl()));
    sl.registerLazySingleton<SaveLastReadUsecase>(
        () => SaveLastReadUsecase(repository: sl()));

    sl.registerLazySingleton<UpdateLastReadUsecase>(
        () => UpdateLastReadUsecase(repository: sl()));

    sl.registerLazySingleton<GetLastReadUsecase>(
        () => GetLastReadUsecase(repository: sl()));

    sl.registerLazySingleton<SaveBookmarkVersesUseCase>(
        () => SaveBookmarkVersesUseCase(repository: sl()));

    sl.registerLazySingleton<RemoveBookmarkVersesUsecase>(
        () => RemoveBookmarkVersesUsecase(repository: sl()));

    sl.registerLazySingleton<GetBookmarkVersesUsecase>(
        () => GetBookmarkVersesUsecase(repository: sl()));

    sl.registerLazySingleton<StatusBookmarkVerseUsecase>(
        () => StatusBookmarkVerseUsecase(repository: sl()));
  }
}
