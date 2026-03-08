import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';

abstract class AudioRepository {
  Future<Either<FailureResponse, AyahAudioEntity>> getAyahAudio(AyahRef ref);

  Future<Either<FailureResponse, List<AudioReciterEntity>>> getReciters();

  Future<Either<FailureResponse, int>> getCacheSizeBytes();

  Future<Either<FailureResponse, void>> clearAllCache();

  Future<Either<FailureResponse, void>> clearCacheByReciter(String edition);

  Future<Either<FailureResponse, void>> clearCacheBySurah(int surah);

  Future<Either<FailureResponse, AyahAudioEntity>> cacheAyahAudio(
    AyahRef ref, {
    String? edition,
  });

  Future<Either<FailureResponse, int>> cacheSurahAudio({
    required int surah,
    required int ayahCount,
    String? edition,
    void Function(int current, int total)? onProgress,
  });
}
