import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/audio_repository.dart';

class GetAyahAudioUsecase {
  const GetAyahAudioUsecase({required this.repository});

  final AudioRepository repository;

  Future<Either<FailureResponse, AyahAudioEntity>> call(AyahRef ref) {
    return repository.getAyahAudio(ref);
  }
}
