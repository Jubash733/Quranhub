import 'package:dependencies/isar/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  Id id = 1;

  late String translationEdition;
  late String translationLanguage;
  late String tafsirEdition;
  late String tafsirLanguage;
  late String audioEdition;
  late DateTime updatedAt;
}
