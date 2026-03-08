import 'package:library_domain/domain/repositories/library_repository.dart';

class DeleteLibraryItemUsecase {
  DeleteLibraryItemUsecase({required this.repository});

  final LibraryRepository repository;

  Future<void> call(String itemId) => repository.deleteItem(itemId);
}
