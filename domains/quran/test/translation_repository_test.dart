import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/data_sources/translation_local_data_source.dart';
import 'package:quran/data/data_sources/translation_remote_data_source.dart';
import 'package:quran/data/models/ayah_translation_dto.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/data/models/detail_surah_dto.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/data/repositories/translation_repository_impl.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class FakeTranslationRemoteDataSource implements TranslationRemoteDataSource {
  FakeTranslationRemoteDataSource(this.data);

  final Map<AyahRef, AyahTranslationDTO> data;

  @override
  Future<AyahTranslationDTO> getAyahTranslation(
    AyahRef ref, {
    String languageCode = 'ar',
  }) async {
    final result = data[ref];
    if (result == null) {
      throw Exception('Not found');
    }
    return result;
  }
}

class FakeQuranAssetDataSource implements QuranAssetDataSource {
  FakeQuranAssetDataSource(this.data);

  final List<LocalAyahData> data;

  @override
  Future<List<LocalAyahData>> getAllAyah() async => data;

  @override
  Future<LocalAyahData?> getAyah(AyahRef ref) async {
    try {
      return data.firstWhere(
          (item) => item.surah == ref.surah && item.ayah == ref.ayah);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String languageCode) async {
    final entry = await getAyah(ref);
    return entry?.translation[languageCode];
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String languageCode) async {
    final entry = await getAyah(ref);
    return entry?.tafsir[languageCode];
  }

  @override
  Future<List<SurahDTO>> getSurahList() async => [];

  @override
  Future<DetailSurahDTO?> getDetailSurah(int id) async => null;
}

void main() {
  test('returns translation for matching AyahRef', () async {
    const ref = AyahRef(surah: 1, ayah: 2);
    final assetDataSource = FakeQuranAssetDataSource([
      LocalAyahData(
        surah: 1,
        ayah: 2,
        surahNameAr: 'الفاتحة',
        surahNameEn: 'Al-Fatihah',
        textArabic: 'الحمد لله رب العالمين',
        translation: {'ar': 'الحمد لله رب العالمين'},
        tafsir: const {},
      ),
    ]);
    final dataSource = FakeTranslationRemoteDataSource({
      ref: AyahTranslationDTO(
        surahNumber: 1,
        ayahNumber: 2,
        translation: TranslationDTO(
          en: 'All praise is due to Allah',
          id: 'Segala puji',
        ),
      ),
    });
    final repository =
        TranslationRepositoryImpl(
          remoteDataSource: dataSource,
          localDataSource:
              TranslationLocalDataSource(assetDataSource: assetDataSource),
        );

    final result = await repository.getAyahTranslation(ref, languageCode: 'ar');

    result.fold(
      (failure) => fail('Expected Right, got Left: ${failure.message}'),
      (data) {
        expect(data.ref, ref);
        expect(data.text, 'الحمد لله رب العالمين');
        expect(data.languageCode, 'ar');
      },
    );
  });

  test('returns failure when data source throws', () async {
    const ref = AyahRef(surah: 1, ayah: 999);
    final repository = TranslationRepositoryImpl(
        remoteDataSource: FakeTranslationRemoteDataSource({}),
        localDataSource: TranslationLocalDataSource(
            assetDataSource: FakeQuranAssetDataSource(const [])));

    final result = await repository.getAyahTranslation(ref, languageCode: 'ar');

    result.fold(
      (failure) => expect(failure.message, contains('Exception')),
      (_) => fail('Expected Left'),
    );
  });

  test('returns failure when AyahRef mismatch occurs', () async {
    const ref = AyahRef(surah: 1, ayah: 1);
    final dataSource = FakeTranslationRemoteDataSource({
      ref: AyahTranslationDTO(
        surahNumber: 2,
        ayahNumber: 1,
        translation: TranslationDTO(en: 'en', id: 'id'),
      ),
    });
    final repository =
        TranslationRepositoryImpl(
          remoteDataSource: dataSource,
          localDataSource: TranslationLocalDataSource(
              assetDataSource: FakeQuranAssetDataSource(const [])),
        );

    final result = await repository.getAyahTranslation(ref, languageCode: 'en');

    result.fold(
      (failure) => expect(failure.message, contains('AyahRef mismatch')),
      (_) => fail('Expected Left'),
    );
  });
}
