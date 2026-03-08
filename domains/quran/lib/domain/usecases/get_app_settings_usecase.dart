import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';

class GetAppSettingsUsecase {
  const GetAppSettingsUsecase({required this.repository});

  final AppSettingsRepository repository;

  Future<AppSettingsEntity> call() {
    return repository.getSettings();
  }
}
