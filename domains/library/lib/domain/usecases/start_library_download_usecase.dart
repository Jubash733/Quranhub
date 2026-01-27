import 'package:library_domain/domain/repositories/library_repository.dart';

class StartLibraryDownloadUsecase {
  StartLibraryDownloadUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call(String itemId) => repository.startDownload(itemId);
}
