import 'dart:async';

import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/search_result_entity.dart';
import 'package:quran/domain/usecases/search_verses_usecase.dart';
import 'package:quran/domain/usecases/build_search_index_usecase.dart';
import 'package:quran/domain/usecases/is_search_index_ready_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchVersesUsecase searchVersesUsecase;
  final BuildSearchIndexUsecase buildSearchIndexUsecase;
  final IsSearchIndexReadyUsecase isSearchIndexReadyUsecase;
  Timer? _debounce;
  StreamSubscription<double>? _indexSubscription;
  String? _pendingQuery;

  SearchCubit({
    required this.searchVersesUsecase,
    required this.buildSearchIndexUsecase,
    required this.isSearchIndexReadyUsecase,
  }) : super(SearchState(
          status: ViewData.initial(),
          query: '',
          isIndexing: false,
          indexProgress: 0,
        ));

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

    final ready = await _ensureIndexReady(languageCode);
    if (!ready) {
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

  Future<bool> _ensureIndexReady(String languageCode) async {
    if (state.isIndexing) {
      _pendingQuery = state.query;
      return false;
    }
    final ready = await isSearchIndexReadyUsecase.call();
    if (ready) {
      return true;
    }
    emit(state.copyWith(isIndexing: true, indexProgress: 0));
    _indexSubscription?.cancel();
    _indexSubscription = buildSearchIndexUsecase.call().listen(
      (progress) {
        emit(state.copyWith(
          isIndexing: true,
          indexProgress: progress,
        ));
      },
      onError: (_) {
        emit(state.copyWith(isIndexing: false));
      },
      onDone: () {
        emit(state.copyWith(isIndexing: false, indexProgress: 1));
        final pending = _pendingQuery ?? state.query;
        _pendingQuery = null;
        if (pending.trim().isNotEmpty) {
          _runSearch(pending, languageCode);
        }
      },
    );
    return false;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _indexSubscription?.cancel();
    return super.close();
  }
}
