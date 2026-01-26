import 'package:flutter_test/flutter_test.dart';
import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline lookup by AyahRef returns text + translation', () async {
    final dataSource = QuranAssetDataSourceImpl();
    const ref = AyahRef(surah: 1, ayah: 1);
    final ayah = await dataSource.getAyah(ref);
    expect(ayah, isNotNull);
    expect(ayah!.textArabic.isNotEmpty, true);

    final translation = await dataSource.getTranslation(ref, 'ar');
    expect(translation, isNotNull);
    expect(translation!.isNotEmpty, true);
  });
}
