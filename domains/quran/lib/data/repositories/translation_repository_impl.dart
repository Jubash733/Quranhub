import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/data/models/translation_cache_entry.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/repositories/translation_repository.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';
import 'package:resources/constant/api_constant.dart';

class TranslationRepositoryImpl extends TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;
  final TranslationCacheDataSource cacheDataSource;
  final AppSettingsRepository settingsRepository;
  static const _cacheTtl = Duration(days: 7);

  TranslationRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
    required this.settingsRepository,
  });

  @override
  Future<Either<FailureResponse, AyahTranslationEntity>> getAyahTranslation(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    TranslationCacheEntry? cached;
    try {
      final edition = await _resolveEdition(languageCode);
      cached = await cacheDataSource.getCachedTranslation(
        ref,
        languageCode: languageCode,
        edition: edition,
      );
      if (_isFresh(cached)) {
        return Right(AyahTranslationEntity(
          ref: ref,
          text: cached!.text,
          languageCode: languageCode,
        ));
      }

      final result = await remoteDataSource.getAyahTranslation(
        ref,
        edition: edition,
      );
      final mappedRef = _mapRef(result);
      if (mappedRef != ref) {
        return Left(FailureResponse(
            message:
                'AyahRef mismatch for surah ${ref.surah}, ayah ${ref.ayah}'));
      }
      final text = _selectTranslationText(result);
      await cacheDataSource.cacheTranslation(
        ref,
        languageCode: languageCode,
        edition: edition,
        text: text,
      );
      final entity = AyahTranslationEntity(
        ref: mappedRef,
        text: text,
        languageCode: _resolveLanguageCode(languageCode),
      );
      return Right(entity);
    } on Exception catch (e) {
      if (cached != null) {
        return Right(AyahTranslationEntity(
          ref: ref,
          text: cached.text,
          languageCode: _resolveLanguageCode(languageCode),
        ));
      }
      return Left(FailureResponse(message: e.toString()));
    }
  }

  AyahRef _mapRef(AyahTranslationDTO dto) {
    return AyahRef(surah: dto.surahNumber, ayah: dto.ayahNumber);
  }

  String _selectTranslationText(AyahTranslationDTO dto) {
    return dto.translation.en;
  }

  String _resolveLanguageCode(String languageCode) {
    if (languageCode == 'ar') {
      return 'ar';
    }
    return 'en';
  }

  Future<String> _resolveEdition(String languageCode) async {
    final settings = await settingsRepository.getSettings();
    if (settings.translationLanguage == languageCode) {
      return settings.translationEdition;
    }
    if (languageCode == 'ar') {
      return ApiConstant.alquranTranslationAr;
    }
    return ApiConstant.alquranTranslationEn;
  }

  bool _isFresh(TranslationCacheEntry? entry) {
    if (entry == null) return false;
    if (entry.text.isEmpty) return false;
    final updatedAt =
        DateTime.fromMillisecondsSinceEpoch(entry.updatedAtMillis);
    return DateTime.now().difference(updatedAt) <= _cacheTtl;
  }
}
