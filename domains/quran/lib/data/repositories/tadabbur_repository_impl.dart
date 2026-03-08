import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/tadabbur_local_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/repositories/tadabbur_repository.dart';

class TadabburRepositoryImpl extends TadabburRepository {
  TadabburRepositoryImpl({required this.localDataSource});

  final TadabburLocalDataSource localDataSource;

  @override
  Future<Either<FailureResponse, TadabburNoteEntity?>> getNote(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    try {
      final note = await localDataSource.getNote(ref, languageCode);
      return Right(note);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, TadabburNoteEntity>> saveNote(
    AyahRef ref, {
    required String text,
    List<String> tags = const [],
    String languageCode = 'ar',
  }) async {
    try {
      final note =
          await localDataSource.saveNote(ref, languageCode, text, tags: tags);
      return Right(note);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, bool>> deleteNote(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    try {
      await localDataSource.deleteNote(ref, languageCode);
      return const Right(true);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<Either<FailureResponse, List<TadabburNoteEntity>>> listNotes({
    String languageCode = 'ar',
  }) async {
    try {
      final notes = await localDataSource.listNotes(languageCode);
      return Right(notes);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }
}
