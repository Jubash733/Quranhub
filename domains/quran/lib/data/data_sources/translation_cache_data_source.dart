import 'package:quran/data/database/database_helper.dart';
import 'package:quran/data/models/translation_cache_entry.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TranslationCacheDataSource {
  TranslationCacheDataSource({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  Future<TranslationCacheEntry?> getCachedTranslation(
    AyahRef ref, {
    required String languageCode,
    required String edition,
  }) async {
    await databaseHelper.ensureQuranCoreData();
    final row = await databaseHelper.getCachedTranslation(
      surah: ref.surah,
      ayah: ref.ayah,
      languageCode: languageCode,
      edition: edition,
    );
    if (row == null) return null;
    return TranslationCacheEntry(
      text: row['text'] as String? ?? '',
      edition: row['edition'] as String? ?? edition,
      updatedAtMillis: row['updatedAt'] as int? ?? 0,
    );
  }

  Future<void> cacheTranslation(
    AyahRef ref, {
    required String languageCode,
    required String edition,
    required String text,
  }) async {
    await databaseHelper.ensureQuranCoreData();
    await databaseHelper.upsertTranslationCache(
      surah: ref.surah,
      ayah: ref.ayah,
      languageCode: languageCode,
      edition: edition,
      text: text,
    );
  }

  Future<void> clearTranslations(String languageCode) async {
    await databaseHelper.clearTranslations(languageCode);
  }
}
