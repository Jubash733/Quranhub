import 'package:quran/domain/repositories/app_settings_repository.dart';

class UpdateTranslationSettingsUsecase {
  const UpdateTranslationSettingsUsecase({required this.repository});

  final AppSettingsRepository repository;

  Future<void> call(String edition, String languageCode) {
    return repository.updateTranslationEdition(edition, languageCode);
  }
}
