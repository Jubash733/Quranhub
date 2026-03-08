import 'package:quran/domain/repositories/search_repository.dart';

class BuildSearchIndexUsecase {
  const BuildSearchIndexUsecase({required this.repository});

  final SearchRepository repository;

  Stream<double> call() {
    return repository.buildIndex();
  }
}
