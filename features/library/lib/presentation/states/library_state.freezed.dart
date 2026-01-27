// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LibraryState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  List<LibraryItemEntity> get items => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  LibraryCategory get category => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int get usedSpaceBytes => throw _privateConstructorUsedError;
  Map<String, Duration> get timeRemaining => throw _privateConstructorUsedError;
  Map<String, double> get downloadSpeed => throw _privateConstructorUsedError;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LibraryStateCopyWith<LibraryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryStateCopyWith<$Res> {
  factory $LibraryStateCopyWith(
          LibraryState value, $Res Function(LibraryState) then) =
      _$LibraryStateCopyWithImpl<$Res, LibraryState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      List<LibraryItemEntity> items,
      String query,
      LibraryCategory category,
      String? errorMessage,
      int usedSpaceBytes,
      Map<String, Duration> timeRemaining,
      Map<String, double> downloadSpeed});
}

/// @nodoc
class _$LibraryStateCopyWithImpl<$Res, $Val extends LibraryState>
    implements $LibraryStateCopyWith<$Res> {
  _$LibraryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? items = null,
    Object? query = null,
    Object? category = null,
    Object? errorMessage = freezed,
    Object? usedSpaceBytes = null,
    Object? timeRemaining = null,
    Object? downloadSpeed = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LibraryItemEntity>,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LibraryCategory,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      usedSpaceBytes: null == usedSpaceBytes
          ? _value.usedSpaceBytes
          : usedSpaceBytes // ignore: cast_nullable_to_non_nullable
              as int,
      timeRemaining: null == timeRemaining
          ? _value.timeRemaining
          : timeRemaining // ignore: cast_nullable_to_non_nullable
              as Map<String, Duration>,
      downloadSpeed: null == downloadSpeed
          ? _value.downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LibraryStateImplCopyWith<$Res>
    implements $LibraryStateCopyWith<$Res> {
  factory _$$LibraryStateImplCopyWith(
          _$LibraryStateImpl value, $Res Function(_$LibraryStateImpl) then) =
      __$$LibraryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      List<LibraryItemEntity> items,
      String query,
      LibraryCategory category,
      String? errorMessage,
      int usedSpaceBytes,
      Map<String, Duration> timeRemaining,
      Map<String, double> downloadSpeed});
}

/// @nodoc
class __$$LibraryStateImplCopyWithImpl<$Res>
    extends _$LibraryStateCopyWithImpl<$Res, _$LibraryStateImpl>
    implements _$$LibraryStateImplCopyWith<$Res> {
  __$$LibraryStateImplCopyWithImpl(
      _$LibraryStateImpl _value, $Res Function(_$LibraryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? items = null,
    Object? query = null,
    Object? category = null,
    Object? errorMessage = freezed,
    Object? usedSpaceBytes = null,
    Object? timeRemaining = null,
    Object? downloadSpeed = null,
  }) {
    return _then(_$LibraryStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LibraryItemEntity>,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LibraryCategory,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      usedSpaceBytes: null == usedSpaceBytes
          ? _value.usedSpaceBytes
          : usedSpaceBytes // ignore: cast_nullable_to_non_nullable
              as int,
      timeRemaining: null == timeRemaining
          ? _value._timeRemaining
          : timeRemaining // ignore: cast_nullable_to_non_nullable
              as Map<String, Duration>,
      downloadSpeed: null == downloadSpeed
          ? _value._downloadSpeed
          : downloadSpeed // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc

class _$LibraryStateImpl implements _LibraryState {
  const _$LibraryStateImpl(
      {this.isLoading = false,
      this.isRefreshing = false,
      final List<LibraryItemEntity> items = const [],
      this.query = '',
      this.category = LibraryCategory.translation,
      this.errorMessage,
      this.usedSpaceBytes = 0,
      final Map<String, Duration> timeRemaining = const {},
      final Map<String, double> downloadSpeed = const {}})
      : _items = items,
        _timeRemaining = timeRemaining,
        _downloadSpeed = downloadSpeed;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  final List<LibraryItemEntity> _items;
  @override
  @JsonKey()
  List<LibraryItemEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String query;
  @override
  @JsonKey()
  final LibraryCategory category;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final int usedSpaceBytes;
  final Map<String, Duration> _timeRemaining;
  @override
  @JsonKey()
  Map<String, Duration> get timeRemaining {
    if (_timeRemaining is EqualUnmodifiableMapView) return _timeRemaining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeRemaining);
  }

  final Map<String, double> _downloadSpeed;
  @override
  @JsonKey()
  Map<String, double> get downloadSpeed {
    if (_downloadSpeed is EqualUnmodifiableMapView) return _downloadSpeed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_downloadSpeed);
  }

  @override
  String toString() {
    return 'LibraryState(isLoading: $isLoading, isRefreshing: $isRefreshing, items: $items, query: $query, category: $category, errorMessage: $errorMessage, usedSpaceBytes: $usedSpaceBytes, timeRemaining: $timeRemaining, downloadSpeed: $downloadSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.usedSpaceBytes, usedSpaceBytes) ||
                other.usedSpaceBytes == usedSpaceBytes) &&
            const DeepCollectionEquality()
                .equals(other._timeRemaining, _timeRemaining) &&
            const DeepCollectionEquality()
                .equals(other._downloadSpeed, _downloadSpeed));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isRefreshing,
      const DeepCollectionEquality().hash(_items),
      query,
      category,
      errorMessage,
      usedSpaceBytes,
      const DeepCollectionEquality().hash(_timeRemaining),
      const DeepCollectionEquality().hash(_downloadSpeed));

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryStateImplCopyWith<_$LibraryStateImpl> get copyWith =>
      __$$LibraryStateImplCopyWithImpl<_$LibraryStateImpl>(this, _$identity);
}

abstract class _LibraryState implements LibraryState {
  const factory _LibraryState(
      {final bool isLoading,
      final bool isRefreshing,
      final List<LibraryItemEntity> items,
      final String query,
      final LibraryCategory category,
      final String? errorMessage,
      final int usedSpaceBytes,
      final Map<String, Duration> timeRemaining,
      final Map<String, double> downloadSpeed}) = _$LibraryStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  List<LibraryItemEntity> get items;
  @override
  String get query;
  @override
  LibraryCategory get category;
  @override
  String? get errorMessage;
  @override
  int get usedSpaceBytes;
  @override
  Map<String, Duration> get timeRemaining;
  @override
  Map<String, double> get downloadSpeed;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryStateImplCopyWith<_$LibraryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
