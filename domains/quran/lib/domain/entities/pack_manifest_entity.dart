class PackManifestEntity {
  const PackManifestEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.language,
    required this.version,
    required this.size,
    required this.localPath,
    this.remoteUrl,
    this.format,
    this.variant,
    this.sourceUrl,
  });

  final String id;
  final String name;
  final String type;
  final String language;
  final String version;
  final int size;
  final String localPath;
  final String? remoteUrl;
  final String? format;
  final String? variant;
  final String? sourceUrl;
}
