import 'package:dependencies/isar/isar.dart';

part 'audio_cache_model.g.dart';

@collection
class AudioCacheModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late String url;
  late String edition;
  late int surah;
  late int ayah;
  late String filePath;
  late int sizeBytes;
  late DateTime updatedAt;
  late DateTime lastAccessAt;
}
