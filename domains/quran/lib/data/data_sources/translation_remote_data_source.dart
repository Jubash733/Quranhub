import 'dart:convert';

import 'package:dependencies/dio/dio.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/constant/api_constant.dart';

abstract class TranslationRemoteDataSource {
  Future<AyahTranslationDTO> getAyahTranslation(
    AyahRef ref, {
    required String edition,
  });
}

class TranslationRemoteDataSourceImpl extends TranslationRemoteDataSource {
  final Dio dio;

  TranslationRemoteDataSourceImpl({required this.dio});

  @override
  Future<AyahTranslationDTO> getAyahTranslation(
    AyahRef ref, {
    required String edition,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConstant.alquranBaseUrl}/ayah/${ref.surah}:${ref.ayah}/$edition',
      );
      final payload =
          response.data is String ? jsonDecode(response.data) : response.data;
      final data = payload['data'] as Map<String, dynamic>? ?? {};
      final text = data['text'] as String? ?? '';
      return AyahTranslationDTO(
        surahNumber: ref.surah,
        ayahNumber: ref.ayah,
        translation: TranslationDTO(
          en: text,
          id: text,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
