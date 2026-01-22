import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl extends TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;

  TranslationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<FailureResponse, AyahTranslationEntity>> getAyahTranslation(
      AyahRef ref) async {
    try {
      final result = await remoteDataSource.getAyahTranslation(ref);
      final mappedRef = _mapRef(result);
      if (mappedRef != ref) {
        return Left(FailureResponse(
            message:
                'AyahRef mismatch for surah ${ref.surah}, ayah ${ref.ayah}'));
      }
      return Right(AyahTranslationEntity(
        ref: mappedRef,
        text: result.translation.id,
        languageCode: 'id',
      ));
    } on Exception catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  AyahRef _mapRef(AyahTranslationDTO dto) {
    return AyahRef(surah: dto.surahNumber, ayah: dto.ayahNumber);
  }
}
