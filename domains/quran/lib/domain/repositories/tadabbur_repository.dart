import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';

abstract class TadabburRepository {
  Future<Either<FailureResponse, TadabburNoteEntity?>> getNote(
    AyahRef ref, {
    String languageCode,
  });

  Future<Either<FailureResponse, TadabburNoteEntity>> saveNote(
    AyahRef ref, {
    required String text,
    List<String> tags,
    String languageCode,
  });

  Future<Either<FailureResponse, bool>> deleteNote(
    AyahRef ref, {
    String languageCode,
  });

  Future<Either<FailureResponse, List<TadabburNoteEntity>>> listNotes({
    String languageCode,
  });
}
