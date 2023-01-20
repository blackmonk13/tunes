part of providers;

class PlaylistItemsNotifier extends StateNotifier<List<UriAudioSource>> {
  final Ref ref;
  PlaylistItemsNotifier(this.ref) : super([]);

  void add(UriAudioSource item) {
    state = [...state, item];
  }

  void addAll(List<UriAudioSource> items) {
    state = [...items];
  }

  void clear() {
    state = [];
  }
}

final playlistItemsProvider =
    StateNotifierProvider<PlaylistItemsNotifier, List<UriAudioSource>>(
  (ref) {
    return PlaylistItemsNotifier(ref);
  },
);

final playlistProvider = Provider<ConcatenatingAudioSource>(
  (ref) {
    final playlistItems = ref.watch(playlistItemsProvider);

    return ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: playlistItems,
    );
  },
);