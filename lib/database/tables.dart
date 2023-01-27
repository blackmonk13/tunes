import 'package:drift/drift.dart';

class Tunes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pathname => text().unique()();
  TextColumn get title => text().nullable()();
  IntColumn get artist => integer().nullable().references(Artists, #id)();
  IntColumn get album => integer().nullable().references(Albums, #id)();
  IntColumn get artwork => integer().nullable().references(Covers, #id)();
  DateTimeColumn get modified => dateTime()();
}

class Covers extends Table {
  IntColumn get id => integer().autoIncrement()();
  BlobColumn get art => blob().nullable()();
}

class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
}
