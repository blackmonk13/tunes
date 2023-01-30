part of providers;

final scannedItemsProvider = StreamProvider<int>(
  (ref) async* {
    final tunesRepo = ref.watch(tunesRepositoryProvider);
    await for (final itemCount in tunesRepo.fsCount()) {
      yield itemCount;
    }
  },
);
final songsStreamProvider = StreamProvider<List<Tune>>(
  (ref) {
    return ref.watch(tunesRepositoryProvider).streamedTunes();
  },
);

final songsSortModeProvider = StateProvider<OrderingMode>(
  (ref) {
    return OrderingMode.asc;
  },
);

final songsSortKeyProvider = StateProvider<String>(
  (ref) {
    return 'date';
  },
);

final songsProvider = StreamProvider<List<Audio>>(
  (ref) async* {
    final tunesRepo = ref.watch(tunesRepositoryProvider);
    final sortMode = ref.watch(songsSortModeProvider);
    final sortKey = ref.watch(songsSortKeyProvider);
    List<OrderingTerm Function($TunesTable)> clauses = [
      (tbl) {
        final skmap = {
          'title': tbl.title,
          'artist': tbl.artist,
          'album': tbl.album,
        };
        final expression = skmap[sortKey] ?? tbl.modified;
        return OrderingTerm(
          expression: expression,
          mode: sortMode,
        );
      }
    ];
    await for (final value in tunesRepo.streamedTunes(clauses: clauses)) {
      yield await Future.wait(
        value.map(
          (dbt) async {
            return await tunesRepo.audioFromTune(dbt);
          },
        ).toList(),
      );
    }
  },
);

@riverpod
FutureOr<Audio> tuneAudio(TuneAudioRef ref, {required Tune tune}) {
  final tunesRepo = ref.watch(tunesRepositoryProvider);
  return tunesRepo.audioFromTune(tune);
}

final artistsProvider = StreamProvider<List<Artist>>(
  (ref) => ref.watch(databaseProvider).artistsDao.streamedArtists,
);

final artistSongsProvider = StreamProvider.family<List<Audio>, int>(
  (ref, id) async* {
    final tunesRepo = ref.watch(tunesRepositoryProvider);
    final streamedArtistTunes =
        ref.watch(databaseProvider).tunesDao.tunesForArtist(id);

    await for (final value in streamedArtistTunes) {
      yield await Future.wait(
        value.map(
          (dbt) async {
            return await tunesRepo.audioFromTune(dbt);
          },
        ).toList(),
      );
    }
  },
);

final albumsProvider = StreamProvider<List<Album>>(
  (ref) => ref.watch(databaseProvider).albumsDao.streamedAlbums,
);

final albumSongsProvider = StreamProvider.family<List<Audio>, int>(
  (ref, id) async* {
    final tunesRepo = ref.watch(tunesRepositoryProvider);
    final streamedAlbumTunes =
        ref.watch(databaseProvider).tunesDao.tunesForAlbum(id);
    await for (final value in streamedAlbumTunes) {
      yield await Future.wait(
        value.map(
          (dbt) async {
            return await tunesRepo.audioFromTune(dbt);
          },
        ).toList(),
      );
    }
  },
);

final multiSelectSongsProvider = StateProvider.autoDispose<bool>(
  (ref) {
    return false;
  },
);

@riverpod
class SelectedSongs extends _$SelectedSongs {
  @override
  List<Audio> build() {
    return [];
  }

  void add(Audio tune) {
    if (state.contains(tune)) {
      remove(tune);
      return;
    }
    state = [...state, tune];
  }

  void remove(Audio tune) {
    final withoutTune = state.where((element) => element != tune);
    state = [...withoutTune];
  }

  void clear() {
    state = [];
  }

  void addAll(List<Audio> tunes) {
    tunes = tunes.where((element) => !state.contains(element)).toList();
    state = tunes;
  }
}
