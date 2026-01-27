import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_update.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';

abstract class LibraryRepository {
  Stream<LibraryDownloadUpdate> get downloadUpdates;

  Future<List<LibraryItemEntity>> getCatalog({
    LibraryCategory? category,
    String? query,
  });

  Future<List<LibraryItemEntity>> getInstalledItems();

  Future<int> getUsedSpaceBytes();

  Future<void> refreshCatalog();

  Future<void> startDownload(String itemId);

  Future<void> pauseDownload(String itemId);

  Future<void> resumeDownload(String itemId);

  Future<void> cancelDownload(String itemId);

  Future<void> deleteItem(String itemId);
}
