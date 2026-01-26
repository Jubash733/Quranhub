import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TafsirLocalDataSource {
  final QuranAssetDataSource assetDataSource;

  TafsirLocalDataSource({required this.assetDataSource});

  Future<String?> getAyahTafsir(AyahRef ref, String languageCode) async {
    return assetDataSource.getTafsir(ref, languageCode);
  }
}
