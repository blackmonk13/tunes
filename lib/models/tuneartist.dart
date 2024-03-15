
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tunes/database/database.dart';

part 'tuneartist.freezed.dart';


@freezed
class TuneArtist with _$TuneArtist {
  factory TuneArtist({
    required Artist artist,
    Cover? cover,
  }) = _TuneArtist;
	
}
