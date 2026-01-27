import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/tafsir_cache_data_source.dart';
import 'package:quran/data/data_sources/tafsir_remote_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_tafsir_entity.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';
import 'package:resources/constant/api_constant.dart';

class TafsirRepositoryImpl extends TafsirRepository {
  TafsirRepositoryImpl({
    required this.cacheDataSource,
    required this.remoteDataSource,
  });

  final TafsirCacheDataSource cacheDataSource;
  final TafsirRemoteDataSource remoteDataSource;
  static const _cacheTtl = Duration(days: 7);

  @override
  Future<Either<FailureResponse, AyahTafsirEntity>> getAyahTafsir(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    final edition = _resolveEdition(languageCode);
    final cached = await cacheDataSource.getCachedTafsir(
      ref,
      languageCode: languageCode,
      edition: edition,
    );
    if (cached != null &&
        cached.text.isNotEmpty &&
        DateTime.now().difference(cached.updatedAt) <= _cacheTtl) {
      return Right(
        AyahTafsirEntity(
          ref: ref,
          text: cached.text,
          languageCode: languageCode,
        ),
      );
    }
    try {
      final text = await remoteDataSource.getAyahTafsir(
        ref,
        edition: edition,
      );
      if (text.isNotEmpty) {
        await cacheDataSource.cacheTafsir(
          ref,
          languageCode: languageCode,
          edition: edition,
          text: text,
        );
      }
      return Right(
        AyahTafsirEntity(
          ref: ref,
          text: text,
          languageCode: languageCode,
        ),
      );
    } on Exception catch (e) {
      if (cached != null) {
        return Right(
          AyahTafsirEntity(
            ref: ref,
            text: cached.text,
            languageCode: languageCode,
          ),
        );
      }
      return Left(FailureResponse(message: e.toString()));
    }
  }

  String _resolveEdition(String languageCode) {
    if (languageCode == 'ar') {
      return ApiConstant.alquranTranslationAr;
    }
    return ApiConstant.alquranTranslationEn;
  }
}
