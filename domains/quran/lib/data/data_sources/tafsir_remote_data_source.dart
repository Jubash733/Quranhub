import 'dart:convert';

import 'package:dependencies/dio/dio.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/constant/api_constant.dart';

abstract class TafsirRemoteDataSource {
  Future<String> getAyahTafsir(
    AyahRef ref, {
    required String edition,
  });
}

class TafsirRemoteDataSourceImpl extends TafsirRemoteDataSource {
  TafsirRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> getAyahTafsir(
    AyahRef ref, {
    required String edition,
  }) async {
    final response = await dio.get(
      '${ApiConstant.alquranBaseUrl}/ayah/${ref.surah}:${ref.ayah}/$edition',
    );
    final payload =
        response.data is String ? jsonDecode(response.data) : response.data;
    final data = payload['data'] as Map<String, dynamic>? ?? {};
    return data['text'] as String? ?? '';
  }
}
