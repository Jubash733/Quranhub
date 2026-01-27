import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

abstract class AudioRepository {
  Future<Either<FailureResponse, AyahAudioEntity>> getAyahAudio(AyahRef ref);

  Future<Either<FailureResponse, int>> getCacheSizeBytes();

  Future<Either<FailureResponse, void>> clearAllCache();

  Future<Either<FailureResponse, void>> clearCacheByReciter(String edition);

  Future<Either<FailureResponse, void>> clearCacheBySurah(int surah);
}
