import 'package:quran/data/data_sources/quran_asset_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TranslationLocalDataSource {
  final QuranAssetDataSource assetDataSource;

  TranslationLocalDataSource({required this.assetDataSource});

  Future<String?> getAyahTranslation(AyahRef ref, String languageCode) async {
    return assetDataSource.getTranslation(ref, languageCode);
  }
}
