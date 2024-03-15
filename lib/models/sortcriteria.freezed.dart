// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sortcriteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SortCriteria {
  OrderingMode get mode => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SortCriteriaCopyWith<SortCriteria> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortCriteriaCopyWith<$Res> {
  factory $SortCriteriaCopyWith(
          SortCriteria value, $Res Function(SortCriteria) then) =
      _$SortCriteriaCopyWithImpl<$Res, SortCriteria>;
  @useResult
  $Res call({OrderingMode mode, String key});
}

/// @nodoc
class _$SortCriteriaCopyWithImpl<$Res, $Val extends SortCriteria>
    implements $SortCriteriaCopyWith<$Res> {
  _$SortCriteriaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? key = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as OrderingMode,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SortCriteriaImplCopyWith<$Res>
    implements $SortCriteriaCopyWith<$Res> {
  factory _$$SortCriteriaImplCopyWith(
          _$SortCriteriaImpl value, $Res Function(_$SortCriteriaImpl) then) =
      __$$SortCriteriaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OrderingMode mode, String key});
}

/// @nodoc
class __$$SortCriteriaImplCopyWithImpl<$Res>
    extends _$SortCriteriaCopyWithImpl<$Res, _$SortCriteriaImpl>
    implements _$$SortCriteriaImplCopyWith<$Res> {
  __$$SortCriteriaImplCopyWithImpl(
      _$SortCriteriaImpl _value, $Res Function(_$SortCriteriaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? key = null,
  }) {
    return _then(_$SortCriteriaImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as OrderingMode,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SortCriteriaImpl implements _SortCriteria {
  _$SortCriteriaImpl({this.mode = OrderingMode.asc, this.key = 'id'});

  @override
  @JsonKey()
  final OrderingMode mode;
  @override
  @JsonKey()
  final String key;

  @override
  String toString() {
    return 'SortCriteria(mode: $mode, key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortCriteriaImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SortCriteriaImplCopyWith<_$SortCriteriaImpl> get copyWith =>
      __$$SortCriteriaImplCopyWithImpl<_$SortCriteriaImpl>(this, _$identity);
}

abstract class _SortCriteria implements SortCriteria {
  factory _SortCriteria({final OrderingMode mode, final String key}) =
      _$SortCriteriaImpl;

  @override
  OrderingMode get mode;
  @override
  String get key;
  @override
  @JsonKey(ignore: true)
  _$$SortCriteriaImplCopyWith<_$SortCriteriaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
