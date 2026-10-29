// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DurationFilter _$DurationFilterFromJson(Map<String, dynamic> json) {
  return _DurationFilter.fromJson(json);
}

/// @nodoc
mixin _$DurationFilter {
  Duration? get singleDuration => throw _privateConstructorUsedError;
  Duration? get minDuration => throw _privateConstructorUsedError;
  Duration? get maxDuration => throw _privateConstructorUsedError;
  DurationOperator get operator => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DurationFilterCopyWith<DurationFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DurationFilterCopyWith<$Res> {
  factory $DurationFilterCopyWith(
          DurationFilter value, $Res Function(DurationFilter) then) =
      _$DurationFilterCopyWithImpl<$Res, DurationFilter>;
  @useResult
  $Res call(
      {Duration? singleDuration,
      Duration? minDuration,
      Duration? maxDuration,
      DurationOperator operator});
}

/// @nodoc
class _$DurationFilterCopyWithImpl<$Res, $Val extends DurationFilter>
    implements $DurationFilterCopyWith<$Res> {
  _$DurationFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? singleDuration = freezed,
    Object? minDuration = freezed,
    Object? maxDuration = freezed,
    Object? operator = null,
  }) {
    return _then(_value.copyWith(
      singleDuration: freezed == singleDuration
          ? _value.singleDuration
          : singleDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      minDuration: freezed == minDuration
          ? _value.minDuration
          : minDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      maxDuration: freezed == maxDuration
          ? _value.maxDuration
          : maxDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as DurationOperator,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DurationFilterImplCopyWith<$Res>
    implements $DurationFilterCopyWith<$Res> {
  factory _$$DurationFilterImplCopyWith(_$DurationFilterImpl value,
          $Res Function(_$DurationFilterImpl) then) =
      __$$DurationFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Duration? singleDuration,
      Duration? minDuration,
      Duration? maxDuration,
      DurationOperator operator});
}

/// @nodoc
class __$$DurationFilterImplCopyWithImpl<$Res>
    extends _$DurationFilterCopyWithImpl<$Res, _$DurationFilterImpl>
    implements _$$DurationFilterImplCopyWith<$Res> {
  __$$DurationFilterImplCopyWithImpl(
      _$DurationFilterImpl _value, $Res Function(_$DurationFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? singleDuration = freezed,
    Object? minDuration = freezed,
    Object? maxDuration = freezed,
    Object? operator = null,
  }) {
    return _then(_$DurationFilterImpl(
      singleDuration: freezed == singleDuration
          ? _value.singleDuration
          : singleDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      minDuration: freezed == minDuration
          ? _value.minDuration
          : minDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      maxDuration: freezed == maxDuration
          ? _value.maxDuration
          : maxDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as DurationOperator,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DurationFilterImpl implements _DurationFilter {
  _$DurationFilterImpl(
      {this.singleDuration,
      this.minDuration,
      this.maxDuration,
      this.operator = DurationOperator.equalTo});

  factory _$DurationFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$DurationFilterImplFromJson(json);

  @override
  final Duration? singleDuration;
  @override
  final Duration? minDuration;
  @override
  final Duration? maxDuration;
  @override
  @JsonKey()
  final DurationOperator operator;

  @override
  String toString() {
    return 'DurationFilter(singleDuration: $singleDuration, minDuration: $minDuration, maxDuration: $maxDuration, operator: $operator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DurationFilterImpl &&
            (identical(other.singleDuration, singleDuration) ||
                other.singleDuration == singleDuration) &&
            (identical(other.minDuration, minDuration) ||
                other.minDuration == minDuration) &&
            (identical(other.maxDuration, maxDuration) ||
                other.maxDuration == maxDuration) &&
            (identical(other.operator, operator) ||
                other.operator == operator));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, singleDuration, minDuration, maxDuration, operator);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DurationFilterImplCopyWith<_$DurationFilterImpl> get copyWith =>
      __$$DurationFilterImplCopyWithImpl<_$DurationFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DurationFilterImplToJson(
      this,
    );
  }
}

abstract class _DurationFilter implements DurationFilter {
  factory _DurationFilter(
      {final Duration? singleDuration,
      final Duration? minDuration,
      final Duration? maxDuration,
      final DurationOperator operator}) = _$DurationFilterImpl;

  factory _DurationFilter.fromJson(Map<String, dynamic> json) =
      _$DurationFilterImpl.fromJson;

  @override
  Duration? get singleDuration;
  @override
  Duration? get minDuration;
  @override
  Duration? get maxDuration;
  @override
  DurationOperator get operator;
  @override
  @JsonKey(ignore: true)
  _$$DurationFilterImplCopyWith<_$DurationFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PathFilter _$PathFilterFromJson(Map<String, dynamic> json) {
  return _PathFilter.fromJson(json);
}

/// @nodoc
mixin _$PathFilter {
  String get path => throw _privateConstructorUsedError; // TODO: set to exclude
  bool get include => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PathFilterCopyWith<PathFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathFilterCopyWith<$Res> {
  factory $PathFilterCopyWith(
          PathFilter value, $Res Function(PathFilter) then) =
      _$PathFilterCopyWithImpl<$Res, PathFilter>;
  @useResult
  $Res call({String path, bool include, bool enabled});
}

/// @nodoc
class _$PathFilterCopyWithImpl<$Res, $Val extends PathFilter>
    implements $PathFilterCopyWith<$Res> {
  _$PathFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? include = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      include: null == include
          ? _value.include
          : include // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PathFilterImplCopyWith<$Res>
    implements $PathFilterCopyWith<$Res> {
  factory _$$PathFilterImplCopyWith(
          _$PathFilterImpl value, $Res Function(_$PathFilterImpl) then) =
      __$$PathFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, bool include, bool enabled});
}

/// @nodoc
class __$$PathFilterImplCopyWithImpl<$Res>
    extends _$PathFilterCopyWithImpl<$Res, _$PathFilterImpl>
    implements _$$PathFilterImplCopyWith<$Res> {
  __$$PathFilterImplCopyWithImpl(
      _$PathFilterImpl _value, $Res Function(_$PathFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? include = null,
    Object? enabled = null,
  }) {
    return _then(_$PathFilterImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      include: null == include
          ? _value.include
          : include // ignore: cast_nullable_to_non_nullable
              as bool,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PathFilterImpl implements _PathFilter {
  _$PathFilterImpl(
      {required this.path, this.include = false, this.enabled = true});

  factory _$PathFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PathFilterImplFromJson(json);

  @override
  final String path;
// TODO: set to exclude
  @override
  @JsonKey()
  final bool include;
  @override
  @JsonKey()
  final bool enabled;

  @override
  String toString() {
    return 'PathFilter(path: $path, include: $include, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathFilterImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.include, include) || other.include == include) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, include, enabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PathFilterImplCopyWith<_$PathFilterImpl> get copyWith =>
      __$$PathFilterImplCopyWithImpl<_$PathFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PathFilterImplToJson(
      this,
    );
  }
}

abstract class _PathFilter implements PathFilter {
  factory _PathFilter(
      {required final String path,
      final bool include,
      final bool enabled}) = _$PathFilterImpl;

  factory _PathFilter.fromJson(Map<String, dynamic> json) =
      _$PathFilterImpl.fromJson;

  @override
  String get path;
  @override // TODO: set to exclude
  bool get include;
  @override
  bool get enabled;
  @override
  @JsonKey(ignore: true)
  _$$PathFilterImplCopyWith<_$PathFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SizeFilter _$SizeFilterFromJson(Map<String, dynamic> json) {
  return _SizeFilter.fromJson(json);
}

/// @nodoc
mixin _$SizeFilter {
  int? get sizeBytes => throw _privateConstructorUsedError;
  int? get minSizeBytes => throw _privateConstructorUsedError;
  int? get maxSizeBytes => throw _privateConstructorUsedError;
  SizeOperator get operator => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SizeFilterCopyWith<SizeFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SizeFilterCopyWith<$Res> {
  factory $SizeFilterCopyWith(
          SizeFilter value, $Res Function(SizeFilter) then) =
      _$SizeFilterCopyWithImpl<$Res, SizeFilter>;
  @useResult
  $Res call(
      {int? sizeBytes,
      int? minSizeBytes,
      int? maxSizeBytes,
      SizeOperator operator});
}

/// @nodoc
class _$SizeFilterCopyWithImpl<$Res, $Val extends SizeFilter>
    implements $SizeFilterCopyWith<$Res> {
  _$SizeFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sizeBytes = freezed,
    Object? minSizeBytes = freezed,
    Object? maxSizeBytes = freezed,
    Object? operator = null,
  }) {
    return _then(_value.copyWith(
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      minSizeBytes: freezed == minSizeBytes
          ? _value.minSizeBytes
          : minSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSizeBytes: freezed == maxSizeBytes
          ? _value.maxSizeBytes
          : maxSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as SizeOperator,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SizeFilterImplCopyWith<$Res>
    implements $SizeFilterCopyWith<$Res> {
  factory _$$SizeFilterImplCopyWith(
          _$SizeFilterImpl value, $Res Function(_$SizeFilterImpl) then) =
      __$$SizeFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? sizeBytes,
      int? minSizeBytes,
      int? maxSizeBytes,
      SizeOperator operator});
}

/// @nodoc
class __$$SizeFilterImplCopyWithImpl<$Res>
    extends _$SizeFilterCopyWithImpl<$Res, _$SizeFilterImpl>
    implements _$$SizeFilterImplCopyWith<$Res> {
  __$$SizeFilterImplCopyWithImpl(
      _$SizeFilterImpl _value, $Res Function(_$SizeFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sizeBytes = freezed,
    Object? minSizeBytes = freezed,
    Object? maxSizeBytes = freezed,
    Object? operator = null,
  }) {
    return _then(_$SizeFilterImpl(
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      minSizeBytes: freezed == minSizeBytes
          ? _value.minSizeBytes
          : minSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxSizeBytes: freezed == maxSizeBytes
          ? _value.maxSizeBytes
          : maxSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as SizeOperator,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SizeFilterImpl implements _SizeFilter {
  _$SizeFilterImpl(
      {this.sizeBytes,
      this.minSizeBytes,
      this.maxSizeBytes,
      this.operator = SizeOperator.lessThan});

  factory _$SizeFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SizeFilterImplFromJson(json);

  @override
  final int? sizeBytes;
  @override
  final int? minSizeBytes;
  @override
  final int? maxSizeBytes;
  @override
  @JsonKey()
  final SizeOperator operator;

  @override
  String toString() {
    return 'SizeFilter(sizeBytes: $sizeBytes, minSizeBytes: $minSizeBytes, maxSizeBytes: $maxSizeBytes, operator: $operator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SizeFilterImpl &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.minSizeBytes, minSizeBytes) ||
                other.minSizeBytes == minSizeBytes) &&
            (identical(other.maxSizeBytes, maxSizeBytes) ||
                other.maxSizeBytes == maxSizeBytes) &&
            (identical(other.operator, operator) ||
                other.operator == operator));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sizeBytes, minSizeBytes, maxSizeBytes, operator);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SizeFilterImplCopyWith<_$SizeFilterImpl> get copyWith =>
      __$$SizeFilterImplCopyWithImpl<_$SizeFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SizeFilterImplToJson(
      this,
    );
  }
}

abstract class _SizeFilter implements SizeFilter {
  factory _SizeFilter(
      {final int? sizeBytes,
      final int? minSizeBytes,
      final int? maxSizeBytes,
      final SizeOperator operator}) = _$SizeFilterImpl;

  factory _SizeFilter.fromJson(Map<String, dynamic> json) =
      _$SizeFilterImpl.fromJson;

  @override
  int? get sizeBytes;
  @override
  int? get minSizeBytes;
  @override
  int? get maxSizeBytes;
  @override
  SizeOperator get operator;
  @override
  @JsonKey(ignore: true)
  _$$SizeFilterImplCopyWith<_$SizeFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StringFilter _$StringFilterFromJson(Map<String, dynamic> json) {
  return _StringFilter.fromJson(json);
}

/// @nodoc
mixin _$StringFilter {
  String get searchString => throw _privateConstructorUsedError;
  StringFilterType get type =>
      throw _privateConstructorUsedError; // Contains, starts with, ends with
  bool get include => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StringFilterCopyWith<StringFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StringFilterCopyWith<$Res> {
  factory $StringFilterCopyWith(
          StringFilter value, $Res Function(StringFilter) then) =
      _$StringFilterCopyWithImpl<$Res, StringFilter>;
  @useResult
  $Res call({String searchString, StringFilterType type, bool include});
}

/// @nodoc
class _$StringFilterCopyWithImpl<$Res, $Val extends StringFilter>
    implements $StringFilterCopyWith<$Res> {
  _$StringFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchString = null,
    Object? type = null,
    Object? include = null,
  }) {
    return _then(_value.copyWith(
      searchString: null == searchString
          ? _value.searchString
          : searchString // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StringFilterType,
      include: null == include
          ? _value.include
          : include // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StringFilterImplCopyWith<$Res>
    implements $StringFilterCopyWith<$Res> {
  factory _$$StringFilterImplCopyWith(
          _$StringFilterImpl value, $Res Function(_$StringFilterImpl) then) =
      __$$StringFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchString, StringFilterType type, bool include});
}

/// @nodoc
class __$$StringFilterImplCopyWithImpl<$Res>
    extends _$StringFilterCopyWithImpl<$Res, _$StringFilterImpl>
    implements _$$StringFilterImplCopyWith<$Res> {
  __$$StringFilterImplCopyWithImpl(
      _$StringFilterImpl _value, $Res Function(_$StringFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchString = null,
    Object? type = null,
    Object? include = null,
  }) {
    return _then(_$StringFilterImpl(
      searchString: null == searchString
          ? _value.searchString
          : searchString // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StringFilterType,
      include: null == include
          ? _value.include
          : include // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringFilterImpl implements _StringFilter {
  _$StringFilterImpl(
      {required this.searchString,
      this.type = StringFilterType.contains,
      this.include = false});

  factory _$StringFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringFilterImplFromJson(json);

  @override
  final String searchString;
  @override
  @JsonKey()
  final StringFilterType type;
// Contains, starts with, ends with
  @override
  @JsonKey()
  final bool include;

  @override
  String toString() {
    return 'StringFilter(searchString: $searchString, type: $type, include: $include)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringFilterImpl &&
            (identical(other.searchString, searchString) ||
                other.searchString == searchString) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.include, include) || other.include == include));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, searchString, type, include);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringFilterImplCopyWith<_$StringFilterImpl> get copyWith =>
      __$$StringFilterImplCopyWithImpl<_$StringFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StringFilterImplToJson(
      this,
    );
  }
}

abstract class _StringFilter implements StringFilter {
  factory _StringFilter(
      {required final String searchString,
      final StringFilterType type,
      final bool include}) = _$StringFilterImpl;

  factory _StringFilter.fromJson(Map<String, dynamic> json) =
      _$StringFilterImpl.fromJson;

  @override
  String get searchString;
  @override
  StringFilterType get type;
  @override // Contains, starts with, ends with
  bool get include;
  @override
  @JsonKey(ignore: true)
  _$$StringFilterImplCopyWith<_$StringFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
