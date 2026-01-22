import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/repositories/translation_repository.dart';

class GetAyahTranslationUsecase {
  final TranslationRepository repository;

  const GetAyahTranslationUsecase({required this.repository});

  Future<Either<FailureResponse, AyahTranslationEntity>> call(AyahRef ref) {
    return repository.getAyahTranslation(ref);
  }
}
