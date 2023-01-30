part of tunesdbdaos;

@DriftAccessor(tables: [Artists])
class ArtistsDao extends DatabaseAccessor<TunesDb> with _$ArtistsDaoMixin {
  ArtistsDao(TunesDb db) : super(db);
  Future<List<Artist>> get allArtists {
    return (select(artists)
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

  Stream<List<Artist>> get streamedArtists {
    return (select(artists)
          ..orderBy(
            [
              (ats) => OrderingTerm(
                    expression: ats.name,
                  )
            ],
          ))
        .watch();
  }

  Future<Artist> artistById(int id) async {
    return (select(artists)
          ..where((element) => element.id.equals(id))
          ..limit(1))
        .getSingle();
  }

  Future<Artist?> artistByName(String name) async {
    return (select(artists)
          ..where((element) => element.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> addArtist(ArtistsCompanion entry) {
    return into(artists).insert(entry);
  }

  Future<void> addArtists(List<ArtistsCompanion> newArtists) async {
    return batch(
      (batch) {
        batch.insertAllOnConflictUpdate(artists, newArtists);
      },
    );
  }
}
