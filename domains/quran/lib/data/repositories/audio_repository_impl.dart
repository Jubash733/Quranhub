import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/audio_cache_data_source.dart';
import 'package:quran/data/data_sources/audio_remote_data_source.dart';
import 'package:quran/data/data_sources/audio_reciter_remote_data_source.dart';
import 'package:quran/domain/entities/ayah_audio_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';
import 'package:quran/domain/repositories/audio_repository.dart';
import 'package:resources/constant/api_constant.dart';

class AudioRepositoryImpl extends AudioRepository {
  AudioRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
    required this.reciterRemoteDataSource,
    required this.settingsRepository,
  });

  final AudioRemoteDataSource remoteDataSource;
  final AudioCacheDataSource cacheDataSource;
  final AudioReciterRemoteDataSource reciterRemoteDataSource;
  final AppSettingsRepository settingsRepository;
  Map<String, bool>? _downloadPolicy;

  static const String _downloadNotAllowedMessage = 'DOWNLOAD_NOT_ALLOWED';

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
      return Right(
        AyahAudioEntity(
          ref: ref,
          url: url,
          edition: edition,
          isCached: false,
        ),
      );
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, List<AudioReciterEntity>>>
      getReciters() async {
    try {
      final reciters = await reciterRemoteDataSource.getReciters();
      return Right(reciters);
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

  @override
  Future<Either<FailureResponse, AyahAudioEntity>> cacheAyahAudio(
    AyahRef ref, {
    String? edition,
  }) async {
    try {
      final settings = await settingsRepository.getSettings();
      final resolvedEdition = edition?.isNotEmpty == true
          ? edition!
          : settings.audioEdition.isNotEmpty
              ? settings.audioEdition
              : ApiConstant.alquranAudioEdition;
      final canDownload = await _isDownloadAllowed(resolvedEdition);
      if (!canDownload) {
        return const Left(
          FailureResponse(message: _downloadNotAllowedMessage),
        );
      }
      final cached = await cacheDataSource.getCached(ref, resolvedEdition);
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
      final url = await remoteDataSource.getAyahAudioUrl(ref, resolvedEdition);
      final saved = await cacheDataSource.downloadAndCache(
        ref: ref,
        edition: resolvedEdition,
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
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, int>> cacheSurahAudio({
    required int surah,
    required int ayahCount,
    String? edition,
    void Function(int current, int total)? onProgress,
  }) async {
    final settings = await settingsRepository.getSettings();
    final resolvedEdition = edition?.isNotEmpty == true
        ? edition!
        : settings.audioEdition.isNotEmpty
            ? settings.audioEdition
            : ApiConstant.alquranAudioEdition;
    final canDownload = await _isDownloadAllowed(resolvedEdition);
    if (!canDownload) {
      return const Left(
        FailureResponse(message: _downloadNotAllowedMessage),
      );
    }
    var downloaded = 0;
    String? firstError;
    for (var ayah = 1; ayah <= ayahCount; ayah++) {
      final ref = AyahRef(surah: surah, ayah: ayah);
      try {
        final cached = await cacheDataSource.getCached(ref, resolvedEdition);
        if (cached == null) {
          final url =
              await remoteDataSource.getAyahAudioUrl(ref, resolvedEdition);
          await cacheDataSource.downloadAndCache(
            ref: ref,
            edition: resolvedEdition,
            url: url,
          );
        }
        downloaded += 1;
        if (onProgress != null) {
          onProgress(downloaded, ayahCount);
        }
      } catch (e) {
        firstError ??= e.toString();
      }
    }
    if (downloaded == 0 && firstError != null) {
      return Left(FailureResponse(message: firstError));
    }
    return Right(downloaded);
  }

  Future<bool> _isDownloadAllowed(String edition) async {
    final policy = _downloadPolicy;
    if (policy != null && policy.containsKey(edition)) {
      return policy[edition] ?? false;
    }
    final reciters = await reciterRemoteDataSource.getReciters();
    _downloadPolicy = {
      for (final reciter in reciters) reciter.identifier: reciter.allowDownload,
    };
    return _downloadPolicy?[edition] ?? false;
  }
}
