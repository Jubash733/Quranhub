import 'package:library_domain/domain/repositories/library_repository.dart';

class CancelLibraryDownloadUsecase {
  CancelLibraryDownloadUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call(String itemId) => repository.cancelDownload(itemId);
}
