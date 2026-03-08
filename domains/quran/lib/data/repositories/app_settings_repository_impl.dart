import 'package:quran/data/data_sources/app_settings_local_data_source.dart';
import 'package:quran/data/data_sources/tafsir_cache_data_source.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/models/app_settings_model.dart';
import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  AppSettingsRepositoryImpl({
    required this.localDataSource,
    required this.translationCacheDataSource,
    required this.tafsirCacheDataSource,
  });

  final AppSettingsLocalDataSource localDataSource;
  final TranslationCacheDataSource translationCacheDataSource;
  final TafsirCacheDataSource tafsirCacheDataSource;

  @override
  Future<AppSettingsEntity> getSettings() async {
    final model = await localDataSource.getSettings();
    return _map(model);
  }

  @override
  Stream<AppSettingsEntity> watchSettings() {
    return localDataSource.watchSettings().map(_map);
  }

  @override
  Future<void> updateTranslationEdition(
    String edition,
    String languageCode,
  ) async {
    final model = await localDataSource.getSettings();
    if (model.translationEdition == edition &&
        model.translationLanguage == languageCode) {
      return;
    }
    model.translationEdition = edition;
    model.translationLanguage = languageCode;
    await localDataSource.saveSettings(model);
    await translationCacheDataSource.clearTranslations(languageCode);
  }

  @override
  Future<void> updateTafsirEdition(
    String edition,
    String languageCode,
  ) async {
    final model = await localDataSource.getSettings();
    if (model.tafsirEdition == edition &&
        model.tafsirLanguage == languageCode) {
      return;
    }
    model.tafsirEdition = edition;
    model.tafsirLanguage = languageCode;
    await localDataSource.saveSettings(model);
    await tafsirCacheDataSource.clearAll();
  }

  @override
  Future<void> updateAudioEdition(String edition) async {
    final model = await localDataSource.getSettings();
    if (model.audioEdition == edition) {
      return;
    }
    model.audioEdition = edition;
    await localDataSource.saveSettings(model);
  }

  AppSettingsEntity _map(AppSettingsModel model) {
    return AppSettingsEntity(
      translationEdition: model.translationEdition,
      translationLanguage: model.translationLanguage,
      tafsirEdition: model.tafsirEdition,
      tafsirLanguage: model.tafsirLanguage,
      audioEdition: model.audioEdition,
      updatedAt: model.updatedAt,
    );
  }
}
