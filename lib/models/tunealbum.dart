
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tunes/database/database.dart';

part 'tunealbum.freezed.dart';


@freezed
class TuneAlbum with _$TuneAlbum {
  factory TuneAlbum({
    required Album album,
    Cover? cover,
    Artist? artist,
  }) = _TuneAlbum;
	
}
