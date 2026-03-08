import 'dart:async';

import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';
import 'package:library_domain/domain/usecases/cancel_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/delete_library_item_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_used_space_usecase.dart';
import 'package:library_domain/domain/usecases/pause_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/refresh_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/resume_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/start_library_download_usecase.dart';
import 'package:library_feature/presentation/states/library_state.dart';

class LibraryController extends StateNotifier<LibraryState> {
  LibraryController({
    required this.repository,
    required this.getCatalogUsecase,
    required this.refreshCatalogUsecase,
    required this.getUsedSpaceUsecase,
    required this.startDownloadUsecase,
    required this.pauseDownloadUsecase,
    required this.resumeDownloadUsecase,
    required this.cancelDownloadUsecase,
    required this.deleteItemUsecase,
  }) : super(const LibraryState()) {
    _listenDownloads();
    load();
  }

  final LibraryRepository repository;
  final GetLibraryCatalogUsecase getCatalogUsecase;
  final RefreshLibraryCatalogUsecase refreshCatalogUsecase;
  final GetLibraryUsedSpaceUsecase getUsedSpaceUsecase;
  final StartLibraryDownloadUsecase startDownloadUsecase;
  final PauseLibraryDownloadUsecase pauseDownloadUsecase;
  final ResumeLibraryDownloadUsecase resumeDownloadUsecase;
  final CancelLibraryDownloadUsecase cancelDownloadUsecase;
  final DeleteLibraryItemUsecase deleteItemUsecase;

  StreamSubscription? _downloadSubscription;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await refreshCatalogUsecase();
      final items = await getCatalogUsecase(
        category: state.category,
        query: state.query,
      );
      final usedSpace = await getUsedSpaceUsecase();
      state = state.copyWith(
        isLoading: false,
        items: items,
        usedSpaceBytes: usedSpace,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    try {
      await refreshCatalogUsecase();
      final items = await getCatalogUsecase(
        category: state.category,
        query: state.query,
      );
      final usedSpace = await getUsedSpaceUsecase();
      state = state.copyWith(
        isRefreshing: false,
        items: items,
        usedSpaceBytes: usedSpace,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> setCategory(LibraryCategory category) async {
    state = state.copyWith(category: category);
    await load();
  }

  Future<void> setQuery(String query) async {
    state = state.copyWith(query: query);
    final items = await getCatalogUsecase(
      category: state.category,
      query: state.query,
    );
    state = state.copyWith(items: items);
  }

  Future<void> startDownload(LibraryItemEntity item) async {
    await startDownloadUsecase(item.itemId);
  }

  Future<void> pauseDownload(LibraryItemEntity item) async {
    await pauseDownloadUsecase(item.itemId);
  }

  Future<void> resumeDownload(LibraryItemEntity item) async {
    await resumeDownloadUsecase(item.itemId);
  }

  Future<void> cancelDownload(LibraryItemEntity item) async {
    await cancelDownloadUsecase(item.itemId);
  }

  Future<void> deleteItem(LibraryItemEntity item) async {
    await deleteItemUsecase(item.itemId);
    await load();
  }

  void _listenDownloads() {
    _downloadSubscription = repository.downloadUpdates.listen((update) async {
      final items = state.items;
      final index = items.indexWhere((item) => item.itemId == update.itemId);
      if (index == -1) return;
      final nextTimeRemaining =
          Map<String, Duration>.from(state.timeRemaining);
      final nextSpeeds = Map<String, double>.from(state.downloadSpeed);
      if (update.timeRemaining != null) {
        nextTimeRemaining[update.itemId] = update.timeRemaining!;
      } else {
        nextTimeRemaining.remove(update.itemId);
      }
      if (update.networkSpeed > 0) {
        nextSpeeds[update.itemId] = update.networkSpeed;
      } else {
        nextSpeeds.remove(update.itemId);
      }
      final updatedItem = items[index].copyWithStatus(
        status: update.status,
        downloadedBytes: update.downloadedBytes > 0
            ? update.downloadedBytes
            : items[index].downloadedBytes,
        totalBytes:
            update.totalBytes > 0 ? update.totalBytes : items[index].totalBytes,
      );
      final updatedItems = [...items];
      updatedItems[index] = updatedItem;
      var nextState = state.copyWith(
        items: updatedItems,
        timeRemaining: nextTimeRemaining,
        downloadSpeed: nextSpeeds,
      );
      if (update.status == LibraryDownloadStatus.completed) {
        nextTimeRemaining.remove(update.itemId);
        nextSpeeds.remove(update.itemId);
        final usedSpace = await getUsedSpaceUsecase();
        nextState = nextState.copyWith(usedSpaceBytes: usedSpace);
      }
      state = nextState;
    });
  }

  @override
  void dispose() {
    _downloadSubscription?.cancel();
    super.dispose();
  }
}

extension on LibraryItemEntity {
  LibraryItemEntity copyWithStatus({
    required LibraryDownloadStatus status,
    required int downloadedBytes,
    required int totalBytes,
  }) {
    return LibraryItemEntity(
      itemId: itemId,
      title: title,
      author: author,
      description: description,
      category: category,
      sizeBytes: sizeBytes,
      source: source,
      downloadUrl: downloadUrl,
      status: status,
      downloadedBytes: downloadedBytes,
      totalBytes: totalBytes,
      localPath: localPath,
      updatedAt: DateTime.now(),
      isBundled: isBundled,
    );
  }
}

