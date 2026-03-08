import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/models/detail_surah_dto.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/data/models/surah_dto.dart';
import 'package:quran/data/repositories/search_repository_impl.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

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
    return null;
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String languageCode) async {
    return null;
  }

  @override
  Future<List<SurahDTO>> getSurahList() async => [];

  @override
  Future<DetailSurahDTO?> getDetailSurah(int id) async => null;
}

void main() {
  test('search finds arabic verses', () async {
    final repository = SearchRepositoryImpl(
      assetDataSource: FakeQuranAssetDataSource([
        LocalAyahData(
          surah: 1,
          ayah: 2,
          surahNameAr: '???????',
          surahNameEn: 'Al-Fatihah',
          textArabic: '????? ??? ?? ????????',
          translation: const {},
          tafsir: const {},
        ),
      ]),
    );

    final result = await repository.search('?????', languageCode: 'ar');
    result.fold(
      (failure) => fail('Expected Right, got Left: ${failure.message}'),
      (data) => expect(data.length, 1),
    );
  });
}
