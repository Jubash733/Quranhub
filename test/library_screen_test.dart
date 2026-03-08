import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_feature/presentation/controllers/library_controller.dart';
import 'package:library_feature/presentation/controllers/library_providers.dart';
import 'package:library_feature/presentation/ui/library_screen.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_download_update.dart';
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
import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';

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
  testWidgets('LibraryScreen shows items', (tester) async {
    final repo = FakeLibraryRepository();
    final controller = LibraryController(
      repository: repo,
      getCatalogUsecase: GetLibraryCatalogUsecase(repository: repo),
      refreshCatalogUsecase: RefreshLibraryCatalogUsecase(repository: repo),
      getUsedSpaceUsecase: GetLibraryUsedSpaceUsecase(repository: repo),
      startDownloadUsecase: StartLibraryDownloadUsecase(repository: repo),
      pauseDownloadUsecase: PauseLibraryDownloadUsecase(repository: repo),
      resumeDownloadUsecase: ResumeLibraryDownloadUsecase(repository: repo),
      cancelDownloadUsecase: CancelLibraryDownloadUsecase(repository: repo),
      deleteItemUsecase: DeleteLibraryItemUsecase(repository: repo),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryControllerProvider.overrideWith((ref) => controller),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Translation'), findsOneWidget);
  });
}
