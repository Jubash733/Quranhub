import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';

part 'library_state.freezed.dart';

@freezed
class LibraryState with _$LibraryState {
  const factory LibraryState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    @Default([]) List<LibraryItemEntity> items,
    @Default('') String query,
    @Default(LibraryCategory.translation) LibraryCategory category,
    String? errorMessage,
    @Default(0) int usedSpaceBytes,
    @Default({}) Map<String, Duration> timeRemaining,
    @Default({}) Map<String, double> downloadSpeed,
  }) = _LibraryState;
}

