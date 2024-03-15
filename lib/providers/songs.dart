part of providers;

@riverpod
class TuneSongs extends _$TuneSongs {
  @override
  Stream<List<TuneSong>> build() {
    return ref.watch(databaseProvider).songsDao.tuneSongsStreamForFilter();
  }
}

@riverpod
class PagedTuneSongs extends _$PagedTuneSongs {
  @override
  FutureOr<List<TuneSong>> build() {
    return [];
  }

  FutureOr<List<TuneSong>> fetchSongs({
    SortCriteria? sortCriteria,
    int? limit,
    int? offset,
  }) async {
    final songsDao = ref.watch(databaseProvider).songsDao;
    if (sortCriteria == null) {
      return songsDao.tuneSongsForFilter(
        limit: limit,
        offset: offset,
      );
    }
    final sortMode = sortCriteria.mode;
    final sortKey = sortCriteria.key;

    List<OrderingTerm Function($SongsTable)> clauses = [
      (tbl) {
        final skmap = {
          'title': tbl.title,
          'artist': tbl.artist,
          'album': tbl.album,
          'modified': tbl.modified,
          'play_count': tbl.playCount,
          'liked': tbl.liked,
          'lastPlayed': tbl.lastPlayed,
        };
        final expression = skmap[sortKey] ?? tbl.modified;

        return OrderingTerm(
          expression: expression,
          mode: sortMode,
        );
      }
    ];

    return songsDao.tuneSongsForFilter(
      clauses: clauses,
      limit: limit,
      offset: offset,
    );
  }
}

@riverpod
FutureOr<TuneSong?> tuneSongWithPath(
  TuneSongWithPathRef ref,
  String pathname,
) {
  return ref.watch(databaseProvider).songsDao.tuneSongForPath(pathname);
}
