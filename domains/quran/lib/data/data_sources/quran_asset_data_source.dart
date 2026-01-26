import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/data/models/detail_surah_dto.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

abstract class QuranAssetDataSource {
  Future<List<LocalAyahData>> getAllAyah();
  Future<LocalAyahData?> getAyah(AyahRef ref);
  Future<String?> getTranslation(AyahRef ref, String languageCode);
  Future<String?> getTafsir(AyahRef ref, String languageCode);
  Future<List<SurahDTO>> getSurahList();
  Future<DetailSurahDTO?> getDetailSurah(int id);
}

class QuranAssetDataSourceImpl implements QuranAssetDataSource {
  List<LocalAyahData>? _cache;
  Map<String, LocalAyahData>? _cacheMap;
  final Map<String, Map<String, String>> _translationCache = {};
  final Map<String, Map<String, String>> _tafsirCache = {};
  bool _loadedText = false;

  @override
  Future<List<LocalAyahData>> getAllAyah() async {
    if (_cache != null) {
      return _cache!;
    }
    await _loadText();
    await _loadTranslation('ar');
    await _loadTranslation('en');
    await _loadTafsir('ar');

    final data = _cacheMap!.values.map((item) {
      final key = item.key();
      final translation = <String, String>{};
      for (final entry in _translationCache.entries) {
        translation[entry.key] = entry.value[key] ?? '';
      }
      final tafsir = <String, String>{};
      for (final entry in _tafsirCache.entries) {
        tafsir[entry.key] = entry.value[key] ?? '';
      }
      return item.copyWith(
        translation: translation,
        tafsir: tafsir,
      );
    }).toList();

    _cache = data;
    return data;
  }

  @override
  Future<LocalAyahData?> getAyah(AyahRef ref) async {
    await _loadText();
    final base = _cacheMap?[ref.key];
    if (base == null) {
      return null;
    }
    final translation = <String, String>{};
    final tafsir = <String, String>{};
    for (final entry in _translationCache.entries) {
      translation[entry.key] = entry.value[ref.key] ?? '';
    }
    for (final entry in _tafsirCache.entries) {
      tafsir[entry.key] = entry.value[ref.key] ?? '';
    }
    return base.copyWith(translation: translation, tafsir: tafsir);
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String languageCode) async {
    await _loadTranslation(languageCode);
    return _translationCache[languageCode]?[ref.key];
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String languageCode) async {
    await _loadTafsir(languageCode);
    return _tafsirCache[languageCode]?[ref.key];
  }

  @override
  Future<List<SurahDTO>> getSurahList() async {
    await _loadText();
    final grouped = <int, List<LocalAyahData>>{};
    for (final entry in _cacheMap!.values) {
      grouped.putIfAbsent(entry.surah, () => []).add(entry);
    }

    return grouped.entries.map((entry) {
      final surahNumber = entry.key;
      final verses = entry.value..sort((a, b) => a.ayah.compareTo(b.ayah));
      final first = verses.first;
      final numberOfVerses = verses.length;
      final name = NameDTO(
        short: first.surahNameAr,
        long: first.surahNameAr,
        transliteration: TranslationDTO(
          en: first.surahNameEn,
          id: first.surahNameEn,
        ),
        translation: TranslationDTO(
          en: first.surahNameEn,
          id: first.surahNameEn,
        ),
      );
      final revelation = RevelationDTO(
        arab: '',
        en: '',
        id: '',
      );
      final tafsir = TafsirDTO(id: '');
      return SurahDTO(
        number: surahNumber,
        sequence: surahNumber,
        numberOfVerses: numberOfVerses,
        name: name,
        revelation: revelation,
        tafsir: tafsir,
      );
    }).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
  }

