part of 'search_cubit.dart';

class SearchState extends Equatable {
  final ViewData<List<SearchResultEntity>> status;
  final String query;
  final bool isIndexing;
  final double indexProgress;

  const SearchState({
    required this.status,
    required this.query,
    required this.isIndexing,
    required this.indexProgress,
  });

  SearchState copyWith({
    ViewData<List<SearchResultEntity>>? status,
    String? query,
    bool? isIndexing,
    double? indexProgress,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      isIndexing: isIndexing ?? this.isIndexing,
      indexProgress: indexProgress ?? this.indexProgress,
    );
  }

  @override
  List<Object?> get props => [status, query, isIndexing, indexProgress];
}
