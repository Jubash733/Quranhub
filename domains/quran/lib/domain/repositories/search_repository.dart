import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<FailureResponse, List<SearchResultEntity>>> search(
    String query, {
    String languageCode,
  });
}
