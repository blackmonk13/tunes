part of providers;

final playpositionProvider = StreamProvider<Duration>(
  (ref) async* {
    await for (final value in player.positionStream) {
      yield value;
    }
  },
);

final playIdProvider = StreamProvider<int?>(
  (ref) async* {
    await for (final value in player.currentIndexStream) {
      yield value;
    }
  },
);

final playerStateProvider = StreamProvider<PlayerState>(
  (ref) async* {
    await for (final value in player.playerStateStream) {
      yield value;
    }
  },
);

final nowPlayingProvider = Provider<Tune?>(
  (ref) {
    ref.watch(playIdProvider);
    ref.watch(playpositionProvider);
    final songStream = ref.watch(songsProvider);
    final playlist = ref.watch(playlistProvider);

    if (player.audioSource != playlist) {
      print("Not a playlist");
      return null;
    }

    if (playlist.children.isEmpty) {
      return null;
    }

    final playingNowId = player.currentIndex;
    if (playingNowId == null) {
      return null;
    }

    final playingNowAs =
        playlist.children.elementAt(playingNowId) as ProgressiveAudioSource;
    final playingNowPath = playingNowAs.uri.toFilePath();
    final findPlayingNowTune =
        songStream.where((element) => element.filePath == playingNowPath);
    if (findPlayingNowTune.isEmpty) {
      return null;
    }

    final playingNowTune = findPlayingNowTune.first;
    return playingNowTune;
  },
);