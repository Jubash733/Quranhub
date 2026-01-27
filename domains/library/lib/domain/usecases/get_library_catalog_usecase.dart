import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';

class GetLibraryCatalogUsecase {
  GetLibraryCatalogUsecase({required this.repository});

  final LibraryRepository repository;

  Future<List<LibraryItemEntity>> call({
    LibraryCategory? category,
    String? query,
  }) {
    return repository.getCatalog(category: category, query: query);
  }
}
