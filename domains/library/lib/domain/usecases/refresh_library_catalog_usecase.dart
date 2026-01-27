import 'package:library_domain/domain/repositories/library_repository.dart';

class RefreshLibraryCatalogUsecase {
  RefreshLibraryCatalogUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call() => repository.refreshCatalog();
}
