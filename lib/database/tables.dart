import 'package:drift/drift.dart';

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pathname => text().unique()();
  TextColumn get title => text().nullable()();
  BoolColumn get liked => boolean().withDefault(const Constant(false))();
  IntColumn get artist => integer().nullable().references(Artists, #id)();
  IntColumn get album => integer().nullable().references(Albums, #id)();
  IntColumn get artwork => integer().nullable().references(Covers, #id)();
  DateTimeColumn get modified => dateTime()();
  DateTimeColumn get lastPlayed => dateTime().nullable()();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
}

class Covers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pathname => text().unique()();
  TextColumn get byteshash => text().unique()();
}

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withDefault(const Constant("Unknown")).unique()();
  IntColumn get artwork => integer().nullable().references(Covers, #id)();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withDefault(const Constant("Unknown")).unique()();
  IntColumn get artist => integer().nullable().references(Artists, #id)();
  IntColumn get artwork => integer().nullable().references(Covers, #id)();
}

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withDefault(currentDateAndTime.datetime).unique()();
  DateTimeColumn get modified => dateTime().withDefault(currentDateAndTime)();
}

class PlaylistSongs extends Table {
  IntColumn get tuneId => integer().references(Songs, #id)();
  IntColumn get playlistId => integer().references(Playlists, #id)();

  @override
  Set<Column> get primaryKey => {tuneId, playlistId};
}
