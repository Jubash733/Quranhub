import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/search_result_entity.dart';
import 'package:quran/domain/repositories/search_repository.dart';

class SearchVersesUsecase {
  final SearchRepository repository;

  const SearchVersesUsecase({required this.repository});

  Future<Either<FailureResponse, List<SearchResultEntity>>> call(
    String query, {
    String languageCode = 'ar',
  }) {
    return repository.search(query, languageCode: languageCode);
  }
}
