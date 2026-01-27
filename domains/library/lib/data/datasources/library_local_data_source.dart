import 'package:dependencies/isar/isar.dart';
import 'package:library_domain/data/models/library_item_model.dart';
import 'package:library_domain/data/storage/library_isar_service.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';

class LibraryLocalDataSource {
  LibraryLocalDataSource({required this.isarService});

  final LibraryIsarService isarService;

  Future<void> upsertItems(List<LibraryItemModel> items) async {
    final isar = await isarService.instance;
    await isar.writeTxn(() async {
      await isar.libraryItemModels.putAll(items);
    });
  }

  Future<List<LibraryItemModel>> getItems({
    LibraryCategory? category,
    String? query,
  }) async {
    final isar = await isarService.instance;
    final hasQuery = query != null && query.trim().isNotEmpty;
    final builder = isar.libraryItemModels
        .filter()
        .optional(
          category != null,
          (q) => q.categoryKeyEqualTo(category!.key),
        )
        .optional(
          hasQuery,
          (q) {
            final qText = query!.trim().toLowerCase();
            return q
                .titleContains(qText, caseSensitive: false)
                .or()
                .authorContains(qText, caseSensitive: false);
          },
        );
    return builder.findAll();
  }

  Future<List<LibraryItemModel>> getInstalledItems() async {
    final isar = await isarService.instance;
    return isar.libraryItemModels
        .filter()
        .statusKeyEqualTo(LibraryDownloadStatus.completed.key)
        .or()
        .isBundledEqualTo(true)
        .findAll();
  }

  Future<LibraryItemModel?> getByItemId(String itemId) async {
    final isar = await isarService.instance;
    return isar.libraryItemModels.filter().itemIdEqualTo(itemId).findFirst();
  }

  Future<void> updateItem(LibraryItemModel item) async {
    final isar = await isarService.instance;
    await isar.writeTxn(() async {
      await isar.libraryItemModels.put(item);
    });
  }

  Future<void> deleteItem(String itemId) async {
    final isar = await isarService.instance;
    await isar.writeTxn(() async {
      final existing = await getByItemId(itemId);
      if (existing != null) {
        await isar.libraryItemModels.delete(existing.id);
      }
    });
  }

  Future<int> getUsedSpaceBytes() async {
    final isar = await isarService.instance;
    final items = await isar.libraryItemModels.where().findAll();
    var total = 0;
    for (final item in items) {
      if (item.statusKey == 'completed' || item.isBundled) {
        total += item.sizeBytes;
      }
    }
    return total;
  }
}
