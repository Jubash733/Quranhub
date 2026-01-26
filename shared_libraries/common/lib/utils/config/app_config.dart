import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  AppConfig._();

  static String aiBaseUrl = '';
  static String aiApiKey = '';
  static String promptVersion = 'v1';

  static Future<void> load() async {
    try {
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
