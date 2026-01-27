import 'package:quran/domain/entities/app_settings_entity.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';

class WatchAppSettingsUsecase {
  const WatchAppSettingsUsecase({required this.repository});

  final AppSettingsRepository repository;

  Stream<AppSettingsEntity> call() {
    return repository.watchSettings();
  }
}
