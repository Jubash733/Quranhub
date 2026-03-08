import 'package:library_domain/domain/entities/library_download_status.dart';

class LibraryDownloadUpdate {
  const LibraryDownloadUpdate({
    required this.itemId,
    required this.status,
    required this.progress,
    required this.downloadedBytes,
    required this.totalBytes,
    required this.networkSpeed,
    required this.timeRemaining,
  });

  final String itemId;
  final LibraryDownloadStatus status;
  final double progress;
  final int downloadedBytes;
  final int totalBytes;
  final double networkSpeed;
  final Duration? timeRemaining;
}
