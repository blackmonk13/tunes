part of tunesdbdaos;

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

  Future<int> addCover(CoversCompanion entry) {
    return into(covers).insert(entry);
  }

  Future<void> addCovers(List<CoversCompanion> coverImages) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(covers, coverImages);
      },
    );
  }
}
