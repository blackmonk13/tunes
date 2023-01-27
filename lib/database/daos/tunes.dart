import 'package:drift/drift.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/database/tables.dart';

part 'tunes.g.dart';

@DriftAccessor(tables: [Tunes])
class TunesDao extends DatabaseAccessor<TunesDb> with _$TunesDaoMixin {
  TunesDao(TunesDb db) : super(db);

  Future<List<Tune>> get allTuneEntries {
    return (select(tunes)
          ..orderBy(
            [
              (tune) => OrderingTerm(
                    expression: tune.modified,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .get();
  }

  Stream<List<Tune>> get streamedTunes => select(tunes).watch();

  Stream<List<Tune>> tunesForArtist(int artistId) {
    return (select(tunes)
          ..where(
            (tbl) => tbl.artist.equals(artistId),
          )
          ..orderBy(
            [
              (tune) => OrderingTerm(
                    expression: tune.modified,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .watch();
  }

  Stream<List<Tune>> tunesForAlbum(int albumId) {
    return (select(tunes)
          ..where(
            (tbl) => tbl.album.equals(albumId),
          )
          ..orderBy(
            [
              (tune) => OrderingTerm(
                    expression: tune.modified,
                    mode: OrderingMode.desc,
                  )
            ],
          ))
        .watch();
  }

  Future<Tune> tuneByPath(String filePath) {
    return (select(tunes)..where((tune) => tune.pathname.equals(filePath)))
        .getSingle();
  }

  Future<void> addTunes(List<TunesCompanion> songs) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(tunes, songs);
      },
    );
  }

  Future<int> updateTune(String pathname, TunesCompanion tune) async {
    return (update(tunes)..where((tbl) => tbl.pathname.equals(pathname)))
        .write(tune);
  }
}
