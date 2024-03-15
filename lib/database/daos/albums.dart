part of 'daos.dart';

@DriftAccessor(
  tables: [
    Albums,
  ],
)
class AlbumsDao extends DatabaseAccessor<TunesDatabase> with _$AlbumsDaoMixin {
  AlbumsDao(super.db);

  // returns the generated id
  Future<int> addAlbum(AlbumsCompanion entry) {
    return into(albums).insert(
      entry,
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<List<Album>> albumsForFilter({
    Expression<bool> Function($AlbumsTable)? filter,
    List<OrderingTerm Function($AlbumsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = albumsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return query.get();
  }

  Future<List<TuneAlbum>> tuneAlbumsForFilter({
    Expression<bool> Function($AlbumsTable)? filter,
    List<OrderingTerm Function($AlbumsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = tuneAlbumsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return query.get();
  }

  Selectable<TuneAlbum> tuneAlbumsQueryForFilter({
    Expression<bool> Function($AlbumsTable)? filter,
    List<OrderingTerm Function($AlbumsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    final query = albumsQueryForFilter(
      filter: filter,
      clauses: clauses,
      limit: limit,
      offset: offset,
    );

    return (query).join([
      leftOuterJoin(
        covers,
        covers.id.equalsExp(albums.artwork),
      ),
      leftOuterJoin(
        artists,
        artists.id.equalsExp(albums.artist),
      ),
    ]).map((row) {
      final album = row.readTable(albums);
      final cover = row.readTableOrNull(covers);
      final artist = row.readTableOrNull(artists);

      return TuneAlbum(
        album: album,
        cover: cover,
        artist: artist,
      );
    });
  }

  SimpleSelectStatement<$AlbumsTable, Album> albumsQueryForFilter({
    Expression<bool> Function($AlbumsTable)? filter,
    List<OrderingTerm Function($AlbumsTable)> clauses = const [],
    int? limit,
    int? offset,
  }) {
    SimpleSelectStatement<$AlbumsTable, Album> query = select(albums);

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