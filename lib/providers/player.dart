part of 'providers.dart';

@Riverpod(keepAlive: true)
AudioPlayer audioPlayer(AudioPlayerRef ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
}

@Riverpod(keepAlive: true)
Stream<Duration> playerPosition(PlayerPositionRef ref) {
  final player = ref.watch(audioPlayerProvider);

  return player.positionStream;
}

@Riverpod(keepAlive: true)
Stream<Duration?> playerDuration(PlayerDurationRef ref) {
  final player = ref.watch(audioPlayerProvider);

  return player.durationStream;
}

@Riverpod(keepAlive: true)
Stream<bool> playerPlaying(PlayerPlayingRef ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.playingStream;
}

@Riverpod(keepAlive: true)
Stream<List<IndexedAudioSource>?> playlistSequence(PlaylistSequenceRef ref) {
  return ref.watch(audioPlayerProvider).sequenceStream;
}

@Riverpod(keepAlive: true)
Stream<int?> playerCurrentIndex(PlayerCurrentIndexRef ref) {
  return ref.watch(audioPlayerProvider).currentIndexStream;
}

@Riverpod(keepAlive: true)
Stream<PlayerState> playerState(PlayerStateRef ref) {
  return ref.watch(audioPlayerProvider).playerStateStream;
}

@Riverpod(keepAlive: true)
Stream<LoopMode> playerLoopMode(PlayerLoopModeRef ref) {
  return ref.watch(audioPlayerProvider).loopModeStream;
}

@Riverpod(keepAlive: true)
Stream<bool> playerShuffleModeEnabled(PlayerShuffleModeEnabledRef ref) {
  return ref.watch(audioPlayerProvider).shuffleModeEnabledStream;
}

@Riverpod(keepAlive: true)
Stream<List<int>> playerShuffleIndices(PlayerShuffleIndicesRef ref) {
  return ref.watch(audioPlayerProvider).shuffleIndicesStream;
}

/// Builds the [AudioSource] for [song]. The [MediaItem] tag carries the song id
/// so the queue can be mapped back to Isar [Song]s (see [songIdOf]).
UriAudioSource songToAudioSource(Song song) {
  return AudioSource.uri(
    Uri.parse(song.filePath),
    tag: MediaItem(
      id: song.id.toString(),
      title: song.title,
      artist: song.artist.value?.name,
      album: song.album.value?.title,
      genre: song.genre.value?.name,
      artUri: song.thumbnailPath == null ? null : Uri.file(song.thumbnailPath!),
    ),
  );
}

/// The Isar [Song] id stored in the [MediaItem] tag of [source].
int songIdOf(IndexedAudioSource source) {
  return int.parse((source.tag as MediaItem).id);
}

/// The songs currently in the player queue, in playlist order.
@Riverpod(keepAlive: true)
Future<List<Song>> nowPlayingSongs(NowPlayingSongsRef ref) async {
  final sequence = await ref.watch(playlistSequenceProvider.future);

  if (sequence == null || sequence.isEmpty) {
    return [];
  }

  final songs = await ref
      .read(isarProvider)
      .requireValue
      .songs
      .getAll(sequence.map(songIdOf).toList());

  return songs.whereType<Song>().toList();
}

/// One row of the queue: its position in the player's playlist and its song.
///
/// The same song can be in the queue more than once, so rows are told apart by
/// [index], not by song id.
class QueueEntry {
  const QueueEntry({required this.index, required this.song});

  /// The index of this item in the player's playlist (what `seek` and
  /// `removeAudioSourceAt` take), not its place in the playback order.
  final int index;
  final Song song;
}

/// The queue in playback order: the shuffle order when shuffle is on.
@Riverpod(keepAlive: true)
Future<List<QueueEntry>> queueEntries(QueueEntriesRef ref) async {
  // Everything is watched before the first await, which Riverpod requires.
  final player = ref.watch(audioPlayerProvider);
  final isar = ref.watch(isarProvider).requireValue;
  ref.watch(playlistSequenceProvider);
  ref.watch(playerShuffleModeEnabledProvider);
  ref.watch(playerShuffleIndicesProvider);

  // Read the player once so the sequence and the order are from the same moment.
  final sequence = player.sequence;
  final order = player.effectiveIndices;
  if (sequence.isEmpty) return [];

  final songs = await isar.songs.getAll(sequence.map(songIdOf).toList());

  return [
    for (final index in order)
      if (songs[index] != null) QueueEntry(index: index, song: songs[index]!),
  ];
}

@Riverpod(keepAlive: true)
class PlaybackController extends _$PlaybackController {
  // `AudioPlayer.play()` completes only when playback pauses or ends, so it is
  // never awaited here: callers (such as a bottom sheet closing after its
  // action) would otherwise wait for the song to finish.

  // Held in a field, not read through `ref` on each use: this controller
  // rebuilds whenever the queue changes, and `ref.read` throws between a
  // dependency changing and the rebuild, which a method that edits the queue
  // and then uses the player again would hit.
  late AudioPlayer _player;

  @override
  FutureOr<List<int>> build() async {
    _player = ref.watch(audioPlayerProvider);
    final sequence = await ref.watch(playlistSequenceProvider.future);

    return sequence?.map(songIdOf).toList() ?? [];
  }

  List<int> getQueueItemIds() {
    final sequence = _player.sequence;

    return _player.shuffleIndices
        .map((index) => songIdOf(sequence[index]))
        .toList();
  }

  Future<void> playSong(Song song) async {
    final source = songToAudioSource(song);
    await _player.clearAudioSources();
    await _player.addAudioSource(source);
    await _player.seek(Duration.zero, index: 0);
    unawaited(_player.play());
  }

