import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';

class SaveTadabburNoteUsecase {
  const SaveTadabburNoteUsecase({required this.repository});

  final TadabburRepository repository;

  Future<Either<FailureResponse, TadabburNoteEntity>> call(
    AyahRef ref, {
    required String text,
    List<String> tags = const [],
    String languageCode = 'ar',
  }) {
    return repository.saveNote(
      ref,
      text: text,
      tags: tags,
      languageCode: languageCode,
    );
  }
}
