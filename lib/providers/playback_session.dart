part of 'providers.dart';

/// A snapshot of the player queue, enough to continue where playback stopped.
class _PlaybackSnapshot {
  const _PlaybackSnapshot({
    required this.songIds,
    required this.shuffleOrder,
    required this.index,
    required this.position,
    required this.loopMode,
    required this.shuffleEnabled,
  });

  final List<int> songIds;
  final List<int> shuffleOrder;
  final int index;
  final Duration position;
  final LoopMode loopMode;
  final bool shuffleEnabled;

  Map<String, dynamic> toJson() => {
        'songIds': songIds,
        'shuffleOrder': shuffleOrder,
        'index': index,
        'positionMs': position.inMilliseconds,
        'loopMode': loopMode.index,
        'shuffleEnabled': shuffleEnabled,
      };

  static _PlaybackSnapshot? fromJson(Map<String, dynamic> json) {
    try {
      return _PlaybackSnapshot(
        songIds: (json['songIds'] as List).cast<int>(),
        shuffleOrder: (json['shuffleOrder'] as List).cast<int>(),
        index: json['index'] as int,
        position: Duration(milliseconds: json['positionMs'] as int),
        loopMode: LoopMode.values[json['loopMode'] as int],
        shuffleEnabled: json['shuffleEnabled'] as bool,
      );
    } catch (_) {
      // A snapshot written by an older or damaged version is ignored.
      return null;
    }
  }
}

/// A [ShuffleOrder] that starts from a saved order instead of a random one.
///
/// just_audio clears the order and calls `insert(0, length)` when the sources
/// are set, so the saved order is applied on that first insert.
class _RestoredShuffleOrder extends DefaultShuffleOrder {
  _RestoredShuffleOrder(this._restored);

  List<int>? _restored;

  @override
  void insert(int index, int count) {
    final restored = _restored;
    if (restored != null &&
        indices.isEmpty &&
        index == 0 &&
        count == restored.length) {
      indices.addAll(restored);
      _restored = null;
      return;
    }
    super.insert(index, count);
  }
}

const _sessionSaveDebounce = Duration(milliseconds: 500);
const _sessionPositionInterval = Duration(seconds: 5);

/// Restores the last queue into the player (paused), then keeps saving it.
///
/// Must be awaited at startup after Isar and shared preferences are ready.
@Riverpod(keepAlive: true)
Future<void> playbackSession(PlaybackSessionRef ref) async {
  final player = ref.watch(audioPlayerProvider);
  final prefs = ref.read(sharedPreferencesProvider).requireValue;
  final isar = ref.read(isarProvider).requireValue;

  await _restoreSession(player, prefs, isar);

  _PlaybackSnapshot? snapshot() {
    final sequence = player.sequence;
    final index = player.currentIndex;
    if (sequence.isEmpty || index == null) return null;

    return _PlaybackSnapshot(
      songIds: sequence.map(songIdOf).toList(),
      shuffleOrder: List.of(player.shuffleIndices),
      index: index,
      position: player.position,
      loopMode: player.loopMode,
      shuffleEnabled: player.shuffleModeEnabled,
    );
  }

  Future<void> save() async {
    final current = snapshot();
    if (current == null) {
      await prefs.remove(playbackSessionPrefsKey);
      return;
    }
    await prefs.setString(playbackSessionPrefsKey, json.encode(current));
  }

  Timer? debounce;
  void saveSoon() {
    debounce?.cancel();
    debounce = Timer(_sessionSaveDebounce, save);
  }

  final subscriptions = [
    player.sequenceStream.listen((_) => saveSoon()),
    player.currentIndexStream.listen((_) => saveSoon()),
    player.shuffleIndicesStream.listen((_) => saveSoon()),
    player.loopModeStream.listen((_) => saveSoon()),
    player.shuffleModeEnabledStream.listen((_) => saveSoon()),
    // Pausing or stopping is when the position is most worth keeping.
    player.playingStream.listen((_) => saveSoon()),
  ];
  final positionTimer = Timer.periodic(_sessionPositionInterval, (_) {
    if (player.playing) save();
  });

  ref.onDispose(() {
    debounce?.cancel();
    positionTimer.cancel();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  });
}

Future<void> _restoreSession(
  AudioPlayer player,
  SharedPreferences prefs,
  Isar isar,
) async {
  final raw = prefs.getString(playbackSessionPrefsKey);
  if (raw == null) return;

  final snapshot = _PlaybackSnapshot.fromJson(json.decode(raw));
  if (snapshot == null || snapshot.songIds.isEmpty) return;

  final found = await isar.songs.getAll(snapshot.songIds);

  // Songs deleted since the snapshot are dropped, and the saved positions are
  // renumbered to match the shorter queue.
  final newIndexOf = <int, int>{};
  final songs = <Song>[];
  for (var i = 0; i < found.length; i++) {
    final song = found[i];
    if (song == null) continue;
    newIndexOf[i] = songs.length;
    songs.add(song);
  }
  if (songs.isEmpty) return;

  for (final song in songs) {
    await song.artist.load();
    await song.album.load();
    await song.genre.load();
  }

  final currentSurvived = newIndexOf.containsKey(snapshot.index);
  final shuffleOrder = snapshot.shuffleOrder
      .where(newIndexOf.containsKey)
      .map((i) => newIndexOf[i]!)
      .toList();

  await player.setAudioSources(
    songs.map(songToAudioSource).toList(),
    preload: false,
    initialIndex: currentSurvived ? newIndexOf[snapshot.index] : 0,
    initialPosition: currentSurvived ? snapshot.position : Duration.zero,
    shuffleOrder: shuffleOrder.length == songs.length
        ? _RestoredShuffleOrder(shuffleOrder)
        : null,
  );
  await player.setLoopMode(snapshot.loopMode);
  await player.setShuffleModeEnabled(snapshot.shuffleEnabled);
}
