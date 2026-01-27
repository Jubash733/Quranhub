import 'package:quran/domain/repositories/app_settings_repository.dart';

class UpdateTafsirSettingsUsecase {
  const UpdateTafsirSettingsUsecase({required this.repository});

  final AppSettingsRepository repository;

  Future<void> call(String edition, String languageCode) {
    return repository.updateTafsirEdition(edition, languageCode);
  }
}
