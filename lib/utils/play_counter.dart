/// How long a song must play before it counts as played: 30 seconds, or half
/// of the song if that is shorter.
const playCountThreshold = Duration(seconds: 30);

Duration playThresholdFor(Duration? songLength) {
  if (songLength == null || songLength <= Duration.zero) {
    return playCountThreshold;
  }
  final half = songLength ~/ 2;
  return half < playCountThreshold ? half : playCountThreshold;
}

/// Decides when a song has been listened to for long enough to count a play.
///
/// Call [tick] at a steady [interval] with what the player is doing. Time
/// only adds up while the song is playing, so pausing and seeking do not
/// count, and a song counts once per listen: moving to another song, or
/// starting the same one again from the beginning, begins a new listen.
class PlayCounter {
  PlayCounter({this.interval = const Duration(seconds: 1)});

  final Duration interval;

  int? _songId;
  Duration _listened = Duration.zero;
  Duration _lastPosition = Duration.zero;
  bool _counted = false;

  /// Returns true on the tick the current listen reaches its threshold.
  bool tick({
    required int? songId,
    required bool playing,
    required Duration position,
    Duration? songLength,
  }) {
    final restarted = _lastPosition - position > const Duration(seconds: 1) &&
        position < const Duration(seconds: 3);
    if (songId != _songId || restarted) {
      _songId = songId;
      _listened = Duration.zero;
      _counted = false;
    }
    _lastPosition = position;

    if (songId == null || !playing || _counted) return false;

    _listened += interval;
    if (_listened < playThresholdFor(songLength)) return false;

    _counted = true;
    return true;
  }
}
