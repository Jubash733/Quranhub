import 'dart:async';
import 'dart:io';

import 'package:dependencies/background_downloader/background_downloader.dart';
import 'package:dependencies/path/path.dart' as p;
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_download_update.dart';

class LibraryDownloadService {
  final StreamController<LibraryDownloadUpdate> _controller =
      StreamController.broadcast();
  final Map<String, DownloadTask> _tasksById = {};

  Stream<LibraryDownloadUpdate> get updates => _controller.stream;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    FileDownloader().updates.listen(_handleUpdate);
  }

  Future<String?> enqueueDownload({
    required String itemId,
    required String url,
    required String filename,
    required String directory,
  }) async {
    await init();
    final task = DownloadTask(
      url: url,
      filename: filename,
      directory: directory,
      baseDirectory: BaseDirectory.applicationSupport,
      updates: Updates.statusAndProgress,
      metaData: itemId,
      allowPause: true,
    );
    final success = await FileDownloader().enqueue(task);
    if (success) {
      _tasksById[task.taskId] = task;
      return task.taskId;
    }
    return null;
  }

  Future<void> pause(String taskId) async {
    final task = await _resolveTask(taskId);
    if (task != null) {
      await FileDownloader().pause(task);
    }
  }

  Future<void> resume(String taskId) async {
    final task = await _resolveTask(taskId);
    if (task != null) {
      await FileDownloader().resume(task);
    }
  }

  Future<void> cancel(String taskId) async {
    await FileDownloader().cancelTaskWithId(taskId);
    _tasksById.remove(taskId);
  }

  Future<String> resolveLocalPath({
    required String directory,
    required String filename,
  }) async {
    final baseDir = await getApplicationSupportDirectory();
    final targetDir = Directory(p.join(baseDir.path, directory));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    return p.join(targetDir.path, filename);
  }

  void _handleUpdate(TaskUpdate update) {
    final itemId = update.task.metaData;
    if (itemId.isEmpty) {
      return;
    }
    if (update is TaskProgressUpdate) {
      final totalBytes =
          update.hasExpectedFileSize ? update.expectedFileSize : 0;
      final downloadedBytes = totalBytes > 0 && update.progress >= 0
          ? (totalBytes * update.progress).round()
          : 0;
      final status = _mapProgressStatus(update.progress);
      _controller.add(
        LibraryDownloadUpdate(
          itemId: itemId,
          status: status,
          progress: update.progress,
          downloadedBytes: downloadedBytes,
          totalBytes: totalBytes,
          networkSpeed: update.hasNetworkSpeed ? update.networkSpeed : 0,
          timeRemaining:
              update.hasTimeRemaining ? update.timeRemaining : null,
        ),
      );
    } else if (update is TaskStatusUpdate) {
      _controller.add(
        LibraryDownloadUpdate(
          itemId: itemId,
          status: _mapStatus(update.status),
          progress: 0,
          downloadedBytes: 0,
          totalBytes: 0,
          networkSpeed: 0,
          timeRemaining: null,
        ),
      );
    }
  }

  Future<DownloadTask?> _resolveTask(String taskId) async {
    final cached = _tasksById[taskId];
    if (cached != null) {
      return cached;
    }
    final task = await FileDownloader().taskForId(taskId);
    if (task is DownloadTask) {
      _tasksById[taskId] = task;
      return task;
    }
    return null;
  }

  LibraryDownloadStatus _mapStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.enqueued:
      case TaskStatus.waitingToRetry:
        return LibraryDownloadStatus.queued;
      case TaskStatus.running:
        return LibraryDownloadStatus.downloading;
      case TaskStatus.paused:
        return LibraryDownloadStatus.paused;
      case TaskStatus.complete:
        return LibraryDownloadStatus.completed;
      case TaskStatus.failed:
      case TaskStatus.canceled:
      case TaskStatus.notFound:
        return LibraryDownloadStatus.failed;
    }
  }

  LibraryDownloadStatus _mapProgressStatus(double progress) {
    if (progress == progressFailed ||
        progress == progressNotFound ||
        progress == progressCanceled) {
      return LibraryDownloadStatus.failed;
    }
    if (progress == progressWaitingToRetry) {
      return LibraryDownloadStatus.queued;
    }
    return LibraryDownloadStatus.downloading;
  }
}
