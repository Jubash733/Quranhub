import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';

abstract class TranslationRepository {
  Future<Either<FailureResponse, AyahTranslationEntity>> getAyahTranslation(
      AyahRef ref);
}
