part of providers;

final songsProvider = Provider<List<Tune>>(
  (ref) {
    final songstream = ref.watch(songsListProvider);
    final songs = songstream.valueOrNull;
    if (songs == null) {
      return [];
    }
    songs.sort((a, b) {
      return a.file.lastModifiedSync().compareTo(b.file.lastModifiedSync());
    });
    
    return songs.reversed.toList();
  },
);

final artistsProvider = Provider<Map<String, List<Tune>>>(
  (ref) {
    final songs = ref.watch(songsProvider);
    final unsortedArtists = groupBy(
      songs,
      (tune) {
        final artist = getArtist(tune);

        if (artist == null) {
          return "Unknown";
        }

        return artist;
      },
    );
    final sortedArtists = Map.fromEntries(unsortedArtists.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)));
    return sortedArtists;
  },
);

final albumsProvider = Provider<Map<String, List<Tune>>>(
  (ref) {
    final songs = ref.watch(songsProvider);
    final albums = groupBy(songs, (tune) {
      final album = getAlbum(tune);
      if (album == null) {
        return "Unknown";
      }
      return album;
    });
    return albums;
  },
);

final songStreamProvider = StreamProvider<Tune>(
  (ref) async* {
    ref.watch(mediaPathsProvider);
    final mediaPaths = await getMediaPaths();
    await for (final value in getMusic(mediaPaths)) {
      final tagData = await getTags(value.path);
      final artData = await getArtwork(value.path);
      final tune = Tune(
        filePath: value.path,
        artWork: artData,
        tag: tagData,
      );
      yield tune;
    }
  },
);

final 
songsListProvider = StreamProvider<List<Tune>>(
  (ref) async* {
    ref.watch(mediaPathsProvider);
    List<Tune> allSongs = [];
    final mediaPaths = await getMediaPaths();
    await for (final value in getMusic(mediaPaths)) {
      final tagData = await getTags(value.path);
      final artData = await getArtwork(value.path);
      final tune = Tune(
        filePath: value.path,
        artWork: artData,
        tag: tagData,
      );
      allSongs.add(tune);
      yield allSongs;
    }
  },
);

final multiSelectSongsProvider = StateProvider.autoDispose<bool>(
  (ref) {
    return false;
  },
);

class SelectedSongsNotifier extends StateNotifier<List<Tune>> {
  SelectedSongsNotifier() : super([]);

  void add(Tune tune) {
    if (state.contains(tune)) {
      remove(tune);
      return;
    }
    state = [...state, tune];
  }

  void remove(Tune tune) {
    final withoutTune = state.where((element) => element != tune);
    state = [...withoutTune];
  }

  void clear() {
    state = [];
  }

  void addAll(List<Tune> tunes) {
    tunes = tunes.where((element) => !state.contains(element)).toList();
    state = tunes;
  }
}

final selectedSongsProvider =
    StateNotifierProvider.autoDispose<SelectedSongsNotifier, List<Tune>>(
  (ref) {
    return SelectedSongsNotifier();
  },
);