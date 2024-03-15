import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tunes/database/daos/daos.dart';
// import 'package:tunes/database/daos/daos.dart';
import 'package:tunes/database/tables.dart';
import 'package:tunes/database/views/songs.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Songs,
    Covers,
    Artists,
    Albums,
    Playlists,
    PlaylistSongs,
  ],
  daos: [
    SongsDao,
    ArtistsDao,
    AlbumsDao,
    // CoversDao,
    // PlaylistsDao,
  ],
  views: [SongsCount]
)
class TunesDatabase extends _$TunesDatabase {
  TunesDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy();
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
