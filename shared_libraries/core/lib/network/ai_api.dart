import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  GenerativeModel? _model;

  void init() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    }
  }

  Future<String> getWordTafsir(String word, String verseText) async {
    final cacheKey = 'ai_word_tafsir_$word';
    final cached = _getCache(cacheKey);
    if (cached != null) return cached;

    if (_model == null) return 'AI_NOT_CONFIGURED';

    final prompt = 'Explain the meaning of the Arabic word "$word" in the context of this Quranic verse: "$verseText". Provide a concise explanation in Arabic.';
    
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final result = response.text ?? 'No explanation found.';
      _setCache(cacheKey, result);
      return result;
    } catch (e) {
      return 'Error fetching AI explanation: $e';
    }
  }

  Future<String> askQuran(String question) async {
    if (_model == null) return 'AI_NOT_CONFIGURED';

    final prompt = 'Answer the following question based only on the Quran: "$question". Provide references for any verses mentioned. Answer in Arabic.';
    
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'No answer found.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getMoodVerses(String mood) async {
    final cacheKey = 'ai_mood_verses_$mood';
    final cached = _getCache(cacheKey);
    if (cached != null) return cached;

    if (_model == null) return 'AI_NOT_CONFIGURED';

    final prompt = 'Suggest 3-5 Quranic verses for someone feeling "$mood". Provide the verse text in Arabic and a brief explanation of why they are suitable. Answer in Arabic.';
    
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final result = response.text ?? 'No suggestions found.';
      _setCache(cacheKey, result);
      return result;
    } catch (e) {
      return 'Error: $e';
    }
  }

  String? _getCache(String key) {
    if (!Hive.isBoxOpen('settings_box')) return null;
    final box = Hive.box('settings_box');
    final data = box.get(key);
    if (data == null) return null;
    
    final decoded = jsonDecode(data);
    final timestamp = decoded['timestamp'];
    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (DateTime.now().difference(cachedTime).inHours > 24) return null;
    
    return decoded['payload'];
  }

  void _setCache(String key, String payload) {
    if (!Hive.isBoxOpen('settings_box')) return;
    final box = Hive.box('settings_box');
    box.put(key, jsonEncode({
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'payload': payload,
    }));
  }
}
