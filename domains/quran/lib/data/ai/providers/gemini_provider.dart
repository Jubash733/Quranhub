import 'package:dependencies/dio/dio.dart';
import '../ai_provider.dart';
import '../api_key_manager.dart';

class GeminiProvider implements AiProvider {
  final Dio dio;
  final ApiKeyManager keyManager;

  GeminiProvider({required this.dio, required this.keyManager});

  @override
  String get id => 'gemini';

  @override
  Future<String> generateText(
      {required String prompt, String? systemInstruction}) async {
    final apiKey = keyManager.getNextKey(id);
    if (apiKey == null) throw Exception('No API key available for Gemini');

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

    final response = await dio.post(
      url,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        if (systemInstruction != null)
          'systemInstruction': {
            'parts': [
              {'text': systemInstruction}
            ]
          }
      },
    );

    return response.data['candidates'][0]['content']['parts'][0]['text'];
  }
}
