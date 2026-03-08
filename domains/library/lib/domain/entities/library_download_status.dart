enum LibraryDownloadStatus {
  notDownloaded,
  downloading,
  paused,
  completed,
  failed,
  queued,
}

extension LibraryDownloadStatusX on LibraryDownloadStatus {
  String get key {
    switch (this) {
      case LibraryDownloadStatus.notDownloaded:
        return 'not_downloaded';
      case LibraryDownloadStatus.downloading:
        return 'downloading';
      case LibraryDownloadStatus.paused:
        return 'paused';
      case LibraryDownloadStatus.completed:
        return 'completed';
      case LibraryDownloadStatus.failed:
        return 'failed';
      case LibraryDownloadStatus.queued:
        return 'queued';
    }
  }
}

LibraryDownloadStatus libraryDownloadStatusFromKey(String? key) {
  for (final value in LibraryDownloadStatus.values) {
    if (value.key == key) return value;
  }
  return LibraryDownloadStatus.notDownloaded;
}
