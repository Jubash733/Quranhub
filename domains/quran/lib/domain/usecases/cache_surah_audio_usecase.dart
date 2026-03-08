import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/repositories/audio_repository.dart';

class CacheSurahAudioUsecase {
  const CacheSurahAudioUsecase({required this.repository});

  final AudioRepository repository;

  Future<Either<FailureResponse, int>> call({
    required int surah,
    required int ayahCount,
    String? edition,
    void Function(int current, int total)? onProgress,
  }) {
    return repository.cacheSurahAudio(
      surah: surah,
      ayahCount: ayahCount,
      edition: edition,
      onProgress: onProgress,
    );
  }
}
