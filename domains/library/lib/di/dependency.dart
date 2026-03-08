import 'package:dependencies/get_it/get_it.dart';
import 'package:library_domain/data/datasources/library_catalog_data_source.dart';
import 'package:library_domain/data/datasources/library_local_data_source.dart';
import 'package:library_domain/data/repositories/library_repository_impl.dart';
import 'package:library_domain/data/services/library_download_service.dart';
import 'package:library_domain/data/storage/library_isar_service.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';
import 'package:library_domain/domain/usecases/cancel_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/delete_library_item_usecase.dart';
import 'package:library_domain/domain/usecases/get_installed_library_items_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/get_library_used_space_usecase.dart';
import 'package:library_domain/domain/usecases/pause_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/refresh_library_catalog_usecase.dart';
import 'package:library_domain/domain/usecases/resume_library_download_usecase.dart';
import 'package:library_domain/domain/usecases/start_library_download_usecase.dart';

final sl = GetIt.instance;

class RegisterLibraryModule {
  RegisterLibraryModule() {
    _register();
  }

  void _register() {
    sl.registerLazySingleton<LibraryIsarService>(() => LibraryIsarService());
    sl.registerLazySingleton<LibraryCatalogDataSource>(
        () => LibraryCatalogDataSource());
    sl.registerLazySingleton<LibraryLocalDataSource>(
        () => LibraryLocalDataSource(isarService: sl()));
    sl.registerLazySingleton<LibraryDownloadService>(
        () => LibraryDownloadService());

    sl.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(
        localDataSource: sl(),
        catalogDataSource: sl(),
        downloadService: sl(),
      ),
    );

    sl.registerLazySingleton<GetLibraryCatalogUsecase>(
        () => GetLibraryCatalogUsecase(repository: sl()));
    sl.registerLazySingleton<RefreshLibraryCatalogUsecase>(
        () => RefreshLibraryCatalogUsecase(repository: sl()));
    sl.registerLazySingleton<GetInstalledLibraryItemsUsecase>(
        () => GetInstalledLibraryItemsUsecase(repository: sl()));
    sl.registerLazySingleton<GetLibraryUsedSpaceUsecase>(
        () => GetLibraryUsedSpaceUsecase(repository: sl()));
    sl.registerLazySingleton<StartLibraryDownloadUsecase>(
        () => StartLibraryDownloadUsecase(repository: sl()));
    sl.registerLazySingleton<PauseLibraryDownloadUsecase>(
        () => PauseLibraryDownloadUsecase(repository: sl()));
    sl.registerLazySingleton<ResumeLibraryDownloadUsecase>(
        () => ResumeLibraryDownloadUsecase(repository: sl()));
    sl.registerLazySingleton<CancelLibraryDownloadUsecase>(
        () => CancelLibraryDownloadUsecase(repository: sl()));
    sl.registerLazySingleton<DeleteLibraryItemUsecase>(
        () => DeleteLibraryItemUsecase(repository: sl()));
  }
}
