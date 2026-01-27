import 'package:dependencies/isar/isar.dart';
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:quran/data/models/app_settings_model.dart';
import 'package:quran/data/models/tafsir_cache_model.dart';

class QuranCacheIsarService {
  static final QuranCacheIsarService _instance = QuranCacheIsarService._();

  QuranCacheIsarService._();

  factory QuranCacheIsarService() => _instance;

  Isar? _isar;

  Future<Isar> get instance async {
    if (_isar != null) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TafsirCacheModelSchema, AppSettingsModelSchema],
      directory: dir.path,
      name: 'quran_cache',
    );
    return _isar!;
  }
}
