import 'package:quran/data/models/app_settings_model.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:resources/constant/api_constant.dart';

class AppSettingsLocalDataSource {
  AppSettingsLocalDataSource({required this.isarService});

  final QuranCacheIsarService isarService;

  Future<AppSettingsModel> getSettings() async {
    final isar = await isarService.instance;
    final existing = await isar.appSettingsModels.get(1);
    if (existing != null) {
      return existing;
    }
    final defaults = AppSettingsModel()
      ..id = 1
      ..translationEdition = ApiConstant.alquranTranslationEn
      ..translationLanguage = 'en'
      ..tafsirEdition = ApiConstant.alquranTranslationAr
      ..tafsirLanguage = 'ar'
      ..audioEdition = ApiConstant.alquranAudioEdition
      ..updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(defaults);
    });
    return defaults;
  }

  Stream<AppSettingsModel> watchSettings() async* {
    final isar = await isarService.instance;
    final initial = await getSettings();
    yield initial;
    yield* isar.appSettingsModels.watchObject(1, fireImmediately: true).where(
          (event) => event != null,
        ).cast<AppSettingsModel>();
  }

  Future<void> saveSettings(AppSettingsModel model) async {
    final isar = await isarService.instance;
    model.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(model);
    });
  }
}
