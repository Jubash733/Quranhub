import 'package:dependencies/dio/dio.dart';
import 'package:quran/data/models/detail_surah_dto.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:resources/constant/api_constant.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationDTO> getAyahTranslation(AyahRef ref);
}

class TranslationRemoteDataSourceImpl extends TranslationRemoteDataSource {
  final Dio dio;

  TranslationRemoteDataSourceImpl({required this.dio});

  @override
  Future<TranslationDTO> getAyahTranslation(AyahRef ref) async {
    try {
      final response = await dio.get('${ApiConstant.baseUrl}surah/${ref.surah}');
      final detail = DetailSurahResponseDTO.fromJson(response.data).data;
      final verse =
          detail.verses.firstWhere((item) => item.number.inSurah == ref.ayah);
      return verse.translation;
    } catch (e) {
      rethrow;
    }
  }
}
