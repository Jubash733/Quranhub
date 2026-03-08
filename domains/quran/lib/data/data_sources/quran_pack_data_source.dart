import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:common/utils/helper/asset_warning_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:dependencies/dio/dio.dart';
import 'package:dependencies/path/path.dart' as path;
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class PackManifestItem {
  PackManifestItem({
    required this.id,
    required this.name,
    required this.type,
    required this.language,
    required this.version,
    required this.size,
    required this.localPath,
    this.remoteUrl,
    this.format,
    this.variant,
    this.sourceUrl,
    this.checksum,
  });

  final String id;
  final String name;
  final String type;
  final String language;
  final String version;
  final int size;
  final String localPath;
  final String? remoteUrl;
  final String? format;
  final String? variant;
  final String? sourceUrl;
  final String? checksum;

  factory PackManifestItem.fromJson(Map<String, dynamic> json) {
    return PackManifestItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      language: json['language'] as String? ?? '',
      version: json['version'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      localPath: json['localPath'] as String? ?? '',
      remoteUrl: json['remoteUrl'] as String?,
      format: json['format'] as String?,
      variant: json['variant'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      checksum: json['checksum'] as String?,
    );
  }
}

abstract class QuranPackDataSource {
  Future<List<PackManifestItem>> getManifest();
  Future<bool> isPackAvailable(String editionId);
  Future<void> downloadPack(String editionId);
  Future<String?> getTranslation(AyahRef ref, String editionId);
  Future<String?> getTafsir(AyahRef ref, String editionId);
}

class QuranPackDataSourceImpl implements QuranPackDataSource {
  static const String _manifestPath = 'assets/packs/manifest.json';
  final Map<String, PackManifestItem> _manifest = {};
  final Map<String, Map<String, String>> _packCache = {};
  bool _manifestLoaded = false;

  final Dio dio;

  QuranPackDataSourceImpl({required this.dio});

  @override
  Future<List<PackManifestItem>> getManifest() async {
    await _loadManifest();
    return _manifest.values.toList();
  }

  @override
  Future<bool> isPackAvailable(String editionId) async {
    await _loadManifest();
    final item = _manifest[editionId];
    if (item == null || item.localPath.isEmpty) {
      return false;
    }
    if (_isAssetPath(item.localPath)) {
      return true;
    }
    final resolved = await _resolveLocalPath(item);
    if (resolved.isEmpty) {
      return false;
    }
    return File(resolved).exists();
  }

  @override
  Future<void> downloadPack(String editionId) async {
    await _loadManifest();
    final item = _manifest[editionId];
    if (item == null) {
      throw Exception('Pack $editionId not found in manifest');
    }
    if (item.remoteUrl == null || item.remoteUrl!.isEmpty) {
      throw Exception('Pack $editionId has no remote URL');
    }

    final resolvedPath = await _resolveLocalPath(item);
    if (resolvedPath.isEmpty) {
      throw Exception('Could not resolve local path for $editionId');
    }

    final file = File(resolvedPath);
    if (await file.exists()) {
      if (item.checksum != null) {
        final bytes = await file.readAsBytes();
        final digest = sha256.convert(bytes).toString();
        if (digest == item.checksum) return;
        await file.delete();
      } else {
        return;
      }
    }

    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    await dio.download(item.remoteUrl!, resolvedPath);

    if (item.checksum != null) {
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes).toString();
      if (digest != item.checksum) {
        await file.delete();
        throw Exception('Checksum verification failed for $editionId');
      }
    }
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String editionId) async {
    return _getText(ref, editionId, expectedType: 'translation');
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String editionId) async {
    return _getText(ref, editionId, expectedType: 'tafsir');
  }

  Future<String?> _getText(
    AyahRef ref,
    String editionId, {
    required String expectedType,
  }) async {
    final pack = await _loadPack(editionId, expectedType: expectedType);
    if (pack == null) {
      return null;
    }
    return pack['${ref.surah}:${ref.ayah}'];
  }

  Future<void> _loadManifest() async {
    if (_manifestLoaded) {
      return;
    }
    try {
      final raw = await rootBundle.loadString(_manifestPath);
      final payload = jsonDecode(raw);
      if (payload is! Map<String, dynamic>) {
        AssetWarningHelper.reportInvalidAsset(_manifestPath);
        _manifestLoaded = true;
        return;
      }
      final packs = payload['packs'];
      if (packs is! List) {
        AssetWarningHelper.reportInvalidAsset(_manifestPath);
        _manifestLoaded = true;
        return;
      }
      for (final item in packs) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final pack = PackManifestItem.fromJson(item);
        if (pack.id.isEmpty) {
          continue;
        }
        _manifest[pack.id] = pack;
      }
    } catch (e) {
      if (AssetWarningHelper.isMissingAssetError(e)) {
        AssetWarningHelper.reportMissingAsset(_manifestPath);
      } else {
        AssetWarningHelper.reportInvalidAsset(_manifestPath);
      }
    } finally {
      _manifestLoaded = true;
    }
  }

  Future<Map<String, String>?> _loadPack(
    String editionId, {
    required String expectedType,
  }) async {
    if (_packCache.containsKey(editionId)) {
      return _packCache[editionId];
    }
    await _loadManifest();
    final manifestItem = _manifest[editionId];
    if (manifestItem == null ||
        manifestItem.localPath.isEmpty ||
        manifestItem.type != expectedType) {
      return null;
    }
    final raw = await _loadPackRaw(manifestItem);
    if (raw == null) {
      return null;
    }
    try {
      final format = (manifestItem.format ?? 'pack-v1').toLowerCase();
      final map = switch (format) {
        'gutenberg-3way' => _parseGutenbergTriple(
            raw,
            variant: manifestItem.variant ?? 'P',
          ),
        _ => _parsePackJson(raw, manifestItem.localPath),
      };
      _packCache[editionId] = map;
      return map;
    } catch (e, st) {
      log(
        'Failed to parse pack ${manifestItem.id}',
        name: 'QuranPackDataSource',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<String?> _loadPackRaw(PackManifestItem item) async {
    final localPath = item.localPath;
    if (localPath.isEmpty) {
      return null;
    }
    if (_isAssetPath(localPath)) {
      try {
        return await rootBundle.loadString(localPath);
      } catch (e) {
        if (AssetWarningHelper.isMissingAssetError(e)) {
          AssetWarningHelper.reportMissingAsset(localPath);
        } else {
          AssetWarningHelper.reportInvalidAsset(localPath);
        }
        return null;
      }
    }
    final resolved = await _resolveLocalPath(item);
    if (resolved.isEmpty) {
      return null;
    }
    final file = File(resolved);
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  Map<String, String> _parsePackJson(String raw, String sourceLabel) {
    final payload = jsonDecode(raw);
    if (payload is! Map<String, dynamic>) {
      throw FormatException('Invalid pack payload: $sourceLabel');
    }
    final items = payload['items'];
    if (items is! List) {
      throw FormatException('Invalid pack items: $sourceLabel');
    }
    final map = <String, String>{};
    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final surah = (item['s'] as num?)?.toInt() ?? 0;
      final ayah = (item['a'] as num?)?.toInt() ?? 0;
      final text = item['t'] as String? ?? '';
      if (surah == 0 || ayah == 0 || text.isEmpty) {
        continue;
      }
      map['$surah:$ayah'] = text;
    }
    return map;
  }

  Map<String, String> _parseGutenbergTriple(
    String raw, {
    required String variant,
  }) {
    final pattern = RegExp(r'(\\d{3})\\.(\\d{3})\\s+Y:', multiLine: true);
    final matches = pattern.allMatches(raw).toList();
    if (matches.isEmpty) {
      return {};
    }
    final markerRegex = RegExp(r'([YPS]):');
    final target = variant.trim().toUpperCase();
    final map = <String, String>{};
    for (var i = 0; i < matches.length; i++) {
      final match = matches[i];
      final surah = int.tryParse(match.group(1) ?? '') ?? 0;
      final ayah = int.tryParse(match.group(2) ?? '') ?? 0;
      if (surah == 0 || ayah == 0) {
        continue;
      }
      final start = match.start;
      final end = i + 1 < matches.length ? matches[i + 1].start : raw.length;
      final segment = raw.substring(start, end);
      final markerMatches = markerRegex.allMatches(segment).toList();
      final parts = <String, String>{};
      for (var j = 0; j < markerMatches.length; j++) {
        final marker = markerMatches[j].group(1);
        if (marker == null) continue;
        final textStart = markerMatches[j].end;
        final textEnd = j + 1 < markerMatches.length
            ? markerMatches[j + 1].start
            : segment.length;
        final text = _normalizeWhitespace(
          segment.substring(textStart, textEnd),
        );
        if (text.isNotEmpty) {
          parts[marker] = text;
        }
      }
      final text = parts[target];
      if (text != null && text.isNotEmpty) {
        map['$surah:$ayah'] = text;
      }
    }
    log(
      'Parsed ${map.length} entries for variant $target',
      name: 'QuranPackDataSource',
    );
    return map;
  }

  String _normalizeWhitespace(String input) {
    return input.replaceAll(RegExp(r'\\s+'), ' ').trim();
  }

  bool _isAssetPath(String pathValue) {
    return pathValue.startsWith('assets/');
  }

  Future<String> _resolveLocalPath(PackManifestItem item) async {
    final localPath = item.localPath;
    if (localPath.isEmpty) {
      return '';
    }
    if (_isAssetPath(localPath) || path.isAbsolute(localPath)) {
      return localPath;
    }
    final baseDir = await getApplicationSupportDirectory();
    return path.join(baseDir.path, localPath);
  }
}
