part of providers;

final playpositionProvider = StreamProvider<Duration>(
  (ref) async* {
    await for (final value in player.currentPosition) {
      yield value;
    }
  },
);

final playIdProvider = StreamProvider<int?>(
  (ref) async* {
    await for (final value in player.audioSessionId) {
      yield value;
    }
  },
);

final playerStateProvider = StreamProvider<PlayerState>(
  (ref) async* {
    await for (final value in player.playerState) {
      yield value;
    }
  },
);

final nowPlayingStreamProvider = StreamProvider<Audio?>(
  (ref) async* {
    await for (final value in player.current) {
      yield value?.audio.audio;
    }
  },
);

final nowPlayingProvider = Provider<Audio?>(
  (ref) {
    final nowStream = ref.watch(nowPlayingStreamProvider);

    return nowStream.valueOrNull;
  },
);
