import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dependencies/dio/dio.dart';
import 'package:dependencies/isar/isar.dart';
import 'package:dependencies/path/path.dart' as path;
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:quran/data/models/audio_cache_model.dart';
import 'package:quran/data/storage/quran_cache_isar_service.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AudioCacheEntry {
  const AudioCacheEntry({
    required this.ref,
    required this.url,
    required this.edition,
    required this.filePath,
    required this.sizeBytes,
    required this.updatedAt,
    required this.lastAccessAt,
  });

  final AyahRef ref;
  final String url;
  final String edition;
  final String filePath;
  final int sizeBytes;
  final DateTime updatedAt;
  final DateTime lastAccessAt;
}

class AudioCacheDataSource {
  static const int maxCacheBytes = 500 * 1024 * 1024;
  static const Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0',
    'Accept': '*/*',
  };
  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const int _maxDownloadRetries = 2;

  AudioCacheDataSource({
    required this.isarService,
    required this.dio,
    this.baseDir,
  });

  final QuranCacheIsarService isarService;
  final Dio dio;
  final Directory? baseDir;

  Future<AudioCacheEntry?> getCached(AyahRef ref, String edition) async {
    final isar = await isarService.instance;
    final key = _key(ref, edition);
    final cached = await isar.audioCacheModels.getByKey(key);
    if (cached == null) {
      return null;
    }
    final file = File(cached.filePath);
    if (!await file.exists()) {
      await isar.writeTxn(() async {
        await isar.audioCacheModels.delete(cached.id);
      });
      return null;
    }
    final updated = cached..lastAccessAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.audioCacheModels.putByKey(updated);
    });
    return AudioCacheEntry(
      ref: AyahRef(surah: cached.surah, ayah: cached.ayah),
      url: cached.url,
      edition: cached.edition,
      filePath: cached.filePath,
      sizeBytes: cached.sizeBytes,
      updatedAt: cached.updatedAt,
      lastAccessAt: updated.lastAccessAt,
    );
  }

  Future<AudioCacheEntry> downloadAndCache({
    required AyahRef ref,
    required String edition,
    required String url,
  }) async {
    final targetDir = await _audioDir();
    final editionDir = Directory(path.join(targetDir.path, edition));
    if (!await editionDir.exists()) {
      await editionDir.create(recursive: true);
    }
    final fileName = '${ref.surah}_${ref.ayah}.mp3';
    final filePath = path.join(editionDir.path, fileName);
    final file = File(filePath);
    if (!await file.exists()) {
      dio.options.connectTimeout = _connectTimeout;
      for (var attempt = 0; attempt <= _maxDownloadRetries; attempt++) {
        try {
          log(
            'Downloading $url -> $filePath (attempt ${attempt + 1})',
            name: 'AudioCacheDataSource',
          );
          final response = await dio.download(
            url,
            filePath,
            options: Options(
              headers: _headers,
              receiveTimeout: _receiveTimeout,
              sendTimeout: _connectTimeout,
              followRedirects: true,
            ),
            deleteOnError: true,
          );
          log(
            'Download complete (status: ${response.statusCode})',
            name: 'AudioCacheDataSource',
          );
          break;
        } catch (e, st) {
          log(
            'Download failed (attempt ${attempt + 1})',
            name: 'AudioCacheDataSource',
            error: e,
            stackTrace: st,
          );
          if (await file.exists()) {
            await file.delete();
          }
          if (attempt >= _maxDownloadRetries) {
            rethrow;
          }
          await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
        }
      }
    }
    final sizeBytes = await file.length();
    final now = DateTime.now();
    final model = AudioCacheModel()
      ..key = _key(ref, edition)
      ..url = url
      ..edition = edition
      ..surah = ref.surah
      ..ayah = ref.ayah
      ..filePath = filePath
      ..sizeBytes = sizeBytes
      ..updatedAt = now
      ..lastAccessAt = now;
    final isar = await isarService.instance;
    await isar.writeTxn(() async {
      await isar.audioCacheModels.putByKey(model);
    });
    await _pruneIfNeeded();
    return AudioCacheEntry(
      ref: ref,
      url: url,
      edition: edition,
      filePath: filePath,
      sizeBytes: sizeBytes,
      updatedAt: now,
      lastAccessAt: now,
    );
  }

  Future<int> getTotalSizeBytes() async {
    final isar = await isarService.instance;
    final items = await isar.audioCacheModels.where().findAll();
    var total = 0;
    for (final item in items) {
      total += item.sizeBytes;
    }
    return total;
  }

  Future<void> clearAll() async {
    final isar = await isarService.instance;
    final items = await isar.audioCacheModels.where().findAll();
    await _deleteEntries(items);
    await isar.writeTxn(() async {
      await isar.audioCacheModels.clear();
    });
  }

  Future<void> clearByReciter(String edition) async {
    final isar = await isarService.instance;
    final items =
        await isar.audioCacheModels.filter().editionEqualTo(edition).findAll();
    await _deleteEntries(items);
    await isar.writeTxn(() async {
      await isar.audioCacheModels
          .filter()
          .editionEqualTo(edition)
          .deleteAll();
    });
  }

  Future<void> clearBySurah(int surah) async {
    final isar = await isarService.instance;
    final items =
        await isar.audioCacheModels.filter().surahEqualTo(surah).findAll();
    await _deleteEntries(items);
    await isar.writeTxn(() async {
      await isar.audioCacheModels.filter().surahEqualTo(surah).deleteAll();
    });
  }

  Future<void> _deleteEntries(List<AudioCacheModel> items) async {
    for (final item in items) {
      final file = File(item.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> _pruneIfNeeded() async {
    final isar = await isarService.instance;
    final items = await isar.audioCacheModels.where().findAll();
    var total = items.fold<int>(0, (sum, item) => sum + item.sizeBytes);
    if (total <= maxCacheBytes) {
      return;
    }
    final sorted = items.toList()
      ..sort((a, b) => a.lastAccessAt.compareTo(b.lastAccessAt));
    for (final item in sorted) {
      if (total <= maxCacheBytes) {
        break;
      }
      final file = File(item.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      total -= item.sizeBytes;
      await isar.writeTxn(() async {
        await isar.audioCacheModels.delete(item.id);
      });
    }
  }

  Future<Directory> _audioDir() async {
    final root = baseDir ?? await getApplicationSupportDirectory();
    final dir = Directory(path.join(root.path, 'audio_cache'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _key(AyahRef ref, String edition) {
    return 'audio:$edition:${ref.surah}:${ref.ayah}';
  }
}
