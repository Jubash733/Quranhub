import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:dependencies/get_it/get_it.dart';
import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:settings/presentation/controller/app_settings_controller.dart';
import 'package:quran/domain/usecases/get_app_settings_usecase.dart';
import 'package:quran/domain/usecases/watch_app_settings_usecase.dart';
import 'package:quran/domain/usecases/update_audio_settings_usecase.dart';
import 'package:quran/domain/usecases/update_tafsir_settings_usecase.dart';
import 'package:quran/domain/usecases/update_translation_settings_usecase.dart';

final appSettingsControllerProvider =
    StateNotifierProvider<AppSettingsController, AsyncValue<AppSettingsEntity>>(
        (ref) {
  final sl = GetIt.instance;
  return AppSettingsController(
    getSettingsUsecase: sl<GetAppSettingsUsecase>(),
    watchSettingsUsecase: sl<WatchAppSettingsUsecase>(),
    updateTranslationUsecase: sl<UpdateTranslationSettingsUsecase>(),
    updateTafsirUsecase: sl<UpdateTafsirSettingsUsecase>(),
    updateAudioUsecase: sl<UpdateAudioSettingsUsecase>(),
  );
});
