import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/tafsir_local_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_tafsir_entity.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';

class TafsirRepositoryImpl extends TafsirRepository {
  final TafsirLocalDataSource localDataSource;

  TafsirRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<FailureResponse, AyahTafsirEntity>> getAyahTafsir(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    try {
      final tafsir = await localDataSource.getAyahTafsir(ref, languageCode);
      if (tafsir == null || tafsir.isEmpty) {
        return Right(AyahTafsirEntity(
          ref: ref,
          text: '',
          languageCode: languageCode,
        ));
      }
      return Right(AyahTafsirEntity(
        ref: ref,
        text: tafsir,
        languageCode: languageCode,
      ));
    } on Exception catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }
}
