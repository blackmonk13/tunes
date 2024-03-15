// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tuneartist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TuneArtist {
  Artist get artist => throw _privateConstructorUsedError;
  Cover? get cover => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TuneArtistCopyWith<TuneArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TuneArtistCopyWith<$Res> {
  factory $TuneArtistCopyWith(
          TuneArtist value, $Res Function(TuneArtist) then) =
      _$TuneArtistCopyWithImpl<$Res, TuneArtist>;
  @useResult
  $Res call({Artist artist, Cover? cover});
}

/// @nodoc
class _$TuneArtistCopyWithImpl<$Res, $Val extends TuneArtist>
    implements $TuneArtistCopyWith<$Res> {
  _$TuneArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artist = freezed,
    Object? cover = freezed,
  }) {
    return _then(_value.copyWith(
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as Cover?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TuneArtistImplCopyWith<$Res>
    implements $TuneArtistCopyWith<$Res> {
  factory _$$TuneArtistImplCopyWith(
          _$TuneArtistImpl value, $Res Function(_$TuneArtistImpl) then) =
      __$$TuneArtistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Artist artist, Cover? cover});
}

/// @nodoc
class __$$TuneArtistImplCopyWithImpl<$Res>
    extends _$TuneArtistCopyWithImpl<$Res, _$TuneArtistImpl>
    implements _$$TuneArtistImplCopyWith<$Res> {
  __$$TuneArtistImplCopyWithImpl(
      _$TuneArtistImpl _value, $Res Function(_$TuneArtistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artist = freezed,
    Object? cover = freezed,
  }) {
    return _then(_$TuneArtistImpl(
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as Cover?,
    ));
  }
}

/// @nodoc

class _$TuneArtistImpl implements _TuneArtist {
  _$TuneArtistImpl({required this.artist, this.cover});

  @override
  final Artist artist;
  @override
  final Cover? cover;

  @override
  String toString() {
    return 'TuneArtist(artist: $artist, cover: $cover)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TuneArtistImpl &&
            const DeepCollectionEquality().equals(other.artist, artist) &&
            const DeepCollectionEquality().equals(other.cover, cover));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(artist),
      const DeepCollectionEquality().hash(cover));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TuneArtistImplCopyWith<_$TuneArtistImpl> get copyWith =>
      __$$TuneArtistImplCopyWithImpl<_$TuneArtistImpl>(this, _$identity);
}

abstract class _TuneArtist implements TuneArtist {
  factory _TuneArtist({required final Artist artist, final Cover? cover}) =
      _$TuneArtistImpl;

  @override
  Artist get artist;
  @override
  Cover? get cover;
  @override
  @JsonKey(ignore: true)
  _$$TuneArtistImplCopyWith<_$TuneArtistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
