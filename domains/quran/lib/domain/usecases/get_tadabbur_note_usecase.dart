import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';

class GetTadabburNoteUsecase {
  const GetTadabburNoteUsecase({required this.repository});

  final TadabburRepository repository;

  Future<Either<FailureResponse, TadabburNoteEntity?>> call(
    AyahRef ref, {
    String languageCode = 'ar',
  }) {
    return repository.getNote(ref, languageCode: languageCode);
  }
}
