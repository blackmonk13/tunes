
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tunes/database/database.dart';

part 'tunesong.freezed.dart';


@freezed
class TuneSong with _$TuneSong {
  factory TuneSong({
    required Song songInfo,
    Album? albumInfo,
    Artist? artistInfo,
    Cover? artworkInfo,
  }) = _TuneSong;
	
}
