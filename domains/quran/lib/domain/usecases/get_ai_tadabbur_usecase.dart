import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/ai_assistant_repository.dart';

class GetAiTadabburUsecase {
  final AiAssistantRepository repository;

  const GetAiTadabburUsecase({required this.repository});

  Future<Either<FailureResponse, AiTadabburEntity>> call(
    AyahRef ref, {
    String languageCode = 'ar',
    String? userPrompt,
  }) {
    return repository.getTadabbur(
      ref,
      languageCode: languageCode,
      userPrompt: userPrompt,
    );
  }
}
