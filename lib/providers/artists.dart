part of 'providers.dart';

@riverpod
class ArtistsController extends _$ArtistsController {
  @override
  FutureOr<List<ArtistModel>> build() {
    return ref.read(onAudioQueryProvider).queryArtists();
  }
}

@riverpod
class ArtistSongs extends _$ArtistSongs {
  @override
  FutureOr<List<SongModel>> build(ArtistModel artist) async {
    final filtered = await ref.read(onAudioQueryProvider).queryWithFilters(
          artist.artist,
          WithFiltersType.AUDIOS,
          args: AudiosArgs.ARTIST,
        );
    return filtered.map((e) => SongModel(e)).toList();
  }
}

@riverpod
class ArtistAlbums extends _$ArtistAlbums {
  @override
  FutureOr<List<AlbumModel>> build(ArtistModel artist) async {
    final filtered = await ref.read(onAudioQueryProvider).queryWithFilters(
          artist.artist,
          WithFiltersType.ALBUMS,
          args: AlbumsArgs.ARTIST,
        );
    return filtered.map((e) => AlbumModel(e)).toList();
  }
}
