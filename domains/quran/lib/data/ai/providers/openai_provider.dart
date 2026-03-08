import 'package:dependencies/dio/dio.dart';
import '../ai_provider.dart';
import '../api_key_manager.dart';

class OpenAiProvider implements AiProvider {
  final Dio dio;
  final ApiKeyManager keyManager;

  OpenAiProvider({required this.dio, required this.keyManager});

  @override
  String get id => 'openai';

  @override
  Future<String> generateText(
      {required String prompt, String? systemInstruction}) async {
    final apiKey = keyManager.getNextKey(id);
    if (apiKey == null) throw Exception('No API key available for OpenAI');

    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': 'gpt-4o', // Or configurable model
        'messages': [
          if (systemInstruction != null)
            {'role': 'system', 'content': systemInstruction},
          {'role': 'user', 'content': prompt},
        ],
      },
    );

    return response.data['choices'][0]['message']['content'];
  }
}
