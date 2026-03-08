import 'package:quran/data/ai/ai_provider.dart';

abstract class AiAssistantRemoteDataSource {
  Future<String> generateTadabbur({required String prompt});
}

class AiAssistantRemoteDataSourceImpl extends AiAssistantRemoteDataSource {
  final List<AiProvider> providers;

  AiAssistantRemoteDataSourceImpl({required this.providers});

  @override
  Future<String> generateTadabbur({required String prompt}) async {
    if (providers.isEmpty) {
      throw Exception('No AI providers configured');
    }

    // Iterate through providers (fallback strategy)
    for (final provider in providers) {
      try {
        return await provider.generateText(
          prompt: prompt,
          systemInstruction:
              'You are a helpful Quran assistant providing Tadabbur insights.',
        );
      } catch (e) {
        // Log error and continue to next provider
        continue;
      }
    }
    throw Exception('All AI providers failed');
  }
}
