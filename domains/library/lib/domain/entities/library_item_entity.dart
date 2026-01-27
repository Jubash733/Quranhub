import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';

class LibraryItemEntity {
  const LibraryItemEntity({
    required this.itemId,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.sizeBytes,
    required this.source,
    required this.downloadUrl,
    required this.status,
    required this.downloadedBytes,
    required this.totalBytes,
    required this.localPath,
    required this.updatedAt,
    required this.isBundled,
  });

  final String itemId;
  final String title;
  final String author;
  final String description;
  final LibraryCategory category;
  final int sizeBytes;
  final String source;
  final String? downloadUrl;
  final LibraryDownloadStatus status;
  final int downloadedBytes;
  final int totalBytes;
  final String? localPath;
  final DateTime updatedAt;
  final bool isBundled;

  bool get isInstalled => status == LibraryDownloadStatus.completed || isBundled;
}
