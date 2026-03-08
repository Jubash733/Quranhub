import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import '../local/quran_local_database.dart';
import '../../core/error/api_result.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl}) : _dio = Dio() {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    // Logging interceptor
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    // Cache & Retry interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Simple GET cache check
        if (options.method == 'GET') {
          final box = Hive.box(QuranLocalDatabase.settingsBox);
          final cacheKey = 'api_cache_${options.uri.toString()}';
          final cachedObj = box.get(cacheKey);

          if (cachedObj != null) {
            try {
              final data = jsonDecode(cachedObj);
              final timestamp = data['timestamp'];
              if (timestamp != null) {
                final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                final age = DateTime.now().difference(cachedTime);
                if (age.inHours < 24) { // 24 hours expiry
                  final cachedResponse = Response(
                    requestOptions: options,
                    data: data['payload'],
                    statusCode: 200,
                  );
                  return handler.resolve(cachedResponse);
                }
              }
            } catch (_) {
              // Ignore cache error and proceed to network
            }
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
          final box = Hive.box(QuranLocalDatabase.settingsBox);
          final cacheKey = 'api_cache_${response.requestOptions.uri.toString()}';
          final cacheData = jsonEncode({
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'payload': response.data,
          });
          box.put(cacheKey, cacheData);
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (_shouldRetry(e)) {
          try {
            // Basic retry logic (1 retry)
            await Future.delayed(const Duration(seconds: 2));
            final response = await _dio.fetch(e.requestOptions);
            return handler.resolve(response);
          } catch (_) {
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
  }

  Future<ApiResult<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Success(result);
    } on Exception catch (e) {
      return Failure.fromException(e);
    }
  }
}
