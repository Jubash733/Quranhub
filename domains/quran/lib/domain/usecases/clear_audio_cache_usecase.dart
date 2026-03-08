import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/repositories/audio_repository.dart';

class ClearAudioCacheUsecase {
  const ClearAudioCacheUsecase({required this.repository});

  final AudioRepository repository;

  Future<Either<FailureResponse, void>> call() {
    return repository.clearAllCache();
  }
}
