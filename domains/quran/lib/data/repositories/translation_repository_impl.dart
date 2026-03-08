import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/quran_pack_data_source.dart';
import 'package:quran/data/data_sources/translation_cache_data_source.dart';
import 'package:quran/data/models/translation_cache_entry.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/repositories/translation_repository.dart';
import 'package:quran/domain/repositories/app_settings_repository.dart';
import 'package:resources/constant/api_constant.dart';

class TranslationRepositoryImpl extends TranslationRepository {
  TranslationRepositoryImpl({
    required this.cacheDataSource,
    required this.packDataSource,
    required this.settingsRepository,
  });

  static const _cacheTtl = Duration(days: 7);
  static const _packUnavailableMessage = 'PACK_UNAVAILABLE';

  final TranslationCacheDataSource cacheDataSource;
  final QuranPackDataSource packDataSource;
  final AppSettingsRepository settingsRepository;

  @override
  Future<Either<FailureResponse, AyahTranslationEntity>> getAyahTranslation(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    final resolvedLanguage = _resolveLanguageCode(languageCode);
    try {
      final edition = await _resolveEdition(languageCode);
      final cached = await cacheDataSource.getCachedTranslation(
        ref,
        languageCode: languageCode,
        edition: edition,
      );
      if (_isFresh(cached)) {
        return Right(AyahTranslationEntity(
          ref: ref,
          text: cached!.text,
          languageCode: resolvedLanguage,
        ));
      }

      final text = await packDataSource.getTranslation(ref, edition);
      if (text == null || text.trim().isEmpty) {
        return const Left(FailureResponse(message: _packUnavailableMessage));
      }
      await cacheDataSource.cacheTranslation(
        ref,
        languageCode: languageCode,
        edition: edition,
        text: text,
      );
      return Right(AyahTranslationEntity(
        ref: ref,
        text: text,
        languageCode: resolvedLanguage,
      ));
    } on Exception catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
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
