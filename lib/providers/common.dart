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