  Future<void> addToQueue(Song song) async {
    final source = songToAudioSource(song);
    await _player.addAudioSource(source);
  }

  Future<void> addMultipleToQueue(List<Song> songs) async {
    final sources = songs.map(songToAudioSource).toList();
    await _player.addAudioSources(sources);
  }

  Future<void> addMultipleToQueueAndShuffle(List<Song> songs) async {
    await addMultipleToQueue(songs);
    await _player.shuffle();
  }

  /// Plays [song] now: it is added to the end of the queue when missing, then
  /// playback jumps to it, whether the player was playing, paused or idle.
  Future<void> addAndPlay(Song song) async {
    var index = _findSongIndex(song);
    if (index == -1) {
      index = _player.audioSources.length;
      await _player.addAudioSource(songToAudioSource(song));
    }

    await _player.seek(Duration.zero, index: index);
    unawaited(_player.play());
  }

  Future<void> addMultipleAndPlay(List<Song> songs, {Song? startWith}) async {
    final sources = songs.map(songToAudioSource).toList();
    final startIndex = _player.audioSources.length;

    // Remove any existing instances of these songs
    await _removeExistingSongs(songs);

    await _player.addAudioSources(sources);

    if (startWith != null) {
      final startWithIndex = songs.indexWhere((s) => s.id == startWith.id);
      if (startWithIndex != -1) {
        await _player.seek(Duration.zero, index: startIndex + startWithIndex);
      } else {
        await _player.seek(Duration.zero, index: startIndex);
      }
    } else {
      await _player.seek(Duration.zero, index: startIndex);
    }
    unawaited(_player.play());
  }

  Future<void> addAndPlayNext(Song song) async {
    final source = songToAudioSource(song);
    final currentIndex = _player.currentIndex;
    if (currentIndex != null) {
      await _player.insertAudioSource(currentIndex + 1, source);
      await _player.seekToNext();
    } else {
      await _player.addAudioSource(source);
      await _player.seek(Duration.zero, index: 0);
    }
    unawaited(_player.play());
  }

  Future<void> addMultipleAndPlayNext(List<Song> songs,
      {Song? startWith}) async {
    final sources = songs.map(songToAudioSource).toList();
    final currentIndex = _player.currentIndex ?? -1;

    // Remove any existing instances of these songs
    await _removeExistingSongs(songs);

    await _player.insertAudioSources(currentIndex + 1, sources);

    if (startWith != null) {
      final startWithIndex = songs.indexWhere((s) => s.id == startWith.id);
      if (startWithIndex != -1) {
        await _player.seekToNext();
        await _player.seek(Duration.zero,
            index: currentIndex + 1 + startWithIndex);
      } else {
        await _player.seekToNext();
      }
    } else {
      await _player.seekToNext();
    }
    unawaited(_player.play());
  }

  Future<void> replaceQueue(List<Song> songs, {Song? startWith}) async {
    final sources = songs.map(songToAudioSource).toList();
    await _player.clearAudioSources();
    await _player.addAudioSources(sources);

    if (startWith != null) {
      final startWithIndex = songs.indexWhere((s) => s.id == startWith.id);
      if (startWithIndex != -1) {
        await _player.seek(Duration.zero, index: startWithIndex);
      } else {
        await _player.seek(Duration.zero, index: 0);
      }
    } else {
      await _player.seek(Duration.zero, index: 0);
    }

    await _player.setShuffleModeEnabled(true);
    await _player.shuffle();
    unawaited(_player.play());
  }

  Future<void> removeFromQueue(int index) async {
    await _player.removeAudioSourceAt(index);
  }

  Future<void> removeMultipleFromQueue(List<int> indices) async {
    // Sort indices in descending order to avoid index shifting issues
    final sortedIndices = indices..sort((a, b) => b.compareTo(a));
    for (final index in sortedIndices) {
      await removeFromQueue(index);
    }
  }

  Future<void> removeSongFromQueue(Song song) async {
    final index = _findSongIndex(song);
    if (index != -1) {
      await removeFromQueue(index);
    }
  }

  Future<void> removeMultipleSongsFromQueue(List<Song> songs) async {
    final indices =
        songs.map(_findSongIndex).where((index) => index != -1).toList();

    await removeMultipleFromQueue(indices);
  }

  Future<void> clearQueue() async {
    await _player.stop();
    await _player.clearAudioSources();
  }

  /// Jumps to the queue item at playlist [index] and plays it.
  Future<void> playQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
    unawaited(_player.play());
  }

  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
  }

  Future<void> insertSongNext(Song song) async {
    final source = songToAudioSource(song);
    final currentIndex = _player.currentIndex;
    if (currentIndex != null) {
      await _player.insertAudioSource(currentIndex + 1, source);
    } else {
      await _player.addAudioSource(source);
    }
  }

  Future<void> insertMultipleSongsNext(List<Song> songs) async {
    final sources = songs.map(songToAudioSource).toList();
    final currentIndex = _player.currentIndex;
    if (currentIndex != null) {
      await _player.insertAudioSources(currentIndex + 1, sources);
    } else {
      await _player.addAudioSources(sources);
    }
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  Future<void> setShuffleMode(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  int _findSongIndex(Song song) {
    return _player.sequence.indexWhere((source) => songIdOf(source) == song.id);
  }

  Future<void> _removeExistingSongs(List<Song> songs) async {
    final indicesToRemove = songs
        .map((song) => _findSongIndex(song))
        .where((index) => index != -1)
        .toList();

    // Sort indices in descending order to avoid index shifting issues
    indicesToRemove.sort((a, b) => b.compareTo(a));

    for (final index in indicesToRemove) {
      await _player.removeAudioSourceAt(index);
    }
  }
}
