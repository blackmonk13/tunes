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

@Riverpod(keepAlive: true)
class PlaybackController extends _$PlaybackController {
  AudioPlayer get _player => ref.read(audioPlayerProvider);

  @override
  FutureOr<List<int>> build() async {
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
    await _player.play();
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

  Future<void> addAndPlay(Song song) async {
    final source = songToAudioSource(song);
    final existingIndex = _findSongIndex(song);

    if (existingIndex != -1) {
      if (existingIndex == _player.currentIndex) {
        // If it's the currently playing song, restart playback
        await _player.seek(Duration.zero, index: existingIndex);
      } else if (existingIndex < (_player.currentIndex ?? -1)) {
        // If it's already been played, move it to be the next item
        await _player.removeAudioSourceAt(existingIndex);
        await _player.insertAudioSource(
            (_player.currentIndex ?? -1) + 1, source);
        await _player.seekToNext();
      } else {
        // If it's not been played yet, move it to be the next item
        await _player.removeAudioSourceAt(existingIndex);
        await _player.insertAudioSource(
            (_player.currentIndex ?? -1) + 1, source);
        await _player.seekToNext();
      }
    } else {
      // If it's not in the queue, add it and play
      final index = _player.audioSources.length;
      await _player.addAudioSource(source);
      await _player.seek(Duration.zero, index: index);
    }
    await _player.play();
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
    await _player.play();
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
    await _player.play();
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
    await _player.play();
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
    await _player.play();
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
