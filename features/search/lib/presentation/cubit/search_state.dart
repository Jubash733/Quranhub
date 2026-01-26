part of 'search_cubit.dart';

class SearchState extends Equatable {
  final ViewData<List<SearchResultEntity>> status;
  final String query;

  const SearchState({required this.status, required this.query});

  SearchState copyWith({
    ViewData<List<SearchResultEntity>>? status,
    String? query,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [status, query];
}