  @override
  Future<DetailSurahDTO?> getDetailSurah(int id) async {
    await _loadText();
    await _loadTranslation('en');
    await _loadTranslation('ar');
    final verses = _cacheMap!.values
        .where((item) => item.surah == id)
        .toList()
      ..sort((a, b) => a.ayah.compareTo(b.ayah));
    if (verses.isEmpty) {
      return null;
    }
    final first = verses.first;
    final name = NameDTO(
      short: first.surahNameAr,
      long: first.surahNameAr,
      transliteration: TranslationDTO(
        en: first.surahNameEn,
        id: first.surahNameEn,
      ),
      translation: TranslationDTO(
        en: first.surahNameEn,
        id: first.surahNameEn,
      ),
    );
    final revelation = RevelationDTO(
      arab: '',
      en: '',
      id: '',
    );
    final tafsir = TafsirDTO(id: '');

    final allSorted = _cacheMap!.values.toList()
      ..sort((a, b) {
        final bySurah = a.surah.compareTo(b.surah);
        if (bySurah != 0) return bySurah;
        return a.ayah.compareTo(b.ayah);
      });
    final inQuranMap = <String, int>{};
    for (var i = 0; i < allSorted.length; i++) {
      inQuranMap[allSorted[i].key()] = i + 1;
    }

    final verseDtos = verses.map((item) {
      final inQuran = inQuranMap[item.key()] ?? item.ayah;
      return VerseDTO(
        number: NumberDTO(
          inQuran: inQuran,
          inSurah: item.ayah,
        ),
        meta: MetaDTO(
          juz: 0,
          page: 0,
          manzil: 0,
          ruku: 0,
          hizbQuarter: 0,
          sajda: SajdaDTO(recommended: false, obligatory: false),
        ),
        text: TextDTO(
          arab: item.textArabic,
          transliteration: TransliterationDTO(en: ''),
        ),
        translation: TranslationDTO(
          en: _translationCache['en']?[item.key()] ?? '',
          id: _translationCache['ar']?[item.key()] ?? '',
        ),
        audio: AudioDTO(
          primary: '',
          secondary: const [],
        ),
        tafsir: VerseTafsirDTO(
          id: IdDTO(short: '', long: ''),
        ),
      );
    }).toList();

    return DetailSurahDTO(
      number: id,
      sequence: id,
      numberOfVerses: verses.length,
      name: name,
      revelation: revelation,
      tafsir: tafsir,
      preBismillah: null,
      verses: verseDtos,
    );
  }

  Future<void> _loadText() async {
    if (_loadedText) {
      return;
    }
    final raw = await rootBundle.loadString('assets/data/quran_text.json');
    final payload = jsonDecode(raw) as List<dynamic>;
    final data = payload
        .map((item) => LocalAyahData.fromTextJson(item))
        .toList();
    _cacheMap = {for (final item in data) item.key(): item};
    _loadedText = true;
  }

  Future<void> _loadTranslation(String languageCode) async {
    if (_translationCache.containsKey(languageCode)) {
      return;
    }
    try {
      final raw = await rootBundle
          .loadString('assets/data/translations/$languageCode.json');
      final payload = jsonDecode(raw) as List<dynamic>;
      final map = <String, String>{};
      for (final item in payload) {
        final ref = AyahRef(
          surah: item['surah'] as int,
          ayah: item['ayah'] as int,
        );
        map[ref.key] = item['text'] as String? ?? '';
      }
      _translationCache[languageCode] = map;
    } catch (_) {
      _translationCache[languageCode] = {};
    }
  }

  Future<void> _loadTafsir(String languageCode) async {
    if (_tafsirCache.containsKey(languageCode)) {
      return;
    }
    try {
      final raw =
          await rootBundle.loadString('assets/data/tafsir/$languageCode.json');
      final payload = jsonDecode(raw) as List<dynamic>;
      final map = <String, String>{};
      for (final item in payload) {
        final ref = AyahRef(
          surah: item['surah'] as int,
          ayah: item['ayah'] as int,
        );
        map[ref.key] = item['text'] as String? ?? '';
      }
      _tafsirCache[languageCode] = map;
    } catch (_) {
      _tafsirCache[languageCode] = {};
    }
  }
}

extension on AyahRef {
  String get key => '$surah:$ayah';
}
