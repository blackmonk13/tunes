part of controllers;

@riverpod
class ScanController extends _$ScanController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> scanAndPopulateDb() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {await ref.read(tunesRepositoryProvider).db.resetTunes();
        final fsMap = await ref.read(tunesRepositoryProvider).getFsTunes();
        final rawarts = fsMap
            .map((e) => e['artwork'] as Uint8List?)
            .where((element) => element != null)
            .toSet()
            .toList();
        final arts = rawarts.map((e) => e!).toList();
        final artists = fsMap
            .map((e) => (e['artist'] as String).trimLeft().trimRight())
            .toSet()
            .toList();
        final albums = fsMap
            .map((e) => (e['album'] as String).trimLeft().trimRight())
            .toSet()
            .toList();
        await ref.read(tunesRepositoryProvider).addCovers(arts);
        await ref.read(tunesRepositoryProvider).addArtists(artists);
        await ref.read(tunesRepositoryProvider).addAlbums(albums);
        await ref.read(tunesRepositoryProvider).addTunes(fsMap);
        ref.invalidate(songsProvider);
        return;
      },
    );
  }
}
