import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/audio_cache_data_source.dart';
import 'package:quran/data/data_sources/audio_remote_data_source.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';
import 'package:quran/domain/repositories/audio_repository.dart';
import 'package:resources/constant/api_constant.dart';

class AudioRepositoryImpl extends AudioRepository {
  AudioRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
    required this.settingsRepository,
  });

  final AudioRemoteDataSource remoteDataSource;
  final AudioCacheDataSource cacheDataSource;
  final AppSettingsRepository settingsRepository;

  @override
  Future<Either<FailureResponse, AyahAudioEntity>> getAyahAudio(
      AyahRef ref) async {
    try {
      final settings = await settingsRepository.getSettings();
      final edition = settings.audioEdition.isNotEmpty
          ? settings.audioEdition
          : ApiConstant.alquranAudioEdition;
      final cached = await cacheDataSource.getCached(ref, edition);
      if (cached != null) {
        return Right(
          AyahAudioEntity(
            ref: ref,
            url: cached.url,
            edition: cached.edition,
            localPath: cached.filePath,
            isCached: true,
          ),
        );
      }
      final url = await remoteDataSource.getAyahAudioUrl(ref, edition);
      try {
        final saved = await cacheDataSource.downloadAndCache(
          ref: ref,
          edition: edition,
          url: url,
        );
        return Right(
          AyahAudioEntity(
            ref: ref,
            url: saved.url,
            edition: saved.edition,
            localPath: saved.filePath,
            isCached: true,
          ),
        );
      } catch (_) {
        return Right(
          AyahAudioEntity(
            ref: ref,
            url: url,
            edition: edition,
            isCached: false,
          ),
        );
      }
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, int>> getCacheSizeBytes() async {
    try {
      final size = await cacheDataSource.getTotalSizeBytes();
      return Right(size);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, void>> clearAllCache() async {
    try {
      await cacheDataSource.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, void>> clearCacheByReciter(
      String edition) async {
    try {
      await cacheDataSource.clearByReciter(edition);
      return const Right(null);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, void>> clearCacheBySurah(int surah) async {
    try {
      await cacheDataSource.clearBySurah(surah);
      return const Right(null);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }
}
