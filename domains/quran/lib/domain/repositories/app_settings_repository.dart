import 'package:quran/domain/entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Stream<AppSettingsEntity> watchSettings();
  Future<void> updateTranslationEdition(String edition, String languageCode);
  Future<void> updateTafsirEdition(String edition, String languageCode);
  Future<void> updateAudioEdition(String edition);
}
