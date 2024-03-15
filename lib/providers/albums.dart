part of providers;

@riverpod
class PagedTuneAlbums extends _$PagedTuneAlbums {
  @override
  FutureOr<List<TuneAlbum>> build() {
    return [];
  }

  FutureOr<List<TuneAlbum>> fetchAlbums({
    SortCriteria? sortCriteria,
    int? limit,
    int? offset,
  }) async {
    final albumsDao = ref.watch(databaseProvider).albumsDao;

    if (sortCriteria == null) {
      return albumsDao.tuneAlbumsForFilter(
        limit: limit,
        offset: offset,
      );
    }

    final sortMode = sortCriteria.mode;
    final sortKey = sortCriteria.key;

    List<OrderingTerm Function($AlbumsTable)> clauses = [
      (tbl) {
        final skmap = {
          'name': tbl.name,
          'artist': tbl.artist,
        };

        final expression = skmap[sortKey] ?? tbl.name;

        return OrderingTerm(
          expression: expression,
          mode: sortMode,
        );
      }
    ];

    return albumsDao.tuneAlbumsForFilter(
      clauses: clauses,
      limit: limit,
      offset: offset,
    );
  }
}
