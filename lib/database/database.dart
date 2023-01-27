import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tunes/database/daos/albums.dart';
import 'package:tunes/database/daos/artists.dart';
import 'package:tunes/database/daos/covers.dart';
import 'package:tunes/database/daos/tunes.dart';
import 'package:tunes/database/tables.dart';

part 'database.g.dart';

@DriftDatabase(
    tables: [Tunes, Covers, Artists, Albums],
    daos: [TunesDao, ArtistsDao, AlbumsDao, CoversDao])
class TunesDb extends _$TunesDb {
  TunesDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy();
  }

  Future<void> resetTunes() async {
    return transaction(() async {
      await covers.deleteAll();
      await albums.deleteAll();
      await artists.deleteAll();
      await tunes.deleteAll();
      return;
    });
  }

  Future<int> deleteTunes(List<String> filePaths) async {
    return transaction(
      () async {
        return tunes.deleteWhere(
          (tbl) => tbl.pathname.isIn(filePaths),
        );
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(
    () async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));

      return NativeDatabase.createInBackground(file);
    },
  );
}
