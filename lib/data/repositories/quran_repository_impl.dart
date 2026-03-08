import '../../domain/entities/surah.dart';
import '../../domain/entities/verse.dart';
import '../../domain/repositories/quran_repository.dart';
import '../api/quran_api.dart';
import '../local/quran_local_database.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

class QuranRepositoryImpl implements QuranRepository {
  final QuranApi api;
  final QuranLocalDatabase localDb;

  QuranRepositoryImpl({required this.api, required this.localDb});

  @override
  Future<List<Surah>> getSurahs() async {
    final box = Hive.box(QuranLocalDatabase.settingsBox); // Reusing settingsbox for simple cache or create a specific cache box
    final cachedData = box.get('chapters_cache');
    
    if (cachedData != null) {
      return _parseSurahs(jsonDecode(cachedData));
    }

    try {
      final response = await api.getChapters();
      box.put('chapters_cache', jsonEncode(response));
      return _parseSurahs(response);
    } catch (e) {
      if (cachedData != null) return _parseSurahs(jsonDecode(cachedData));
      throw Exception('Failed to load surahs: $e');
    }
  }

  @override
  Future<List<Verse>> getVersesBySurah(int surahId, {int? translations, int? tafsirs}) async {
    final cacheKey = 'verses_${surahId}_t${translations}_f${tafsirs}';
    final box = Hive.box(QuranLocalDatabase.settingsBox); 
    final cachedData = box.get(cacheKey);

    if (cachedData != null) {
      return _parseVerses(jsonDecode(cachedData));
    }

    try {
      final response = await api.getVersesByChapter(surahId, translations: translations, tafsirs: tafsirs);
      box.put(cacheKey, jsonEncode(response));
      return _parseVerses(response);
    } catch (e) {
      if (cachedData != null) return _parseVerses(jsonDecode(cachedData));
      throw Exception('Failed to load verses: $e');
    }
  }

  @override
  Future<String> getAudioUrl(String reciter, String surahAyah) async {
    return 'https://everyayah.com/data/$reciter/$surahAyah.mp3';
  }

  bool _isCacheValid(dynamic cachedObj) {
    if (cachedObj == null) return false;
    try {
      final data = jsonDecode(cachedObj);
      final timestamp = data['timestamp'];
      if (timestamp == null) return false;
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final age = DateTime.now().difference(cachedTime);
      return age.inDays < 7; // 7 days expiry
    } catch (_) {
      return false;
    }
  }

  String _extractCachedPayload(dynamic cachedObj) {
    return jsonDecode(cachedObj)['payload'];
  }

  String _createCacheObj(String payload) {
    return jsonEncode({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'payload': payload,
    });
  }

  @override
  Future<String> getVerseTafsir(String verseKey, int tafsirId) async {
    final cacheKey = 'tafsir_${tafsirId}_$verseKey';
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    final cachedObj = box.get(cacheKey);

    if (_isCacheValid(cachedObj)) {
      return _extractCachedPayload(cachedObj);
    }

    try {
      final response = await api.getVerseTafsir(tafsirId, verseKey);
      if (response != null && response['tafsirs'] != null && (response['tafsirs'] as List).isNotEmpty) {
        final text = response['tafsirs'][0]['text'];
        box.put(cacheKey, _createCacheObj(text));
        return text;
      }
      return 'لا يوجد تفسير متاح.';
    } catch (e) {
      if (cachedObj != null) {
        return _extractCachedPayload(cachedObj) + '\n\n(محتوى مخزن مؤقتاً لعدم وجود انترنت)';
      }
      return 'يتطلب اتصال بالإنترنت لجلب التفسير.';
    }
  }

  @override
  Future<String> getVerseTranslation(String verseKey, int translationId) async {
    final cacheKey = 'translation_${translationId}_$verseKey';
    final box = Hive.box(QuranLocalDatabase.settingsBox);
    final cachedObj = box.get(cacheKey);

    if (_isCacheValid(cachedObj)) {
      return _extractCachedPayload(cachedObj);
    }

    try {
      final response = await api.getVerseTranslation(translationId, verseKey);
      if (response != null && response['translations'] != null && (response['translations'] as List).isNotEmpty) {
        final text = response['translations'][0]['text'];
        box.put(cacheKey, _createCacheObj(text));
        return text;
      }
      return 'No translation available.';
    } catch (e) {
      if (cachedObj != null) {
        return _extractCachedPayload(cachedObj) + '\n\n(Cached content - No internet)';
      }
      return 'Internet connection required to fetch translation.';
    }
  }

  List<Surah> _parseSurahs(dynamic json) {
    if (json == null || json['chapters'] == null) return [];
    final List chapters = json['chapters'];
    return chapters.map((c) => Surah(
      id: c['id'],
      name: c['name_arabic'],
      englishName: c['name_simple'],
      number: c['id'],
    )).toList();
  }

  List<Verse> _parseVerses(dynamic json) {
    if (json == null || json['verses'] == null) return [];
    final List verses = json['verses'];
    return verses.map((v) {
      String? translation;
      if (v['translations'] != null && (v['translations'] as List).isNotEmpty) {
        translation = v['translations'][0]['text'];
      }
      
      String? tafsir;
      if (v['tafsirs'] != null && (v['tafsirs'] as List).isNotEmpty) {
        tafsir = v['tafsirs'][0]['text'];
      }
      
      return Verse(
        id: v['id'],
        verseNumber: v['verse_number'],
        text: v['text_uthmani'] ?? v['text_imlaei_simple'] ?? '',
        translation: translation,
        tafsir: tafsir,
      );
    }).toList();
  }
}
