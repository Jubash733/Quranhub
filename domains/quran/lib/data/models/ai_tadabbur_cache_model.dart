import 'package:dependencies/isar/isar.dart';

part 'ai_tadabbur_cache_model.g.dart';

@collection
class AiTadabburCacheModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late int surah;
  late int ayah;
  late String languageCode;
  late String promptType;
  late String promptVersion;
  late String response;
  late DateTime createdAt;
}
