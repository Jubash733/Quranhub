import 'package:quran/domain/repositories/app_settings_repository.dart';

class UpdateAudioSettingsUsecase {
  const UpdateAudioSettingsUsecase({required this.repository});

  final AppSettingsRepository repository;

  Future<void> call(String edition) {
    return repository.updateAudioEdition(edition);
  }
}
