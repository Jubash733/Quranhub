import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TafsirLocalDataSource {
  final QuranAssetDataSource assetDataSource;

  TafsirLocalDataSource({required this.assetDataSource});

  Future<String?> getAyahTafsir(AyahRef ref, String languageCode) async {
    final entry = await assetDataSource.getAyah(ref);
    if (entry == null) {
      return null;
    }
    return entry.tafsirFor(languageCode);
  }
}
