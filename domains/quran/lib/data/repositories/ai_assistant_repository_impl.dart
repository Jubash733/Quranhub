import 'package:common/utils/config/app_config.dart';
import 'package:common/utils/config/app_config.dart';
import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_remote_data_source.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/data_sources/tafsir_local_data_source.dart';
import 'package:quran/data/data_sources/translation_local_data_source.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/ai_assistant_repository.dart';

class AiAssistantRepositoryImpl extends AiAssistantRepository {
  final AiAssistantLocalDataSource localDataSource;
  final AiAssistantRemoteDataSource remoteDataSource;
  final QuranAssetDataSource assetDataSource;
  final TranslationLocalDataSource translationLocalDataSource;
  final TafsirLocalDataSource tafsirLocalDataSource;

  AiAssistantRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.assetDataSource,
    required this.translationLocalDataSource,
    required this.tafsirLocalDataSource,
  });

  @override
  Future<Either<FailureResponse, AiTadabburEntity>> getTadabbur(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    try {
      final promptVersion = AppConfig.promptVersion;
      final cached = await localDataSource.getCached(ref, languageCode, promptVersion);
      if (cached != null) {
        return Right(cached);
      }

      final verse = await assetDataSource.getAyah(ref);
      if (verse == null) {
        return Left(FailureResponse(
            message: 'Ayah not found for surah ${ref.surah}, ayah ${ref.ayah}'));
      }

      final translation =
          await translationLocalDataSource.getAyahTranslation(ref, languageCode) ??
              '';
      final tafsir =
          await tafsirLocalDataSource.getAyahTafsir(ref, languageCode) ?? '';

      final prompt = _buildPrompt(
        verseText: verse.textArabic,
        translation: translation,
        tafsir: tafsir,
        languageCode: languageCode,
        promptVersion: promptVersion,
      );

      String response;
      try {
        response = await remoteDataSource.generateTadabbur(prompt: prompt);
      } catch (_) {
        response = _fallbackResponse(
          verseText: verse.textArabic,
          translation: translation,
          tafsir: tafsir,
          languageCode: languageCode,
        );
      }

      final entity = AiTadabburEntity(
        ref: ref,
        response: response,
        languageCode: languageCode,
        createdAt: DateTime.now(),
        promptVersion: promptVersion,
      );
      await localDataSource.cache(entity);
      return Right(entity);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  
  String _buildPrompt({
    required String verseText,
    required String translation,
    required String tafsir,
    required String languageCode,
    required String promptVersion,
  }) {
    final isArabic = languageCode == 'ar';
    final intro = isArabic
        ? '??? ????? ???? ?????? ??????. ???? ????? ????? ????? ??????.'
        : 'You are a Quran reflection assistant. Write in clear English.';
    return '''
$intro
Prompt version: $promptVersion

Verse Text:
$verseText

Translation:
$translation

Tafsir (if available):
$tafsir

Please respond with these sections:
1) Summary of meaning (short)
2) Main keywords (comma-separated)
3) Related verses (if any, include surah:ayah)
4) Actionable reminders (3 bullets)
5) Disclaimer: "AI output is assistant only, not fatwa"
''';
  }

  
  String _fallbackResponse({
    required String verseText,
    required String translation,
    required String tafsir,
    required String languageCode,
  }) {
    final isArabic = languageCode == 'ar';
    if (isArabic) {
      return '''
???? ??????:
$translation

??????? ????????:
- ...

???? ??? ???:
- ...

??????? ?????:
- ???? ????? ????? ?????.
- ???? ?????? ????? ???? ????.
- ???? ????? ???????.

?????: "?????? ?????? ????? ????".
''';
    }
    return '''
Summary of meaning:
$translation

Main keywords:
- ...

Related verses:
- ...

Actionable reminders:
- Revisit the verse with reflection today.
- Connect the meaning to a small real-life action.
- End with a short dua for guidance.

Disclaimer: "AI output is assistant only, not fatwa".
''';
  }
}
