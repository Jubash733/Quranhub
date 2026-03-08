import 'dart:async';
import 'dart:developer';

import 'package:dependencies/dio/dio.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/constant/api_constant.dart';

abstract class AudioRemoteDataSource {
  Future<String> getAyahAudioUrl(AyahRef ref, String edition);
}

class AudioRemoteDataSourceImpl extends AudioRemoteDataSource {
  AudioRemoteDataSourceImpl({required this.dio});

  final Dio dio;
  static const Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0',
    'Accept': 'application/json',
  };
  static const Duration _timeout = Duration(seconds: 12);
  static const int _maxRetries = 2;

  @override
  Future<String> getAyahAudioUrl(AyahRef ref, String edition) async {
    final url =
        '${ApiConstant.alquranBaseUrl}/ayah/${ref.surah}:${ref.ayah}/$edition';
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        dio.options.connectTimeout = _timeout;
        final response = await dio.get(
          url,
          options: Options(
            headers: _headers,
            receiveTimeout: _timeout,
            sendTimeout: _timeout,
            followRedirects: true,
          ),
        );
        log(
          'GET $url -> ${response.statusCode}',
          name: 'AudioRemoteDataSource',
        );
        final audioUrl = _extractAudioUrl(response.data);
        log(
          'Audio URL for ${ref.surah}:${ref.ayah} ($edition) -> $audioUrl',
          name: 'AudioRemoteDataSource',
        );
        return audioUrl;
      } on DioException catch (e, st) {
        log(
          'GET $url failed (status: ${e.response?.statusCode})',
          name: 'AudioRemoteDataSource',
          error: e,
          stackTrace: st,
        );
        if (attempt >= _maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
      } catch (e, st) {
        log(
          'GET $url failed',
          name: 'AudioRemoteDataSource',
          error: e,
          stackTrace: st,
        );
        if (attempt >= _maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
      }
    }
    throw Exception('Audio URL not found');
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
