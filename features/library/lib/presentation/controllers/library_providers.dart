import 'package:dependencies/get_it/get_it.dart';
import 'package:dependencies/hooks_riverpod/hooks_riverpod.dart';
import 'package:library_feature/presentation/controllers/library_controller.dart';
import 'package:library_feature/presentation/states/library_state.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';
import 'package:library_domain/domain/usecases/cancel_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/delete_library_item_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_used_space_usecase.dart';
import 'package:library_domain/domain/usecases/pause_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/refresh_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/resume_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/start_library_download_usecase.dart';

final libraryControllerProvider =
    StateNotifierProvider<LibraryController, LibraryState>((ref) {
  return LibraryController(
    repository: sl<LibraryRepository>(),
    getCatalogUsecase: sl<GetLibraryCatalogUsecase>(),
    refreshCatalogUsecase: sl<RefreshLibraryCatalogUsecase>(),
    getUsedSpaceUsecase: sl<GetLibraryUsedSpaceUsecase>(),
    startDownloadUsecase: sl<StartLibraryDownloadUsecase>(),
    pauseDownloadUsecase: sl<PauseLibraryDownloadUsecase>(),
    resumeDownloadUsecase: sl<ResumeLibraryDownloadUsecase>(),
    cancelDownloadUsecase: sl<CancelLibraryDownloadUsecase>(),
    deleteItemUsecase: sl<DeleteLibraryItemUsecase>(),
  );
});

