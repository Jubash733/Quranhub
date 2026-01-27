import 'package:library_domain/domain/repositories/library_repository.dart';

class GetLibraryUsedSpaceUsecase {
  GetLibraryUsedSpaceUsecase({required this.repository});

  final LibraryRepository repository;

  Future<int> call() => repository.getUsedSpaceBytes();
}
