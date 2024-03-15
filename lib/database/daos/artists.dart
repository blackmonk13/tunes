part of 'daos.dart';

@DriftAccessor(
  tables: [
    Artists,
  ],
)
class ArtistsDao extends DatabaseAccessor<TunesDatabase>
    with _$ArtistsDaoMixin {
  ArtistsDao(super.db);

  // returns the generated id
  Future<int> addArtist(ArtistsCompanion entry) {
    return into(artists).insert(
      entry,
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<Artist?> artistByName(String name) async {
    final query = artistsQueryForFilter(
      filter: (element) {
        return element.name.trim().lower().equals(
              name.trim().toLowerCase(),
            );
      },
      limit: 1,
    );

    return query.getSingleOrNull();
  }

  Future<List<Artist>> artistsForFilter({
    List<OrderingTerm Function($ArtistsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = artistsQueryForFilter(
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return query.get();
  }

  Future<List<TuneArtist>> tuneArtistsForFilter({
    Expression<bool> Function($ArtistsTable)? filter,
    List<OrderingTerm Function($ArtistsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = tuneArtistsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return query.get();
  }

  Future<TuneArtist?> tuneArtistForId(int artistId) {
    final query = tuneArtistsQueryForFilter(
      filter: (tbl) => tbl.id.equals(artistId),
      limit: 1,
    );

    return (query).getSingleOrNull();
  }

  Selectable<TuneArtist> tuneArtistsQueryForFilter({
    Expression<bool> Function($ArtistsTable)? filter,
    List<OrderingTerm Function($ArtistsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = artistsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return (query).join(
      [
        leftOuterJoin(
          covers,
          covers.id.equalsExp(artists.artwork),
        ),
      ],
    ).map(
      (row) {
        final artist = row.readTable(artists);
        final cover = row.readTableOrNull(covers);

        return TuneArtist(
          artist: artist,
          cover: cover,
        );
      },
    );
  }

  SimpleSelectStatement<$ArtistsTable, Artist> artistsQueryForFilter({
    Expression<bool> Function($ArtistsTable)? filter,
    List<OrderingTerm Function($ArtistsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    SimpleSelectStatement<$ArtistsTable, Artist> query = select(artists);

    if (filter != null) {
      query = query..where(filter);
    }

    if (clauses.isNotEmpty) {
      query = query..orderBy(clauses);
    }

    if (limit != null) {
      query = query..limit(limit, offset: offset);
    }

    if (clauses.isNotEmpty) {
      query = query..orderBy(clauses);
    }

    return query;
  }
}
