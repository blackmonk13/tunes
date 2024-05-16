part of 'providers.dart';

@riverpod
class AlbumsController extends _$AlbumsController {
  @override
  FutureOr<List<AlbumModel>> build() {
    return ref.read(onAudioQueryProvider).queryAlbums();
  }
}

@riverpod
class AlbumSongs extends _$AlbumSongs {
  @override
  FutureOr<List<SongModel>> build(AlbumModel album) async {
    final filtered = await ref.read(onAudioQueryProvider).queryWithFilters(
          album.album,
          WithFiltersType.AUDIOS,
          args: AudiosArgs.ALBUM,
        );
    return filtered.map((e) => SongModel(e)).toList();
  }
}