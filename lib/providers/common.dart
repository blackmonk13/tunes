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
      final playlist = await createAndLoadPlaylist();
      return getPlaylistSongs(playlist.sequence);
    }

    return getPlaylistSongs(audioSequence);
  }

  Future<void> addSong(SongModel song) async {
    final player = ref.watch(audioPlayerProvider);
    final audioSource = player.audioSource;

    if (audioSource == null) {
      return;
    }

    if (audioSource is! ConcatenatingAudioSource) {
      return;
    }

    // Play song
    final songAudioSource = AudioSource.uri(
      Uri.parse(song.data),
      tag: MediaItem(
        id: song.id.toString(),
        title: song.title,
        artist: song.artist,
        album: song.album,
        genre: song.genre,
      ),
    );

    await audioSource.add(songAudioSource);

    if (player.playing) {
      return;
    }

    return player.play();
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

  FutureOr<ConcatenatingAudioSource> createAndLoadPlaylist() async {
    final player = ref.watch(audioPlayerProvider);
    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: [],
    );
    // Load the playlist
    await player.setAudioSource(
      playlist,
      initialIndex: 0,
      initialPosition: Duration.zero,
    );

    return playlist;
  }
}
