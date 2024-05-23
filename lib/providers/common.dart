part of 'providers.dart';

@riverpod
FutureOr<bool> appPermissions(AppPermissionsRef ref) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.audio,
    Permission.videos,
    Permission.manageExternalStorage,
  ].request();

  return statuses.entries.every(
    (element) {
      return element.value.isGranted;
    },
  );
}

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    return themeModePref;
  }

  Future<bool> setTheme(ThemeMode themeMode) async {
    return setThemeModePref(themeMode);
  }
}

@Riverpod(keepAlive: true)
bool eulaAccepted(EulaAcceptedRef ref) {
  return prefs.getBool(eulaPrefsKey) ?? false;
}

@Riverpod(keepAlive: true)
class TabIndex extends _$TabIndex {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int index) {
    state = index;
  }
}

@Riverpod(keepAlive: true)
OnAudioQuery onAudioQuery(OnAudioQueryRef ref) {
  return OnAudioQuery();
}

@Riverpod(keepAlive: true)
AudioPlayer audioPlayer(AudioPlayerRef ref) {
  return AudioPlayer();
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
class NowPlayingController extends _$NowPlayingController {
  @override
  FutureOr<List<SongModel>> build() async {
    final audioSequence = await ref.watch(playlistSequenceProvider.future);

    if (audioSequence == null) {
      return [];
    }

    return getPlaylistSongs(audioSequence);
  }

  Future<void> queue(List<SongModel> songs, {SongModel? startWith}) async {
    final player = ref.read(audioPlayerProvider);
    final playlist = getPlaylist();

    final audioSources = songs.map((song) => createAudioSource(song)).toList();

    if (playlist == null) {
      await createAndLoadPlaylist(
        items: audioSources,
        initialIndex: startWith == null ? null : songs.indexOf(startWith),
      );
      return player.play();
    }

    final playlistItems = await getPlaylistSongs(playlist.sequence);

    if (playlistItems.isEmpty) {
      await createAndLoadPlaylist(
        items: audioSources,
        initialIndex: startWith == null ? null : songs.indexOf(startWith),
      );
      return player.play();
    }

    await playlist.addAll(audioSources);

    final startIndex = await getStartIndex(startWith);

    if (startWith != null) {
      await player.seek(Duration.zero, index: startIndex);
    }

    if (player.playing) {
      return;
    }

    return player.play();
  }

  Future<void> playAll(List<SongModel> songs, {SongModel? startWith}) async {
    final player = ref.read(audioPlayerProvider);
    final playlist = getPlaylist();

    final audioSources = songs.map((song) => createAudioSource(song)).toList();

    if (playlist == null) {
      await createAndLoadPlaylist(
        items: audioSources,
        initialIndex: startWith == null ? null : songs.indexOf(startWith),
      );
      return player.play();
    }

    await player.stop();
    await playlist.clear();
    return queue(songs, startWith: startWith);
  }

  FutureOr<int?> getStartIndex(SongModel? song) async {
    if (song == null) {
      return null;
    }

    final playlist = getPlaylist();

    if (playlist == null) {
      return null;
    }

    final playlistItems = await getPlaylistSongs(playlist.sequence);

    if (playlistItems.isEmpty) {
      return null;
    }

    final startIndex = playlistItems.indexOf(song);

    if (startIndex < 0 || startIndex >= playlistItems.length) {
      return null;
    }

    return startIndex;
  }

  UriAudioSource createAudioSource(SongModel song) {
    return AudioSource.uri(
      Uri.parse(song.data),
      tag: MediaItem(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist,
        album: song.album,
        genre: song.genre,
      ),
    );
  }

  ConcatenatingAudioSource? getPlaylist() {
    final player = ref.read(audioPlayerProvider);
    final audioSource = player.audioSource;

    if (audioSource == null) {
      return null;
    }

    if (audioSource is! ConcatenatingAudioSource) {
      return null;
    }

    return audioSource;
  }

  FutureOr<List<SongModel>> getPlaylistSongs(
    List<IndexedAudioSource> sequence,
  ) async {
    if (sequence.isEmpty) {
      return [];
    }

    final songIds = await Future.wait(
      sequence.map(
        (audioSource) async {
          final mediaItem = audioSource.tag as MediaItem;
          final mediaId = mediaItem.id;
          return mediaId;
        },
      ),
    );

    final intIds = songIds.map(int.parse).toList();

    final mappedSongs = await ref.read(mappedSongsProvider.future);

    final foundSongs =
        intIds.map((id) => mappedSongs[id]).whereType<SongModel>().toList();

    return foundSongs;
  }

  FutureOr<ConcatenatingAudioSource> createAndLoadPlaylist({
    List<AudioSource>? items,
    int? initialIndex,
    Duration? initialPosition,
  }) async {
    final player = ref.watch(audioPlayerProvider);
    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: items ?? [],
    );
    // Load the playlist
    await player.setAudioSource(
      playlist,
      initialIndex: initialIndex ?? 0,
      initialPosition: initialPosition ?? Duration.zero,
    );

    return playlist;
  }
}
