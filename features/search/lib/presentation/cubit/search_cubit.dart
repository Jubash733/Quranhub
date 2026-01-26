import 'dart:async';

import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/search_result_entity.dart';
import 'package:quran/domain/usecases/search_verses_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchVersesUsecase searchVersesUsecase;
  Timer? _debounce;

  SearchCubit({required this.searchVersesUsecase})
      : super(SearchState(status: ViewData.initial(), query: ''));

  void updateQuery(String query, String languageCode) {
    emit(state.copyWith(query: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(query, languageCode);
    });
  }

  Future<void> _runSearch(String query, String languageCode) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(status: ViewData.initial()));
      return;
    }

    emit(state.copyWith(status: ViewData.loading(message: '')));
    final result =
        await searchVersesUsecase.call(trimmed, languageCode: languageCode);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ViewData.error(message: failure.message))),
      (data) => emit(state.copyWith(status: ViewData.loaded(data: data))),
    );
  }

  void clear() {
    emit(state.copyWith(query: '', status: ViewData.initial()));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
