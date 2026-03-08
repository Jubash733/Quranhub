import 'dart:io';

import 'package:dependencies/path/path.dart' as p;
import 'package:library_domain/data/datasources/library_catalog_data_source.dart';
import 'package:library_domain/data/datasources/library_local_data_source.dart';
import 'package:library_domain/data/models/library_catalog_item.dart';
import 'package:library_domain/data/models/library_item_model.dart';
import 'package:library_domain/data/services/library_download_service.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_download_update.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl({
    required this.localDataSource,
    required this.catalogDataSource,
    required this.downloadService,
  }) {
    downloadService.init();
    _bindDownloadUpdates();
  }

  final LibraryLocalDataSource localDataSource;
  final LibraryCatalogDataSource catalogDataSource;
  final LibraryDownloadService downloadService;

  bool _catalogLoaded = false;

  @override
  Stream<LibraryDownloadUpdate> get downloadUpdates => downloadService.updates;

  @override
  Future<void> refreshCatalog() async {
    final catalog = await catalogDataSource.loadCatalog();
    await _syncCatalog(catalog);
    _catalogLoaded = true;
  }

  @override
  Future<List<LibraryItemEntity>> getCatalog({
    LibraryCategory? category,
    String? query,
  }) async {
    if (!_catalogLoaded) {
      await refreshCatalog();
    }
    final items = await localDataSource.getItems(
      category: category,
      query: query,
    );
    return items.map((item) => item.toEntity()).toList();
  }

  @override
  Future<List<LibraryItemEntity>> getInstalledItems() async {
    final items = await localDataSource.getInstalledItems();
    return items.map((item) => item.toEntity()).toList();
  }

  @override
  Future<int> getUsedSpaceBytes() => localDataSource.getUsedSpaceBytes();

  @override
  Future<void> startDownload(String itemId) async {
    final item = await localDataSource.getByItemId(itemId);
    if (item == null) return;
    if (item.isBundled) return;
    final url = item.downloadUrl;
    if (url == null || url.isEmpty) return;

    final ext = p.extension(url);
    final filename = ext.isNotEmpty ? '$itemId$ext' : '$itemId.zip';
    final directory = p.join('library_packs', item.categoryKey, itemId);
    final taskId = await downloadService.enqueueDownload(
      itemId: itemId,
      url: url,
      filename: filename,
      directory: directory,
    );
    if (taskId != null) {
      item.downloadTaskId = taskId;
      item.statusKey = LibraryDownloadStatus.queued.key;
      item.updatedAt = DateTime.now();
      item.totalBytes = item.sizeBytes;
      item.localPath = await downloadService.resolveLocalPath(
        directory: directory,
        filename: filename,
      );
      await localDataSource.updateItem(item);
    }
  }

  @override
  Future<void> pauseDownload(String itemId) async {
    final item = await localDataSource.getByItemId(itemId);
    if (item?.downloadTaskId == null) return;
    await downloadService.pause(item!.downloadTaskId!);
    item.statusKey = LibraryDownloadStatus.paused.key;
    item.updatedAt = DateTime.now();
    await localDataSource.updateItem(item);
  }

  @override
  Future<void> resumeDownload(String itemId) async {
    final item = await localDataSource.getByItemId(itemId);
    if (item?.downloadTaskId == null) return;
    await downloadService.resume(item!.downloadTaskId!);
    item.statusKey = LibraryDownloadStatus.downloading.key;
    item.updatedAt = DateTime.now();
    await localDataSource.updateItem(item);
  }

  @override
  Future<void> cancelDownload(String itemId) async {
    final item = await localDataSource.getByItemId(itemId);
    if (item?.downloadTaskId == null) return;
    await downloadService.cancel(item!.downloadTaskId!);
    item.statusKey = LibraryDownloadStatus.failed.key;
    item.updatedAt = DateTime.now();
    await localDataSource.updateItem(item);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    final item = await localDataSource.getByItemId(itemId);
    if (item == null) return;
    if (item.localPath != null) {
      final file = File(item.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    item.statusKey = LibraryDownloadStatus.notDownloaded.key;
    item.downloadedBytes = 0;
    item.totalBytes = 0;
    item.localPath = null;
    item.downloadTaskId = null;
    item.updatedAt = DateTime.now();
    await localDataSource.updateItem(item);
  }

  void _bindDownloadUpdates() {
    downloadService.updates.listen((update) async {
      final item = await localDataSource.getByItemId(update.itemId);
      if (item == null) return;
      item.statusKey = update.status.key;
      if (update.totalBytes > 0) {
        item.totalBytes = update.totalBytes;
      }
      if (update.downloadedBytes > 0) {
        item.downloadedBytes = update.downloadedBytes;
      }
      if (update.status == LibraryDownloadStatus.completed) {
        item.downloadedBytes = item.totalBytes;
      }
      item.updatedAt = DateTime.now();
      await localDataSource.updateItem(item);
    });
  }

  Future<void> _syncCatalog(List<LibraryCatalogItem> catalog) async {
    final existing = await localDataSource.getItems();
    final existingMap = {
      for (final item in existing) item.itemId: item,
    };

    final updatedItems = <LibraryItemModel>[];
    for (final entry in catalog) {
      final model = existingMap[entry.itemId] ?? LibraryItemModel();
      model.itemId = entry.itemId;
      model.title = entry.title;
      model.author = entry.author;
      model.description = entry.description;
      model.categoryKey = entry.category.key;
      model.sizeBytes = entry.sizeBytes;
      model.source = entry.source;
      model.downloadUrl = entry.downloadUrl;
      model.isBundled = entry.isBundled;
      if (entry.isBundled) {
        model.statusKey = LibraryDownloadStatus.completed.key;
      }
      updatedItems.add(model);
    }

    await localDataSource.upsertItems(updatedItems);
  }
}
