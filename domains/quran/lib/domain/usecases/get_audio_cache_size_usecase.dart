import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/repositories/audio_repository.dart';

class GetAudioCacheSizeUsecase {
  const GetAudioCacheSizeUsecase({required this.repository});

  final AudioRepository repository;

  Future<Either<FailureResponse, int>> call() {
    return repository.getCacheSizeBytes();
  }
}
