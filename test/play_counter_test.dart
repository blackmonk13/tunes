import 'package:flutter_test/flutter_test.dart';
import 'package:tunes/utils/play_counter.dart';

void main() {
  const long = Duration(minutes: 4);

  /// Plays [seconds] ticks of song [id] and returns how many counted.
  int play(
    PlayCounter counter,
    int id,
    int seconds, {
    Duration length = long,
    int from = 0,
    bool playing = true,
  }) {
    var counted = 0;
    for (var s = 0; s < seconds; s++) {
      final hit = counter.tick(
        songId: id,
        playing: playing,
        position: Duration(seconds: from + s),
        songLength: length,
      );
      if (hit) counted++;
    }
    return counted;
  }

  test('threshold is 30 seconds, or half of a short song', () {
    expect(playThresholdFor(long), const Duration(seconds: 30));
    expect(playThresholdFor(const Duration(seconds: 40)),
        const Duration(seconds: 20));
    expect(playThresholdFor(null), const Duration(seconds: 30));
  });

  test('counts once after 30 seconds, and not again while it keeps playing',
      () {
    final counter = PlayCounter();
    expect(play(counter, 1, 29), 0);
    expect(play(counter, 1, 120, from: 29), 1);
  });

  test('paused time does not count', () {
    final counter = PlayCounter();
    expect(play(counter, 1, 100, playing: false), 0);
    expect(play(counter, 1, 29, from: 100), 0);
    expect(play(counter, 1, 1, from: 129), 1);
  });

  test('a short song counts at half its length', () {
    final counter = PlayCounter();
    const length = Duration(seconds: 20);
    expect(play(counter, 1, 9, length: length), 0);
    expect(play(counter, 1, 1, length: length, from: 9), 1);
  });

  test('skipping before the threshold does not count, the next song can', () {
    final counter = PlayCounter();
    expect(play(counter, 1, 20), 0);
    expect(play(counter, 2, 30), 1);
  });

  test('starting the same song again counts again', () {
    final counter = PlayCounter();
    expect(play(counter, 1, 40), 1);
    expect(play(counter, 1, 40), 1);
  });

  test('seeking forward does not skip the listening time', () {
    final counter = PlayCounter();
    expect(play(counter, 1, 20), 0);
    expect(play(counter, 1, 10, from: 200), 1);
  });
}
