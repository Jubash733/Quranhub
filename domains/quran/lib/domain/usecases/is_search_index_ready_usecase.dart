import 'package:quran/domain/repositories/search_repository.dart';

class IsSearchIndexReadyUsecase {
  const IsSearchIndexReadyUsecase({required this.repository});

  final SearchRepository repository;

  Future<bool> call() {
    return repository.isIndexReady();
  }
}
