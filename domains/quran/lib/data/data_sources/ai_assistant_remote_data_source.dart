import 'package:dependencies/dio/dio.dart';
import 'package:common/utils/config/app_config.dart';

abstract class AiAssistantRemoteDataSource {
  Future<String> generateTadabbur({required String prompt});
}

class AiAssistantRemoteDataSourceImpl extends AiAssistantRemoteDataSource {
  final Dio dio;

  AiAssistantRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> generateTadabbur({required String prompt}) async {
    if (AppConfig.aiBaseUrl.isEmpty) {
      throw Exception('AI endpoint not configured');
    }

    final response = await dio.post(
      AppConfig.aiBaseUrl,
      data: {
        'prompt': prompt,
      },
      options: Options(
        headers: AppConfig.aiApiKey.isEmpty
            ? null
            : {
                'Authorization': 'Bearer ${AppConfig.aiApiKey}',
              },
      ),
    );

    return _extractText(response.data);
  }

  String _extractText(dynamic data) {
    if (data is String) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      if (data['text'] is String) {
        return data['text'] as String;
      }
      if (data['message'] is String) {
        return data['message'] as String;
      }
      if (data['choices'] is List) {
        final choices = data['choices'] as List;
        if (choices.isNotEmpty) {
          final first = choices.first;
          if (first is Map<String, dynamic>) {
            final message = first['message'];
            if (message is Map<String, dynamic> &&
                message['content'] is String) {
              return message['content'] as String;
            }
            if (first['text'] is String) {
              return first['text'] as String;
            }
          }
        }
      }
    }
    throw Exception('Unsupported AI response format');
  }
}
