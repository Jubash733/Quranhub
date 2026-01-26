import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/data/models/local_ayah_data.dart';
import 'package:quran/data/repositories/search_repository_impl.dart';

class FakeQuranAssetDataSource implements QuranAssetDataSource {
  FakeQuranAssetDataSource(this.data);

  final List<LocalAyahData> data;

  @override
  Future<List<LocalAyahData>> getAllAyah() async => data;

  @override
  Future<LocalAyahData?> getAyah(ref) async => null;
}

void main() {
  test('search finds arabic verses', () async {
    final repository = SearchRepositoryImpl(
      assetDataSource: FakeQuranAssetDataSource([
        LocalAyahData(
          surah: 1,
          ayah: 2,
          surahNameAr: 'الفاتحة',
          surahNameEn: 'Al-Fatihah',
          textArabic: 'الحمد لله رب العالمين',
          translation: {'ar': 'الحمد لله رب العالمين', 'en': 'All praise'},
          tafsir: const {},
        ),
      ]),
    );

    final result = await repository.search('الحمد', languageCode: 'ar');
    result.fold(
      (failure) => fail('Expected Right, got Left: ${failure.message}'),
      (data) => expect(data.length, 1),
    );
  });
}
