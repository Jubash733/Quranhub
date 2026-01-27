import 'dart:async';

import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/usecases/get_app_settings_usecase.dart';
import 'package:quran/domain/usecases/watch_app_settings_usecase.dart';
import 'package:quran/domain/usecases/update_audio_settings_usecase.dart';
import 'package:quran/domain/usecases/update_tafsir_settings_usecase.dart';
import 'package:quran/domain/usecases/update_translation_settings_usecase.dart';

class AppSettingsController extends StateNotifier<AsyncValue<AppSettingsEntity>> {
  AppSettingsController({
    required this.getSettingsUsecase,
    required this.watchSettingsUsecase,
    required this.updateTranslationUsecase,
    required this.updateTafsirUsecase,
    required this.updateAudioUsecase,
  }) : super(const AsyncValue.loading()) {
    _listen();
  }

  final GetAppSettingsUsecase getSettingsUsecase;
  final WatchAppSettingsUsecase watchSettingsUsecase;
  final UpdateTranslationSettingsUsecase updateTranslationUsecase;
  final UpdateTafsirSettingsUsecase updateTafsirUsecase;
  final UpdateAudioSettingsUsecase updateAudioUsecase;

  StreamSubscription<AppSettingsEntity>? _subscription;

  void _listen() {
    _subscription?.cancel();
    _subscription = watchSettingsUsecase.call().listen(
      (settings) {
        state = AsyncValue.data(settings);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  Future<void> refresh() async {
    try {
      final settings = await getSettingsUsecase.call();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTranslation(String edition, String languageCode) async {
    await updateTranslationUsecase.call(edition, languageCode);
  }

  Future<void> updateTafsir(String edition, String languageCode) async {
    await updateTafsirUsecase.call(edition, languageCode);
  }

  Future<void> updateAudio(String edition) async {
    await updateAudioUsecase.call(edition);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
