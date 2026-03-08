import 'package:library_domain/domain/repositories/library_repository.dart';

class PauseLibraryDownloadUsecase {
  PauseLibraryDownloadUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call(String itemId) => repository.pauseDownload(itemId);
}
