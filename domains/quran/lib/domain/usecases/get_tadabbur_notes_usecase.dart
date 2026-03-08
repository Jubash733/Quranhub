import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';

class GetTadabburNotesUsecase {
  const GetTadabburNotesUsecase({required this.repository});

  final TadabburRepository repository;

  Future<Either<FailureResponse, List<TadabburNoteEntity>>> call({
    String languageCode = 'ar',
  }) {
    return repository.listNotes(languageCode: languageCode);
  }
}
