import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:common/utils/helper/asset_warning_helper.dart';
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
  bool _loadedText = false;

  @override
  Future<List<LocalAyahData>> getAllAyah() async {
    if (_cache != null) {
      return _cache!;
    }
    await _loadText();
    _cache = _cacheMap!.values.toList();
    return _cache!;
  }

  @override
  Future<LocalAyahData?> getAyah(AyahRef ref) async {
    await _loadText();
    return _cacheMap?[ref.key];
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String languageCode) async {
    return null;
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String languageCode) async {
    return null;
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
          en: '',
          id: '',
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
    const assetPath = 'assets/data/quran_text.json';
    try {
      final raw = await rootBundle.loadString(assetPath);
      final payload = jsonDecode(raw);
      if (payload is! List) {
        AssetWarningHelper.reportInvalidAsset(assetPath);
        _cacheMap = {};
        _loadedText = true;
        return;
      }
      final data = payload
          .map((item) => LocalAyahData.fromTextJson(item))
          .toList();
      _cacheMap = {for (final item in data) item.key(): item};
      _loadedText = true;
    } catch (e) {
      if (AssetWarningHelper.isMissingAssetError(e)) {
        AssetWarningHelper.reportMissingAsset(assetPath);
      } else {
        AssetWarningHelper.reportInvalidAsset(assetPath);
      }
      _cacheMap = {};
      _loadedText = true;
    }
  }
}

extension on AyahRef {
  String get key => '$surah:$ayah';
}
