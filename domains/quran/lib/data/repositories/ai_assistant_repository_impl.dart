import 'package:common/utils/config/app_config.dart';
import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/ai_assistant_local_data_source.dart';
import 'package:quran/data/data_sources/ai_assistant_remote_data_source.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/ai_assistant_repository.dart';
import 'package:quran/domain/repositories/tafsir_repository.dart';
import 'package:quran/domain/repositories/translation_repository.dart';
import 'package:resources/constant/api_constant.dart';

class AiAssistantRepositoryImpl extends AiAssistantRepository {
  final AiAssistantLocalDataSource localDataSource;
  final AiAssistantRemoteDataSource remoteDataSource;
  final QuranAssetDataSource assetDataSource;
  final TranslationRepository translationRepository;
  final TafsirRepository tafsirRepository;

  AiAssistantRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.assetDataSource,
    required this.translationRepository,
    required this.tafsirRepository,
  });

  @override
  Future<Either<FailureResponse, AiTadabburEntity>> getTadabbur(
    AyahRef ref, {
    String languageCode = 'ar',
    String? userPrompt,
  }) async {
    try {
      if (!_isAiConfigured()) {
        return const Left(FailureResponse(message: 'AI_NOT_CONFIGURED'));
      }
      final promptVersion = AppConfig.promptVersion;
      const promptType = 'tadabbur';
      const resolvedLanguage = 'ar';
      final cached = await localDataSource.getCached(
        ref,
        resolvedLanguage,
        promptVersion,
        promptType,
      );
      if (cached != null) {
        return Right(cached);
      }

      final verse = await assetDataSource.getAyah(ref);
      if (verse == null) {
        return Left(FailureResponse(
            message: 'Ayah not found for surah ${ref.surah}, ayah ${ref.ayah}'));
      }

      final translation = await _safeTranslation(ref, resolvedLanguage);
      final tafsir = await _safeTafsir(ref, resolvedLanguage);

      final prompt = _buildPrompt(
        verseText: verse.textArabic,
        translation: translation,
        tafsir: tafsir,
        languageCode: resolvedLanguage,
        promptVersion: promptVersion,
        userPrompt: userPrompt,
      );

      String response;
      try {
        response = await remoteDataSource.generateTadabbur(prompt: prompt);
      } catch (_) {
        response = _fallbackResponse(
          verseText: verse.textArabic,
          translation: translation,
          tafsir: tafsir,
          languageCode: resolvedLanguage,
        );
      }

      final entity = AiTadabburEntity(
        ref: ref,
        response: response,
        languageCode: resolvedLanguage,
        createdAt: DateTime.now(),
        promptType: promptType,
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
    String? userPrompt,
  }) {
    final isArabic = languageCode == 'ar';
    final requestLine = (userPrompt ?? '').trim().isEmpty
        ? ''
        : '\nUser request: ${userPrompt!.trim()}';
    final intro = isArabic
        ? 'أنت مساعد للتدبر في القرآن. اكتب بالعربية الفصحى وبأسلوب واضح ومختصر.'
        : 'You are a Quran reflection assistant. Write in clear English.';
    if (isArabic) {
      return '''
$intro
إصدار الموجه: $promptVersion

نص الآية:
$verseText

الترجمة:
$translation

التفسير (إن توفر):
$tafsir$requestLine

رجاءً أجب بهذه الأقسام:
1) خلاصة المعنى (سطران كحد أقصى)
2) الكلمات المفتاحية (مفصولة بفواصل)
3) آيات ذات صلة (إن وجدت مع سورة:آية)
4) تذكير عملي (3 نقاط)
5) تنبيه: "مخرجات مساعدة وليست فتوى"
''';
    }
    return '''
$intro
Prompt version: $promptVersion

Verse Text:
$verseText

Translation:
$translation

Tafsir (if available):
$tafsir$requestLine

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
خلاصة المعنى:
$translation

الكلمات المفتاحية:
- ...

آيات ذات صلة:
- ...

تذكير عملي:
- راجع الآية بتدبر اليوم.
- اربط المعنى بخطوة عملية صغيرة.
- اختم بدعاء هداية مختصر.

تنبيه: "مخرجات مساعدة وليست فتوى".
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

  Future<String> _safeTranslation(
    AyahRef ref,
    String languageCode,
  ) async {
    final result = await translationRepository.getAyahTranslation(ref,
        languageCode: languageCode);
    return result.fold((_) => '', (data) => data.text);
  }

  Future<String> _safeTafsir(
    AyahRef ref,
    String languageCode,
  ) async {
    final result =
        await tafsirRepository.getAyahTafsir(ref, languageCode: languageCode);
    return result.fold((_) => '', (data) => data.text);
  }

  bool _isAiConfigured() {
    final resolvedKey = AppConfig.aiApiKey.isNotEmpty
        ? AppConfig.aiApiKey
        : ApiConstant.aiApiKey;
    return resolvedKey.isNotEmpty;
  }
}
