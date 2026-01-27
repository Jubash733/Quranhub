import 'package:dependencies/isar/isar.dart';
import 'package:quran/data/models/tafsir_cache_model.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TafsirCacheDataSource {
  TafsirCacheDataSource({required this.isarService});

  final QuranCacheIsarService isarService;

  Future<TafsirCacheModel?> getCachedTafsir(
    AyahRef ref, {
    required String languageCode,
    required String edition,
  }) async {
    final isar = await isarService.instance;
    final key = _buildKey(ref, languageCode, edition);
    return isar.tafsirCacheModels.filter().keyEqualTo(key).findFirst();
  }

  Future<void> cacheTafsir(
    AyahRef ref, {
    required String languageCode,
    required String edition,
    required String text,
  }) async {
    final isar = await isarService.instance;
    final model = TafsirCacheModel()
      ..key = _buildKey(ref, languageCode, edition)
      ..surah = ref.surah
      ..ayah = ref.ayah
      ..languageCode = languageCode
      ..edition = edition
      ..text = text
      ..updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.tafsirCacheModels.put(model);
    });
  }

  Future<void> clearAll() async {
    final isar = await isarService.instance;
    await isar.writeTxn(() async {
      await isar.tafsirCacheModels.clear();
    });
  }

  String _buildKey(AyahRef ref, String languageCode, String edition) {
    return '$edition:$languageCode:${ref.surah}:${ref.ayah}';
  }
}
