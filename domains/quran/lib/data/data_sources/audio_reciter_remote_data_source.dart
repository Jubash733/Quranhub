import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:quran/domain/entities/audio_reciter_entity.dart';

abstract class AudioReciterRemoteDataSource {
  Future<List<AudioReciterEntity>> getReciters();
}

class AudioReciterRemoteDataSourceImpl implements AudioReciterRemoteDataSource {
  AudioReciterRemoteDataSourceImpl();

  static const String _catalogPath = 'assets/data/audio_reciters.json';
  List<AudioReciterEntity>? _cache;

  @override
  Future<List<AudioReciterEntity>> getReciters() async {
    if (_cache != null) {
      return _cache!;
    }
    try {
      final raw = await rootBundle.loadString(_catalogPath);
      final payload = jsonDecode(raw);
      final reciters = _parseCatalog(payload);
      _cache = reciters;
      log(
        'Loaded ${reciters.length} reciters from catalog',
        name: 'AudioReciterRemoteDataSource',
      );
      return reciters;
    } catch (e, st) {
      log(
        'Failed to load reciter catalog',
        name: 'AudioReciterRemoteDataSource',
        error: e,
        stackTrace: st,
      );
      return [];
    }
  }

  List<AudioReciterEntity> _parseCatalog(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return [];
    }
    final payload = data['reciters'];
    if (payload is! List) {
      return [];
    }
    final reciters = <AudioReciterEntity>[];
    for (final item in payload) {
      if (item is! Map<String, dynamic>) {
        continue;
      }
      final identifier = item['identifier'] as String? ?? '';
      if (identifier.isEmpty) continue;
      final format = (item['format'] as String?)?.toLowerCase() ?? 'audio';
      final type = (item['type'] as String?)?.toLowerCase() ?? 'versebyverse';
      reciters.add(
        AudioReciterEntity(
          identifier: identifier,
          name: item['name'] as String? ?? '',
          englishName: item['englishName'] as String? ??
              item['english_name'] as String? ??
              '',
          language: item['language'] as String? ?? '',
          format: format,
          type: type,
          direction: item['direction'] as String?,
          allowDownload: item['allowDownload'] as bool? ?? false,
          downloadNote: item['downloadNote'] as String?,
        ),
      );
    }
    return reciters;
  }
}
