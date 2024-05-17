part of 'providers.dart';

@riverpod
class PlaylistsController extends _$PlaylistsController {
  @override
  FutureOr<List<PlaylistModel>> build() {
    return ref.read(onAudioQueryProvider).queryPlaylists();
  }
}

@riverpod
class PlaylistSongs extends _$PlaylistSongs {
  @override
  FutureOr<List<SongModel>> build(PlaylistModel playlist) {
    return ref.read(onAudioQueryProvider).queryAudiosFrom(
          AudiosFromType.PLAYLIST,
          playlist.playlist,
          sortType: SongSortType.DATE_ADDED,
          orderType: OrderType.DESC_OR_GREATER,
        );
  }
}
