import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/translation_local_data_source.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl extends TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;
  final TranslationLocalDataSource localDataSource;

  TranslationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<FailureResponse, AyahTranslationEntity>> getAyahTranslation(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    try {
      final localTranslation =
          await localDataSource.getAyahTranslation(ref, languageCode);
      if (localTranslation != null && localTranslation.isNotEmpty) {
        return Right(AyahTranslationEntity(
          ref: ref,
          text: localTranslation,
          languageCode: languageCode,
        ));
      }

      final result = await remoteDataSource.getAyahTranslation(ref);
      final mappedRef = _mapRef(result);
      if (mappedRef != ref) {
        return Left(FailureResponse(
            message:
                'AyahRef mismatch for surah ${ref.surah}, ayah ${ref.ayah}'));
      }
      final text = _selectTranslationText(result, languageCode);
      return Right(AyahTranslationEntity(
        ref: mappedRef,
        text: text,
        languageCode: _resolveLanguageCode(languageCode),
      ));
    } on Exception catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  AyahRef _mapRef(AyahTranslationDTO dto) {
    return AyahRef(surah: dto.surahNumber, ayah: dto.ayahNumber);
  }

  String _selectTranslationText(
    AyahTranslationDTO dto,
    String languageCode,
  ) {
    if (languageCode == 'id') {
      return dto.translation.id;
    }
    return dto.translation.en;
  }

  String _resolveLanguageCode(String languageCode) {
    if (languageCode == 'id') {
      return 'id';
    }
    return 'en';
  }
}
