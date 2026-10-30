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

  // Songs saved before these fields existed read back as Isar's null marker
  // (the smallest int), so they are reset to never played.
  unawaited(_resetUnsetPlayFields(isar));

  Future<void> record(int songId) async {
    await isar.writeTxn(() async {
      final song = await isar.songs.get(songId);
      if (song == null) return;
      song
        ..playCount = (song.playCount < 0 ? 0 : song.playCount) + 1
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

Future<void> _resetUnsetPlayFields(Isar isar) async {
  final unset = await isar.songs
      .filter()
      .playCountLessThan(0)
      .or()
      .lastPlayedAtLessThan(0)
      .findAll();
  if (unset.isEmpty) return;

  for (final song in unset) {
    if (song.playCount < 0) song.playCount = 0;
    if (song.lastPlayedAt < 0) song.lastPlayedAt = 0;
  }
  await isar.writeTxn(() => isar.songs.putAll(unset));
}

/// Sets every song back to never played.
Future<void> resetPlayHistory(Isar isar) async {
  final played = await isar.songs
      .filter()
      .playCountGreaterThan(0)
      .or()
      .lastPlayedAtGreaterThan(0)
      .findAll();

  for (final song in played) {
    song
      ..playCount = 0
      ..lastPlayedAt = 0;
  }
  await isar.writeTxn(() => isar.songs.putAll(played));
}
