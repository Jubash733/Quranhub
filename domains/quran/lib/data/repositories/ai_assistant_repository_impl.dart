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
      final cached = await localDataSource.getCached(ref, languageCode);
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
  }) {
    final isArabic = languageCode == 'ar';
    final intro = isArabic
        ? 'أنت مساعد تدبر للقرآن الكريم. اكتب إجابة عربية واضحة.'
        : 'You are a Quran reflection assistant. Write in clear English.';
    return '''
$intro

Verse Text:
$verseText

Translation:
$translation

Tafsir (if available):
$tafsir

Please respond with:
1) Summary of meaning
2) Key lessons
3) Suggested actions
4) Related verses (if any)
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
ملخص المعنى:
$translation

الدروس المستفادة:
- التأمل في ألفاظ الآية ومعانيها.
- تذكر عظمة الله ورحمته وتدبيره.

خطوات عملية مقترحة:
- قراءة الآية بتدبر مرة يوميًا.
- ربط معناها بموقف عملي في اليوم.
- الدعاء بالثبات والهداية.

آيات ذات صلة:
- ...

ملاحظة: هذه خلاصة مساعدة وليست تفسيرًا معتمدًا.
''';
    }
    return '''
Summary of meaning:
$translation

Key lessons:
- Reflect on the verse wording and meanings.
- Remember Allah's mercy, wisdom, and guidance.

Suggested actions:
- Revisit the verse daily with reflection.
- Connect its meaning to a real-life situation.
- Make a short dua for guidance and steadfastness.

Related verses:
- ...

Note: This is an assistant summary, not authoritative tafsir.
''';
  }
}
