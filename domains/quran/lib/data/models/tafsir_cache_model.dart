import 'package:dependencies/isar/isar.dart';

part 'tafsir_cache_model.g.dart';

@collection
class TafsirCacheModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late int surah;
  late int ayah;
  late String languageCode;
  late String edition;
  late String text;
  late DateTime updatedAt;
}
