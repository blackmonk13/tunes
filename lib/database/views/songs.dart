import 'package:drift/drift.dart';
import 'package:tunes/database/tables.dart';

abstract class SongsCount extends View {
  // Getters define the tables that this view is reading from.
  Songs get songs;

  // Custom expressions can be given a name by defining them as a getter:.
  Expression<int> get itemCount => songs.id.count();

  @override
  Query as() =>
      // Views can select columns defined as expression getters on the class, or
      // they can reference columns from other tables.
      select([itemCount]).from(songs);
}
