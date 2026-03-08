import 'package:library_domain/domain/entities/library_item_entity.dart';
import 'package:library_domain/domain/repositories/library_repository.dart';

class GetInstalledLibraryItemsUsecase {
  GetInstalledLibraryItemsUsecase({required this.repository});

  final LibraryRepository repository;

  Future<List<LibraryItemEntity>> call() => repository.getInstalledItems();
}
