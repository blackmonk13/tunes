import 'package:drift/drift.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/database/tables.dart';

part 'covers.g.dart';

@DriftAccessor(tables: [Covers])
class CoversDao extends DatabaseAccessor<TunesDb> with _$CoversDaoMixin {
  CoversDao(TunesDb db) : super(db);
  
  Future<List<Cover>> get allCoverEntries => select(covers).get();
  
  Future<Cover?> coverByData(Uint8List? coverData) async {
    if (coverData == null) {
      return null;
    }
    return (select(covers)
          ..where((tbl) => tbl.art.equals(coverData))
          ..limit(1))
        .getSingle();
  }

  Future<Cover> coverById(int coverId) async {
    return (select(covers)
          ..where((tbl) => tbl.id.equals(coverId))
          ..limit(1))
        .getSingle();
  }

  Future<void> addCovers(List<CoversCompanion> coverImages) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(covers, coverImages);
      },
    );
  }
}