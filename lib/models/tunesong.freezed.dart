// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tunesong.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TuneSong {
  Song get songInfo => throw _privateConstructorUsedError;
  Album? get albumInfo => throw _privateConstructorUsedError;
  Artist? get artistInfo => throw _privateConstructorUsedError;
  Cover? get artworkInfo => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TuneSongCopyWith<TuneSong> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TuneSongCopyWith<$Res> {
  factory $TuneSongCopyWith(TuneSong value, $Res Function(TuneSong) then) =
      _$TuneSongCopyWithImpl<$Res, TuneSong>;
  @useResult
  $Res call(
      {Song songInfo,
      Album? albumInfo,
      Artist? artistInfo,
      Cover? artworkInfo});
}

/// @nodoc
class _$TuneSongCopyWithImpl<$Res, $Val extends TuneSong>
    implements $TuneSongCopyWith<$Res> {
  _$TuneSongCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songInfo = freezed,
    Object? albumInfo = freezed,
    Object? artistInfo = freezed,
    Object? artworkInfo = freezed,
  }) {
    return _then(_value.copyWith(
      songInfo: freezed == songInfo
          ? _value.songInfo
          : songInfo // ignore: cast_nullable_to_non_nullable
              as Song,
      albumInfo: freezed == albumInfo
          ? _value.albumInfo
          : albumInfo // ignore: cast_nullable_to_non_nullable
              as Album?,
      artistInfo: freezed == artistInfo
          ? _value.artistInfo
          : artistInfo // ignore: cast_nullable_to_non_nullable
              as Artist?,
      artworkInfo: freezed == artworkInfo
          ? _value.artworkInfo
          : artworkInfo // ignore: cast_nullable_to_non_nullable
              as Cover?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TuneSongImplCopyWith<$Res>
    implements $TuneSongCopyWith<$Res> {
  factory _$$TuneSongImplCopyWith(
          _$TuneSongImpl value, $Res Function(_$TuneSongImpl) then) =
      __$$TuneSongImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Song songInfo,
      Album? albumInfo,
      Artist? artistInfo,
      Cover? artworkInfo});
}

/// @nodoc
class __$$TuneSongImplCopyWithImpl<$Res>
    extends _$TuneSongCopyWithImpl<$Res, _$TuneSongImpl>
    implements _$$TuneSongImplCopyWith<$Res> {
  __$$TuneSongImplCopyWithImpl(
      _$TuneSongImpl _value, $Res Function(_$TuneSongImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songInfo = freezed,
    Object? albumInfo = freezed,
    Object? artistInfo = freezed,
    Object? artworkInfo = freezed,
  }) {
    return _then(_$TuneSongImpl(
      songInfo: freezed == songInfo
          ? _value.songInfo
          : songInfo // ignore: cast_nullable_to_non_nullable
              as Song,
      albumInfo: freezed == albumInfo
          ? _value.albumInfo
          : albumInfo // ignore: cast_nullable_to_non_nullable
              as Album?,
      artistInfo: freezed == artistInfo
          ? _value.artistInfo
          : artistInfo // ignore: cast_nullable_to_non_nullable
              as Artist?,
      artworkInfo: freezed == artworkInfo
          ? _value.artworkInfo
          : artworkInfo // ignore: cast_nullable_to_non_nullable
              as Cover?,
    ));
  }
}

/// @nodoc

class _$TuneSongImpl implements _TuneSong {
  _$TuneSongImpl(
      {required this.songInfo,
      this.albumInfo,
      this.artistInfo,
      this.artworkInfo});

  @override
  final Song songInfo;
  @override
  final Album? albumInfo;
  @override
  final Artist? artistInfo;
  @override
  final Cover? artworkInfo;

  @override
  String toString() {
    return 'TuneSong(songInfo: $songInfo, albumInfo: $albumInfo, artistInfo: $artistInfo, artworkInfo: $artworkInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TuneSongImpl &&
            const DeepCollectionEquality().equals(other.songInfo, songInfo) &&
            const DeepCollectionEquality().equals(other.albumInfo, albumInfo) &&
            const DeepCollectionEquality()
                .equals(other.artistInfo, artistInfo) &&
            const DeepCollectionEquality()
                .equals(other.artworkInfo, artworkInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(songInfo),
      const DeepCollectionEquality().hash(albumInfo),
      const DeepCollectionEquality().hash(artistInfo),
      const DeepCollectionEquality().hash(artworkInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TuneSongImplCopyWith<_$TuneSongImpl> get copyWith =>
      __$$TuneSongImplCopyWithImpl<_$TuneSongImpl>(this, _$identity);
}

abstract class _TuneSong implements TuneSong {
  factory _TuneSong(
      {required final Song songInfo,
      final Album? albumInfo,
      final Artist? artistInfo,
      final Cover? artworkInfo}) = _$TuneSongImpl;

  @override
  Song get songInfo;
  @override
  Album? get albumInfo;
  @override
  Artist? get artistInfo;
  @override
  Cover? get artworkInfo;
  @override
  @JsonKey(ignore: true)
  _$$TuneSongImplCopyWith<_$TuneSongImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
