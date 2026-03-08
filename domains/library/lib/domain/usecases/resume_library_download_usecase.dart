import 'package:library_domain/domain/repositories/library_repository.dart';

class ResumeLibraryDownloadUsecase {
  ResumeLibraryDownloadUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call(String itemId) => repository.resumeDownload(itemId);
}
