part of 'daos.dart';

@DriftAccessor(
  tables: [
    Songs,
  ],
)
class SongsDao extends DatabaseAccessor<TunesDatabase> with _$SongsDaoMixin {
  SongsDao(super.db);

  // returns the generated id
  Future<int> addSong(SongsCompanion entry) {
    return into(songs).insert(
      entry,
      mode: InsertMode.insertOrIgnore,
    );
  }

  Stream<List<TuneSong>> tuneSongsStreamForFilter({
    Expression<bool> Function($SongsTable)? filter,
    List<OrderingTerm Function($SongsTable)> clauses = const [],
  }) {
    final query = tuneSongsQueryForFilter(
      filter: filter,
      clauses: clauses,
    );

    return (query).watch();
  }

  Future<List<TuneSong>> tuneSongsForFilter({
    Expression<bool> Function($SongsTable)? filter,
    List<OrderingTerm Function($SongsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = tuneSongsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return (query).get();
  }

  Future<TuneSong?> tuneSongForPath(
    String pathname,
  ) {
    final query = tuneSongQueryForFilter(
      filter: (tbl) {
        return tbl.pathname.equals(pathname);
      },
    );

    return (query).getSingleOrNull();
  }

  Selectable<TuneSong> tuneSongQueryForFilter({
    Expression<bool> Function($SongsTable)? filter,
  }) {
    return tuneSongsQueryForFilter(
      filter: filter,
      limit: 1,
    );
  }

  Selectable<TuneSong> tuneSongsQueryForFilter({
    Expression<bool> Function($SongsTable)? filter,
    List<OrderingTerm Function($SongsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = songsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return (query).join([
      leftOuterJoin(
        artists,
        artists.id.equalsExp(songs.artist),
      ),
      leftOuterJoin(
        albums,
        albums.id.equalsExp(songs.album),
      ),
      leftOuterJoin(
        covers,
        covers.id.equalsExp(songs.artwork),
      ),
    ]).map((row) {
      final tune = row.readTable(songs);
      final artist = row.readTableOrNull(artists);
      final album = row.readTableOrNull(albums);
      final cover = row.readTableOrNull(covers);

      return TuneSong(
        songInfo: tune,
        artistInfo: artist,
        albumInfo: album,
        artworkInfo: cover,
      );
    });
  }

  SimpleSelectStatement<$SongsTable, Song> songsQueryForFilter({
    Expression<bool> Function($SongsTable)? filter,
    List<OrderingTerm Function($SongsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    SimpleSelectStatement<$SongsTable, Song> query = select(songs);

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
