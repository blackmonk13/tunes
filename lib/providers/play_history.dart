part of 'providers.dart';

/// Counts a play on a song once it has been listened to for long enough, and
/// stamps the time, so the songs can be sorted by what was played.
///
/// Must be started at startup after Isar is ready.
@Riverpod(keepAlive: true)
void playHistory(PlayHistoryRef ref) {
  final player = ref.watch(audioPlayerProvider);
  final isar = ref.read(isarProvider).requireValue;
  final counter = PlayCounter();

  Future<void> record(int songId) async {
    await isar.writeTxn(() async {
      final song = await isar.songs.get(songId);
      if (song == null) return;
      song
        ..playCount += 1
        ..lastPlayedAt = DateTime.now().millisecondsSinceEpoch;
      await isar.songs.put(song);
    });
  }

  final timer = Timer.periodic(counter.interval, (_) {
    final sequence = player.sequence;
    final index = player.currentIndex;
    final current =
        index != null && index < sequence.length ? sequence[index] : null;

    final counted = counter.tick(
      songId: current == null ? null : songIdOf(current),
      playing:
          player.playing && player.processingState == ProcessingState.ready,
      position: player.position,
      songLength: player.duration,
    );
    if (counted) unawaited(record(songIdOf(current!)));
  });

  ref.onDispose(timer.cancel);
}
