part of providers;

class PlaylistItemsNotifier extends StateNotifier<List<Audio>> {
  final Ref ref;
  PlaylistItemsNotifier(this.ref) : super([]);

  void add(Audio item) {
    state = [...state, item];
  }

  void addAll(List<Audio> items) {
    state = [...items];
  }

  void clear() {
    state = [];
  }
}

final playlistItemsProvider =
    StateNotifierProvider<PlaylistItemsNotifier, List<Audio>>(
  (ref) {
    return PlaylistItemsNotifier(ref);
  },
);

final playlistProvider = Provider<Playlist>(
  (ref) {
    final playlistItems = ref.watch(playlistItemsProvider);
    return Playlist(
      audios: playlistItems,
    );
  },
);

@riverpod
class NowPlayingPlaylist extends _$NowPlayingPlaylist {
  @override
  Playlist build() {
    final defaultPlaylist = Playlist(
      audios: [],
    );
    return defaultPlaylist;
  }

  void changePlayList(Playlist playlist) {
    state = playlist;
  }

  void clearPlaylist() {
    state = state.copyWith(audios: []);
  }
}
