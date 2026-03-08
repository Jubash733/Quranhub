import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';
import 'package:quran/domain/repositories/audio_repository.dart';

class GetAudioRecitersUsecase {
  const GetAudioRecitersUsecase({required this.repository});

  final AudioRepository repository;

  Future<Either<FailureResponse, List<AudioReciterEntity>>> call() {
    return repository.getReciters();
  }
}
