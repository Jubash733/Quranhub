class AudioReciterEntity {
  const AudioReciterEntity({
    required this.identifier,
    required this.name,
    required this.englishName,
    required this.language,
    required this.format,
    required this.type,
    this.direction,
    this.allowDownload = false,
    this.downloadNote,
  });

  final String identifier;
  final String name;
  final String englishName;
  final String language;
  final String format;
  final String type;
  final String? direction;
  final bool allowDownload;
  final String? downloadNote;
}
