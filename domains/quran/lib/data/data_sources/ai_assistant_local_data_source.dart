import 'dart:convert';

import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AiAssistantLocalDataSource {
  static const _cachePrefix = 'ai_tadabbur';

  Future<AiTadabburEntity?> getCached(
    AyahRef ref,
    String languageCode,
    String promptVersion,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(ref, languageCode, promptVersion));
    if (raw == null) {
      return null;
    }
    final payload = jsonDecode(raw) as Map<String, dynamic>;
    return AiTadabburEntity(
      ref: AyahRef(
        surah: payload['surah'] as int,
        ayah: payload['ayah'] as int,
      ),
      response: payload['response'] as String? ?? '',
      languageCode: payload['languageCode'] as String? ?? languageCode,
      createdAt: DateTime.tryParse(payload['createdAt'] as String? ?? '') ??
          DateTime.now(),
      promptVersion:
          payload['promptVersion'] as String? ?? promptVersion,
    );
  }

  Future<void> cache(AiTadabburEntity entity) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'surah': entity.ref.surah,
      'ayah': entity.ref.ayah,
      'response': entity.response,
      'languageCode': entity.languageCode,
      'createdAt': entity.createdAt.toIso8601String(),
      'promptVersion': entity.promptVersion,
    });
    await prefs.setString(
      _key(entity.ref, entity.languageCode, entity.promptVersion),
      payload,
    );
  }

  String _key(AyahRef ref, String languageCode, String promptVersion) {
    return '$_cachePrefix:$promptVersion:$languageCode:${ref.surah}:${ref.ayah}';
  }
}
