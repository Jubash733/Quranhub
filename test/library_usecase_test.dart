import 'package:flutter_test/flutter_test.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_download_update.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';
import 'package:library_domain/domain/usecases/get_library_catalog_usecase.dart';

class FakeLibraryRepository implements LibraryRepository {
  @override
  Stream<LibraryDownloadUpdate> get downloadUpdates => const Stream.empty();

  @override
  Future<void> cancelDownload(String itemId) async {}

  @override
  Future<void> deleteItem(String itemId) async {}

  @override
  Future<List<LibraryItemEntity>> getCatalog({
    LibraryCategory? category,
    String? query,
  }) async {
    return [
      LibraryItemEntity(
        itemId: 'translation_en_pickthall',
        title: 'Translation',
        author: 'Pickthall',
        description: 'Test',
        category: LibraryCategory.translation,
        sizeBytes: 0,
        source: 'Tanzil',
        downloadUrl: null,
        status: LibraryDownloadStatus.completed,
        downloadedBytes: 0,
        totalBytes: 0,
        localPath: null,
        updatedAt: DateTime.now(),
        isBundled: true,
      ),
    ];
  }

  @override
  Future<List<LibraryItemEntity>> getInstalledItems() async => [];

  @override
  Future<int> getUsedSpaceBytes() async => 0;

  @override
  Future<void> pauseDownload(String itemId) async {}

  @override
  Future<void> refreshCatalog() async {}

  @override
  Future<void> resumeDownload(String itemId) async {}

  @override
  Future<void> startDownload(String itemId) async {}
}

void main() {
  test('GetLibraryCatalogUsecase returns items', () async {
    final usecase = GetLibraryCatalogUsecase(repository: FakeLibraryRepository());
    final items = await usecase();
    expect(items, isNotEmpty);
    expect(items.first.itemId, 'translation_en_pickthall');
  });
}
