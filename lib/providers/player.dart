part of 'providers.dart';

@Riverpod(keepAlive: true)
AudioPlayer audioPlayer(Ref ref) {
  return AudioPlayer();
}

@Riverpod(keepAlive: true)
class PlaylistController extends _$PlaylistController {
  @override
  ConcatenatingAudioSource build() {
    return ConcatenatingAudioSource(
      children: [],
    );
  }

  void addSong(TuneSong song) {
    final songTitle =
        song.songInfo.title ?? basenameWithoutExtension(song.songInfo.pathname);
    final mediaItem = MediaItem(
      id: song.songInfo.id.toString(),
      title: songTitle,
      album: song.albumInfo?.name,
      artist: song.artistInfo?.name,
      extras: {
        'song': song,
      },
    );

    final audioSource = AudioSource.file(
      song.songInfo.pathname,
      tag: mediaItem,
    );

    state.add(audioSource);
  }
}

@Riverpod(keepAlive: true)
Stream<Duration> playerPosition(Ref ref) {
  final player = ref.watch(audioPlayerProvider);

  return player.positionStream;
}

@Riverpod(keepAlive: true)
Stream<bool> playerPlaying(PlayerPlayingRef ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.playingStream;
}

@Riverpod(keepAlive: true)
Stream<List<IndexedAudioSource>?> playlistSequence(Ref ref) {
  return ref.watch(audioPlayerProvider).sequenceStream;
}

@Riverpod(keepAlive: true)
Stream<int?> playerCurrentIndex(Ref ref) {
  return ref.watch(audioPlayerProvider).currentIndexStream;
}

@Riverpod(keepAlive: true)
Stream<PlayerState> playerState(Ref ref) {
  return ref.watch(audioPlayerProvider).playerStateStream;
}

@Riverpod(keepAlive: true)
Stream<AudioSource?> playerNowPlaying(Ref ref) async* {
  final index = await ref.watch(playerCurrentIndexProvider.future);
  final sequence = await ref.watch(playlistSequenceProvider.future);

  if (index == null || sequence == null) {
    yield null;
    return;
  }

  final indexedAudio = sequence.elementAt(index);
  
  yield indexedAudio;
}
