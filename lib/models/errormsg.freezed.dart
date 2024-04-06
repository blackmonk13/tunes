// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'errormsg.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ErrorMsg _$ErrorMsgFromJson(Map<String, dynamic> json) {
  return _ErrorMsg.fromJson(json);
}

/// @nodoc
mixin _$ErrorMsg {
  String get code => throw _privateConstructorUsedError;
  String get brief => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  String? get solution => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ErrorMsgCopyWith<ErrorMsg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorMsgCopyWith<$Res> {
  factory $ErrorMsgCopyWith(ErrorMsg value, $Res Function(ErrorMsg) then) =
      _$ErrorMsgCopyWithImpl<$Res, ErrorMsg>;
  @useResult
  $Res call({String code, String brief, String? details, String? solution});
}

/// @nodoc
class _$ErrorMsgCopyWithImpl<$Res, $Val extends ErrorMsg>
    implements $ErrorMsgCopyWith<$Res> {
  _$ErrorMsgCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? brief = null,
    Object? details = freezed,
    Object? solution = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      brief: null == brief
          ? _value.brief
          : brief // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      solution: freezed == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ErrorMsgImplCopyWith<$Res>
    implements $ErrorMsgCopyWith<$Res> {
  factory _$$ErrorMsgImplCopyWith(
          _$ErrorMsgImpl value, $Res Function(_$ErrorMsgImpl) then) =
      __$$ErrorMsgImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String brief, String? details, String? solution});
}

/// @nodoc
class __$$ErrorMsgImplCopyWithImpl<$Res>
    extends _$ErrorMsgCopyWithImpl<$Res, _$ErrorMsgImpl>
    implements _$$ErrorMsgImplCopyWith<$Res> {
  __$$ErrorMsgImplCopyWithImpl(
      _$ErrorMsgImpl _value, $Res Function(_$ErrorMsgImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? brief = null,
    Object? details = freezed,
    Object? solution = freezed,
  }) {
    return _then(_$ErrorMsgImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      brief: null == brief
          ? _value.brief
          : brief // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      solution: freezed == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorMsgImpl implements _ErrorMsg {
  _$ErrorMsgImpl(
      {this.code = "0000",
      this.brief = "Unknown error",
      this.details,
      this.solution});

  factory _$ErrorMsgImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorMsgImplFromJson(json);

  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final String brief;
  @override
  final String? details;
  @override
  final String? solution;

  @override
  String toString() {
    return 'ErrorMsg(code: $code, brief: $brief, details: $details, solution: $solution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorMsgImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.brief, brief) || other.brief == brief) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.solution, solution) ||
                other.solution == solution));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, brief, details, solution);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorMsgImplCopyWith<_$ErrorMsgImpl> get copyWith =>
      __$$ErrorMsgImplCopyWithImpl<_$ErrorMsgImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorMsgImplToJson(
      this,
    );
  }
}

abstract class _ErrorMsg implements ErrorMsg {
  factory _ErrorMsg(
      {final String code,
      final String brief,
      final String? details,
      final String? solution}) = _$ErrorMsgImpl;

  factory _ErrorMsg.fromJson(Map<String, dynamic> json) =
      _$ErrorMsgImpl.fromJson;

  @override
  String get code;
  @override
  String get brief;
  @override
  String? get details;
  @override
  String? get solution;
  @override
  @JsonKey(ignore: true)
  _$$ErrorMsgImplCopyWith<_$ErrorMsgImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
