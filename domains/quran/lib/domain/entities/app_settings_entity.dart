class AppSettingsEntity {
  const AppSettingsEntity({
    required this.translationEdition,
    required this.translationLanguage,
    required this.tafsirEdition,
    required this.tafsirLanguage,
    required this.audioEdition,
    required this.updatedAt,
  });

  final String translationEdition;
  final String translationLanguage;
  final String tafsirEdition;
  final String tafsirLanguage;
  final String audioEdition;
  final DateTime updatedAt;
}
