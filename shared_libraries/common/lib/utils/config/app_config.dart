import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  AppConfig._();

  static String aiBaseUrl = '';
  static String aiApiKey = '';
  static String promptVersion = 'v1';

  static Future<void> load() async {
    try {
      const envBaseUrl = String.fromEnvironment('AI_BASE_URL');
      const envApiKey = String.fromEnvironment('AI_API_KEY');
      if (envBaseUrl.isNotEmpty) {
        aiBaseUrl = envBaseUrl;
      }
      if (envApiKey.isNotEmpty) {
        aiApiKey = envApiKey;
      }
      final raw = await rootBundle.loadString('assets/config/app_config.json');
      final payload = jsonDecode(raw) as Map<String, dynamic>;
      aiBaseUrl = payload['aiBaseUrl'] as String? ?? aiBaseUrl;
      aiApiKey = payload['aiApiKey'] as String? ?? aiApiKey;
      promptVersion = payload['promptVersion'] as String? ?? promptVersion;
    } catch (_) {
      // Keep defaults if config is missing.
    }
  }
}
