part of tunesdbdaos;

@DriftAccessor(tables: [Albums, Tunes])
class AlbumsDao extends DatabaseAccessor<TunesDb> with _$AlbumsDaoMixin {
  AlbumsDao(TunesDb db) : super(db);
  Future<List<Album>> get allAlbums {
    return (select(albums)
          ..orderBy(
            [
              (ats) => OrderingTerm(
                    expression: ats.name,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .get();
  }

  Stream<List<Album>> get streamedAlbums {
    return (select(albums)
          ..orderBy(
            [
              (ats) => OrderingTerm(
                    expression: ats.name,
                  )
            ],
          ))
        .watch();
  }

  Future<Album> albumById(int id) async {
    return (select(albums)
          ..where((element) => element.id.equals(id))
          ..limit(1))
        .getSingle();
  }

  Future<Album?> albumByName(String name) async {
    return (select(albums)
          ..where((element) => element.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> addAlbum(AlbumsCompanion entry) {
    return into(albums).insert(entry);
  }

  Future<void> addAlbums(List<AlbumsCompanion> newAlbums) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(albums, newAlbums);
      },
    );
  }

  Future<void> deleteAlbum(Album albm) async {
    return transaction(() async {
      await (update(tunes)..where((row) => row.album.equals(albm.id)))
        .write(const TunesCompanion(album: Value(null)));
      await delete(albums).delete(albm);
    });
  }
}
