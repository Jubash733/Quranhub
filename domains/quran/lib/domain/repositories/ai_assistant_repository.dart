import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

abstract class AiAssistantRepository {
  Future<Either<FailureResponse, AiTadabburEntity>> getTadabbur(
    AyahRef ref, {
    String languageCode,
  });
}
