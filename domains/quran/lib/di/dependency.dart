import 'package:dependencies/get_it/get_it.dart';
import 'package:quran/data/data_sources/quran_local_data_source.dart';
import 'package:quran/data/data_sources/quran_remote_data_source.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/data_sources/quran_pack_data_source.dart';
import 'package:quran/data/data_sources/quran_search_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_remote_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/data/data_sources/app_settings_local_data_source.dart';
import 'package:quran/data/data_sources/audio_cache_data_source.dart';
import 'package:quran/data/data_sources/audio_reciter_remote_data_source.dart';
import 'package:quran/data/data_sources/audio_remote_data_source.dart';
import 'package:quran/data/ai/api_key_manager.dart';
import 'package:quran/data/ai/providers/gemini_provider.dart';
import 'package:quran/data/ai/providers/openai_provider.dart';
import 'package:common/utils/config/app_config.dart';
import 'package:core/diagnostics/diagnostics_service.dart';
import 'package:quran/data/data_sources/tafsir_cache_data_source.dart';
import 'package:quran/data/data_sources/tafsir_remote_data_source.dart';
import 'package:quran/data/data_sources/tadabbur_local_data_source.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:quran/data/repositories/app_settings_repository_impl.dart';
import 'package:quran/data/repositories/quran_repository_impl.dart';
import 'package:quran/data/repositories/search_repository_impl.dart';
import 'package:quran/data/repositories/ai_assistant_repository_impl.dart';
import 'package:quran/data/repositories/audio_repository_impl.dart';
import 'package:quran/data/repositories/offline_packs_repository_impl.dart';
import 'package:quran/data/repositories/tadabbur_repository_impl.dart';
import 'package:quran/data/repositories/tafsir_repository_impl.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/repositories/quran_repository.dart';
import 'package:quran/domain/repositories/search_repository.dart';
import 'package:quran/domain/repositories/ai_assistant_repository.dart';
import 'package:quran/domain/repositories/audio_repository.dart';
import 'package:quran/domain/repositories/offline_packs_repository.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';
import 'package:quran/domain/repositories/translation_repository.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';
import 'package:quran/domain/usecases/get_ayah_translation_usecase.dart';
import 'package:quran/domain/usecases/get_ayah_tafsir_usecase.dart';
import 'package:quran/domain/usecases/get_ayah_audio_usecase.dart';
import 'package:quran/domain/usecases/get_audio_reciters_usecase.dart';
import 'package:quran/domain/usecases/get_offline_translation_usecase.dart';
import 'package:quran/domain/usecases/get_offline_tafsir_usecase.dart';
import 'package:quran/domain/usecases/search_verses_usecase.dart';
import 'package:quran/domain/usecases/build_search_index_usecase.dart';
import 'package:quran/domain/usecases/is_search_index_ready_usecase.dart';
import 'package:quran/domain/usecases/get_app_settings_usecase.dart';
import 'package:quran/domain/usecases/watch_app_settings_usecase.dart';
import 'package:quran/domain/usecases/update_audio_settings_usecase.dart';
import 'package:quran/domain/usecases/update_translation_settings_usecase.dart';
import 'package:quran/domain/usecases/update_tafsir_settings_usecase.dart';
import 'package:quran/domain/usecases/get_audio_cache_size_usecase.dart';
import 'package:quran/domain/usecases/cache_ayah_audio_usecase.dart';
import 'package:quran/domain/usecases/cache_surah_audio_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_reciter_usecase.dart';
import 'package:quran/domain/usecases/clear_audio_cache_by_surah_usecase.dart';
import 'package:quran/domain/usecases/get_ai_tadabbur_usecase.dart';
import 'package:quran/domain/usecases/get_tadabbur_note_usecase.dart';
import 'package:quran/domain/usecases/get_tadabbur_notes_usecase.dart';
import 'package:quran/domain/usecases/save_tadabbur_note_usecase.dart';
import 'package:quran/domain/usecases/delete_tadabbur_note_usecase.dart';
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
    sl.registerLazySingleton<QuranPackDataSource>(
        () => QuranPackDataSourceImpl(dio: sl()));

    /// Search Data Source
    sl.registerLazySingleton<QuranSearchDataSource>(
        () => QuranSearchDataSourceImpl(
              databaseHelper: sl(),
              settingsRepository: sl(),
            ));

    /// Cache Storage
    sl.registerLazySingleton<QuranCacheIsarService>(
        () => QuranCacheIsarService());

    /// Translation Cache Data Source
    sl.registerLazySingleton<TranslationCacheDataSource>(
        () => TranslationCacheDataSource(databaseHelper: sl()));

    /// Tafsir Cache Data Source
    sl.registerLazySingleton<TafsirCacheDataSource>(
        () => TafsirCacheDataSource(isarService: sl()));

    /// App Settings Local Data Source
    sl.registerLazySingleton<AppSettingsLocalDataSource>(
        () => AppSettingsLocalDataSource(isarService: sl()));

    /// Audio Cache Data Source
    sl.registerLazySingleton<AudioCacheDataSource>(
        () => AudioCacheDataSource(isarService: sl(), dio: sl()));

    /// Tadabbur Local Data Source
    sl.registerLazySingleton<TadabburLocalDataSource>(
        () => TadabburLocalDataSource());

    /// Translation Data Source
    sl.registerLazySingleton<TranslationRemoteDataSource>(
        () => TranslationRemoteDataSourceImpl(dio: sl()));

    /// Tafsir Data Source
    sl.registerLazySingleton<TafsirRemoteDataSource>(
        () => TafsirRemoteDataSourceImpl(dio: sl()));

    /// Audio Data Source
    sl.registerLazySingleton<AudioRemoteDataSource>(
        () => AudioRemoteDataSourceImpl(dio: sl()));
    sl.registerLazySingleton<AudioReciterRemoteDataSource>(
        () => AudioReciterRemoteDataSourceImpl());

    /// Diagnostics
    sl.registerLazySingleton<DiagnosticsService>(
      () => DiagnosticsService(dio: sl()),
    );

    /// AI Data Source
    sl.registerLazySingleton<ApiKeyManager>(() {
      final manager = ApiKeyManager();
      // Initialize with config keys
      // In production, these might come from a remote config service
      if (AppConfig.aiApiKey.isNotEmpty) {
        manager.setKeys('gemini', [AppConfig.aiApiKey]);
        manager.setKeys('openai',
            [AppConfig.aiApiKey]); // Assuming same key for demo, or split logic
      }
      return manager;
    });

    sl.registerLazySingleton<OpenAiProvider>(
      () => OpenAiProvider(dio: sl(), keyManager: sl()),
    );
    sl.registerLazySingleton<GeminiProvider>(
      () => GeminiProvider(dio: sl(), keyManager: sl()),
    );

    sl.registerLazySingleton<AiAssistantRemoteDataSource>(
        () => AiAssistantRemoteDataSourceImpl(providers: [
              sl<GeminiProvider>(),
              // sl<OpenAiProvider>(), // Enable when needed
            ]));
    sl.registerLazySingleton<AiAssistantLocalDataSource>(
        () => AiAssistantLocalDataSource(isarService: sl()));

    /// Repository
    sl.registerLazySingleton<QuranRepository>(() => QuranRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl(),
          assetDataSource: sl(),
        ));
    sl.registerLazySingleton<TranslationRepository>(
        () => TranslationRepositoryImpl(
              cacheDataSource: sl(),
              packDataSource: sl(),
              settingsRepository: sl(),
            ));
    sl.registerLazySingleton<TafsirRepository>(() => TafsirRepositoryImpl(
          cacheDataSource: sl(),
          packDataSource: sl(),
          settingsRepository: sl(),
        ));
    sl.registerLazySingleton<OfflinePacksRepository>(
        () => OfflinePacksRepositoryImpl(packDataSource: sl()));
    sl.registerLazySingleton<AppSettingsRepository>(
        () => AppSettingsRepositoryImpl(
              localDataSource: sl(),
              translationCacheDataSource: sl(),
              tafsirCacheDataSource: sl(),
            ));
    sl.registerLazySingleton<AudioRepository>(() => AudioRepositoryImpl(
          remoteDataSource: sl(),
          cacheDataSource: sl(),
          reciterRemoteDataSource: sl(),
          settingsRepository: sl(),
        ));
    sl.registerLazySingleton<TadabburRepository>(
        () => TadabburRepositoryImpl(localDataSource: sl()));
    sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
          assetDataSource: sl(),
          searchDataSource: sl(),
        ));
    sl.registerLazySingleton<AiAssistantRepository>(
        () => AiAssistantRepositoryImpl(
              localDataSource: sl(),
              remoteDataSource: sl(),
              assetDataSource: sl(),
              translationRepository: sl(),
              tafsirRepository: sl(),
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
    sl.registerLazySingleton<GetAyahAudioUsecase>(
        () => GetAyahAudioUsecase(repository: sl()));
    sl.registerLazySingleton<GetAudioRecitersUsecase>(
        () => GetAudioRecitersUsecase(repository: sl()));
    sl.registerLazySingleton<GetOfflineTranslationUsecase>(
        () => GetOfflineTranslationUsecase(repository: sl()));
    sl.registerLazySingleton<GetOfflineTafsirUsecase>(
        () => GetOfflineTafsirUsecase(repository: sl()));
    sl.registerLazySingleton<SearchVersesUsecase>(
        () => SearchVersesUsecase(repository: sl()));
    sl.registerLazySingleton<BuildSearchIndexUsecase>(
        () => BuildSearchIndexUsecase(repository: sl()));
    sl.registerLazySingleton<IsSearchIndexReadyUsecase>(
        () => IsSearchIndexReadyUsecase(repository: sl()));
    sl.registerLazySingleton<GetAppSettingsUsecase>(
        () => GetAppSettingsUsecase(repository: sl()));
    sl.registerLazySingleton<WatchAppSettingsUsecase>(
        () => WatchAppSettingsUsecase(repository: sl()));
    sl.registerLazySingleton<UpdateTranslationSettingsUsecase>(
        () => UpdateTranslationSettingsUsecase(repository: sl()));
    sl.registerLazySingleton<UpdateTafsirSettingsUsecase>(
        () => UpdateTafsirSettingsUsecase(repository: sl()));
    sl.registerLazySingleton<UpdateAudioSettingsUsecase>(
        () => UpdateAudioSettingsUsecase(repository: sl()));
    sl.registerLazySingleton<GetAudioCacheSizeUsecase>(
        () => GetAudioCacheSizeUsecase(repository: sl()));
    sl.registerLazySingleton<CacheAyahAudioUsecase>(
        () => CacheAyahAudioUsecase(repository: sl()));
    sl.registerLazySingleton<CacheSurahAudioUsecase>(
        () => CacheSurahAudioUsecase(repository: sl()));
    sl.registerLazySingleton<ClearAudioCacheUsecase>(
        () => ClearAudioCacheUsecase(repository: sl()));
    sl.registerLazySingleton<ClearAudioCacheByReciterUsecase>(
        () => ClearAudioCacheByReciterUsecase(repository: sl()));
    sl.registerLazySingleton<ClearAudioCacheBySurahUsecase>(
        () => ClearAudioCacheBySurahUsecase(repository: sl()));
    sl.registerLazySingleton<GetAiTadabburUsecase>(
        () => GetAiTadabburUsecase(repository: sl()));
    sl.registerLazySingleton<GetTadabburNoteUsecase>(
        () => GetTadabburNoteUsecase(repository: sl()));
    sl.registerLazySingleton<GetTadabburNotesUsecase>(
        () => GetTadabburNotesUsecase(repository: sl()));
    sl.registerLazySingleton<SaveTadabburNoteUsecase>(
        () => SaveTadabburNoteUsecase(repository: sl()));
    sl.registerLazySingleton<DeleteTadabburNoteUsecase>(
        () => DeleteTadabburNoteUsecase(repository: sl()));
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
