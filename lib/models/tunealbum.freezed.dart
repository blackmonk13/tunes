// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tunealbum.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TuneAlbum {
  Album get album => throw _privateConstructorUsedError;
  Cover? get cover => throw _privateConstructorUsedError;
  Artist? get artist => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TuneAlbumCopyWith<TuneAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TuneAlbumCopyWith<$Res> {
  factory $TuneAlbumCopyWith(TuneAlbum value, $Res Function(TuneAlbum) then) =
      _$TuneAlbumCopyWithImpl<$Res, TuneAlbum>;
  @useResult
  $Res call({Album album, Cover? cover, Artist? artist});
}

/// @nodoc
class _$TuneAlbumCopyWithImpl<$Res, $Val extends TuneAlbum>
    implements $TuneAlbumCopyWith<$Res> {
  _$TuneAlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
    Object? cover = freezed,
    Object? artist = freezed,
  }) {
    return _then(_value.copyWith(
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as Cover?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TuneAlbumImplCopyWith<$Res>
    implements $TuneAlbumCopyWith<$Res> {
  factory _$$TuneAlbumImplCopyWith(
          _$TuneAlbumImpl value, $Res Function(_$TuneAlbumImpl) then) =
      __$$TuneAlbumImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Album album, Cover? cover, Artist? artist});
}

/// @nodoc
class __$$TuneAlbumImplCopyWithImpl<$Res>
    extends _$TuneAlbumCopyWithImpl<$Res, _$TuneAlbumImpl>
    implements _$$TuneAlbumImplCopyWith<$Res> {
  __$$TuneAlbumImplCopyWithImpl(
      _$TuneAlbumImpl _value, $Res Function(_$TuneAlbumImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
    Object? cover = freezed,
    Object? artist = freezed,
  }) {
    return _then(_$TuneAlbumImpl(
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as Album,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as Cover?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
    ));
  }
}

/// @nodoc

class _$TuneAlbumImpl implements _TuneAlbum {
  _$TuneAlbumImpl({required this.album, this.cover, this.artist});

  @override
  final Album album;
  @override
  final Cover? cover;
  @override
  final Artist? artist;

  @override
  String toString() {
    return 'TuneAlbum(album: $album, cover: $cover, artist: $artist)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TuneAlbumImpl &&
            const DeepCollectionEquality().equals(other.album, album) &&
            const DeepCollectionEquality().equals(other.cover, cover) &&
            const DeepCollectionEquality().equals(other.artist, artist));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(album),
      const DeepCollectionEquality().hash(cover),
      const DeepCollectionEquality().hash(artist));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TuneAlbumImplCopyWith<_$TuneAlbumImpl> get copyWith =>
      __$$TuneAlbumImplCopyWithImpl<_$TuneAlbumImpl>(this, _$identity);
}

abstract class _TuneAlbum implements TuneAlbum {
  factory _TuneAlbum(
      {required final Album album,
      final Cover? cover,
      final Artist? artist}) = _$TuneAlbumImpl;

  @override
  Album get album;
  @override
  Cover? get cover;
  @override
  Artist? get artist;
  @override
  @JsonKey(ignore: true)
  _$$TuneAlbumImplCopyWith<_$TuneAlbumImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
