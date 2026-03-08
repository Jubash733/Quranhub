import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';

class DeleteTadabburNoteUsecase {
  const DeleteTadabburNoteUsecase({required this.repository});

  final TadabburRepository repository;

  Future<Either<FailureResponse, bool>> call(
    AyahRef ref, {
    String languageCode = 'ar',
  }) {
    return repository.deleteNote(ref, languageCode: languageCode);
  }
}
