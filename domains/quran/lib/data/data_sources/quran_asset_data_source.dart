import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

abstract class QuranAssetDataSource {
  Future<List<LocalAyahData>> getAllAyah();
  Future<LocalAyahData?> getAyah(AyahRef ref);
}

class QuranAssetDataSourceImpl implements QuranAssetDataSource {
  List<LocalAyahData>? _cache;
  Map<String, LocalAyahData>? _cacheMap;

  @override
  Future<List<LocalAyahData>> getAllAyah() async {
    if (_cache != null) {
      return _cache!;
    }
    final raw = await rootBundle.loadString('assets/data/quran_verses.json');
    final payload = jsonDecode(raw) as List<dynamic>;
    final data =
        payload.map((item) => LocalAyahData.fromJson(item)).toList();
    _cache = data;
    _cacheMap = {for (final item in data) item.key(): item};
    return data;
  }

  @override
  Future<LocalAyahData?> getAyah(AyahRef ref) async {
    if (_cacheMap != null) {
      return _cacheMap![ref.key];
    }
    await getAllAyah();
    return _cacheMap?[ref.key];
  }
}

extension on AyahRef {
  String get key => '$surah:$ayah';
}
