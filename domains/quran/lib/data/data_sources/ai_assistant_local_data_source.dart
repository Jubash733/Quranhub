import 'dart:convert';

import 'package:dependencies/shared_preferences/shared_preferences.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AiAssistantLocalDataSource {
  static const _cachePrefix = 'ai_tadabbur';

  Future<AiTadabburEntity?> getCached(
    AyahRef ref,
    String languageCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(ref, languageCode));
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
    });
    await prefs.setString(_key(entity.ref, entity.languageCode), payload);
  }

  String _key(AyahRef ref, String languageCode) {
    return '$_cachePrefix:$languageCode:${ref.surah}:${ref.ayah}';
  }
}
