import 'package:dependencies/isar/isar.dart';
import 'package:quran/data/models/ai_tadabbur_cache_model.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AiAssistantLocalDataSource {
  static const _cachePrefix = 'ai_tadabbur';
  static const Duration _ttl = Duration(days: 30);

  AiAssistantLocalDataSource({
    QuranCacheIsarService? isarService,
    Isar? isar,
    Map<String, AiTadabburEntity>? inMemoryCache,
  })  : _isarService = isarService,
        _isar = isar,
        _inMemoryCache = inMemoryCache;

  final QuranCacheIsarService? _isarService;
  final Isar? _isar;
  final Map<String, AiTadabburEntity>? _inMemoryCache;

  Future<Isar> _instance() async {
    if (_isar != null) {
      return _isar!;
    }
    return _isarService!.instance;
  }

  Future<AiTadabburEntity?> getCached(
    AyahRef ref,
    String languageCode,
    String promptVersion,
    String promptType,
  ) async {
    final key = _key(ref, languageCode, promptType, promptVersion);
    if (_inMemoryCache != null) {
      final cached = _inMemoryCache![key];
      if (cached == null) {
        return null;
      }
      if (DateTime.now().difference(cached.createdAt) > _ttl) {
        _inMemoryCache!.remove(key);
        return null;
      }
      return cached;
    }
    final isar = await _instance();
    final cached = await isar.aiTadabburCacheModels.getByKey(key);
    if (cached == null) {
      return null;
    }
    if (DateTime.now().difference(cached.createdAt) > _ttl) {
      await isar.writeTxn(() async {
        await isar.aiTadabburCacheModels.delete(cached.id);
      });
      return null;
    }
    return AiTadabburEntity(
      ref: AyahRef(surah: cached.surah, ayah: cached.ayah),
      response: cached.response,
      languageCode: cached.languageCode,
      createdAt: cached.createdAt,
      promptType: cached.promptType,
      promptVersion: cached.promptVersion,
    );
  }

  Future<void> cache(AiTadabburEntity entity) async {
    if (_inMemoryCache != null) {
      final key = _key(
        entity.ref,
        entity.languageCode,
        entity.promptType,
        entity.promptVersion,
      );
      _inMemoryCache![key] = entity;
      return;
    }
    final isar = await _instance();
    final model = AiTadabburCacheModel()
      ..key = _key(
        entity.ref,
        entity.languageCode,
        entity.promptType,
        entity.promptVersion,
      )
      ..surah = entity.ref.surah
      ..ayah = entity.ref.ayah
      ..languageCode = entity.languageCode
      ..promptType = entity.promptType
      ..promptVersion = entity.promptVersion
      ..response = entity.response
      ..createdAt = entity.createdAt;
    await isar.writeTxn(() async {
      await isar.aiTadabburCacheModels.putByKey(model);
    });
  }

  String _key(
    AyahRef ref,
    String languageCode,
    String promptType,
    String promptVersion,
  ) {
    return '$_cachePrefix:$promptType:$promptVersion:$languageCode:${ref.surah}:${ref.ayah}';
  }
}
