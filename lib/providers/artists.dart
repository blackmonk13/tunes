part of 'providers.dart';

@riverpod
class PagedTuneArtists extends _$PagedTuneArtists {
  @override
  FutureOr<List<TuneArtist>> build() {
    return [];
  }

  FutureOr<List<TuneArtist>> fetchArtists({
    SortCriteria? sortCriteria,
    int? limit,
    int? offset,
  }) async {
    final artistsDao = ref.watch(databaseProvider).artistsDao;

    if (sortCriteria == null) {
      return artistsDao.tuneArtistsForFilter(
        limit: limit,
        offset: offset,
      );
    }
    final sortMode = sortCriteria.mode;
    final sortKey = sortCriteria.key;

    List<OrderingTerm Function($ArtistsTable)> clauses = [
      (tbl) {
        final skmap = {
          'name': tbl.name,
        };
        final expression = skmap[sortKey] ?? tbl.name;

        return OrderingTerm(
          expression: expression,
          mode: sortMode,
        );
      }
    ];
    return artistsDao.tuneArtistsForFilter(
      clauses: clauses,
      limit: limit,
      offset: offset,
    );
  }
}
