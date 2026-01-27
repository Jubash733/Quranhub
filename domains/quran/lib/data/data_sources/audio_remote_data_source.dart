import 'package:dependencies/dio/dio.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/constant/api_constant.dart';

abstract class AudioRemoteDataSource {
  Future<String> getAyahAudioUrl(AyahRef ref, String edition);
}

class AudioRemoteDataSourceImpl extends AudioRemoteDataSource {
  AudioRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> getAyahAudioUrl(AyahRef ref, String edition) async {
    final response = await dio.get(
      '${ApiConstant.alquranBaseUrl}/ayah/${ref.surah}:${ref.ayah}/$edition',
    );
    return _extractAudioUrl(response.data);
  }

  String _extractAudioUrl(dynamic data) {
    if (data is Map<String, dynamic>) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        final audio = payload['audio'];
        if (audio is String && audio.isNotEmpty) {
          return audio;
        }
        final audioSecondary = payload['audioSecondary'];
        if (audioSecondary is List && audioSecondary.isNotEmpty) {
          final first = audioSecondary.first;
          if (first is String && first.isNotEmpty) {
            return first;
          }
        }
      }
    }
    throw Exception('Audio URL not found');
  }
}
