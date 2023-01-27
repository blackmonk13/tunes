import 'package:drift/drift.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/database/tables.dart';

part 'albums.g.dart';

@DriftAccessor(tables: [Albums])
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

  Future<void> addAlbums(List<AlbumsCompanion> newAlbums) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(albums, newAlbums);
      },
    );
  }
}
