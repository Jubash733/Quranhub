import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_tafsir_entity.dart';

abstract class TafsirRepository {
  Future<Either<FailureResponse, AyahTafsirEntity>> getAyahTafsir(AyahRef ref);
}
