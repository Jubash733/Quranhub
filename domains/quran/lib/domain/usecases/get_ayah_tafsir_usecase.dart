import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_tafsir_entity.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';

class GetAyahTafsirUsecase {
  final TafsirRepository repository;

  const GetAyahTafsirUsecase({required this.repository});

  Future<Either<FailureResponse, AyahTafsirEntity>> call(
    AyahRef ref, {
    String languageCode = 'ar',
  }) {
    return repository.getAyahTafsir(ref, languageCode: languageCode);
  }
}
