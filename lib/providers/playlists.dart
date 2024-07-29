part of 'providers.dart';

@riverpod
class PlaylistSortOrder extends _$PlaylistSortOrder {
  @override
  ({PlaylistSortType sortType, OrderType orderType}) build() {
    return (
      sortType: PlaylistSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
    );
  }

  void sort({PlaylistSortType? sortType, OrderType? orderType}) {
    state = (
      sortType: sortType ?? state.sortType,
      orderType: orderType ?? state.orderType
    );
  }
}

@riverpod
class PlaylistsController extends _$PlaylistsController {
  @override
  FutureOr<List<PlaylistModel>> build() {
    final playlistSortOrder = ref.watch(playlistSortOrderProvider);
    return ref.read(onAudioQueryProvider).queryPlaylists(
          sortType: playlistSortOrder.sortType,
          orderType: playlistSortOrder.orderType,
        );
  }

  Future<PlaylistModel?> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    final created = await ref.read(onAudioQueryProvider).createPlaylist(
          name,
          author: author,
          desc: desc,
        );

    if (!created) {
      return null;
    }

    ref.invalidateSelf();
    final playlists = await future;
    if (playlists.isEmpty) {
      return null;
    }

    final index = playlists.indexWhere((element) {
      return element.playlist == name;
    });

    if (index == -1) {
      return null;
    }

    return playlists.elementAt(index);
  }

  Future<bool> removePlaylist(int playlistId) async {
    final removed =
        await ref.read(onAudioQueryProvider).removePlaylist(playlistId);

    if (!removed) {
      return false;
    }

    ref.invalidateSelf();
    final playlists = await future;

    final index = playlists.indexWhere((element) {
      return element.id == playlistId;
    });

    if (index == -1) {
      return true;
    }

    return false;
  }

  Future<bool> addToPlaylist(int playlistId, int audioId) async {
    final added = await ref.read(onAudioQueryProvider).addToPlaylist(
          playlistId,
          audioId,
        );

    if (!added) {
      return false;
    }

    ref.invalidateSelf();
    await future;
    return added;
  }

  Future<bool> removeFromPlaylist(int playlistId, int audioId) async {
    final removed = await ref.read(onAudioQueryProvider).removeFromPlaylist(
          playlistId,
          audioId,
        );

    if (!removed) {
      return false;
    }

    ref.invalidateSelf();
    await future;
    return removed;
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

@riverpod
class FavoritesPlaylist extends _$FavoritesPlaylist {
  @override
  FutureOr<PlaylistModel?> build() async {
    final fav = await getFavorite();

    if (fav != null) {
      return fav;
    }

    final created = await ref
        .read(playlistsControllerProvider.notifier)
        .createPlaylist(favsPlaylistName);

    return created;
  }

  Future<PlaylistModel?> getFavorite() async {
    final playlists = await ref.watch(playlistsControllerProvider.future);
    if (playlists.isEmpty) {
      return null;
    }

    final index = playlists.indexWhere((element) {
      return element.playlist == favsPlaylistName;
    });

    if (index == -1) {
      return null;
    }

    return playlists.elementAt(index);
  }

  Future<bool> toggleFavorite(SongModel song, {bool? favorite}) async {
    final favlist = await future;

    if (favlist == null) {
      return false;
    }

    if (favorite != null) {
      if (favorite) {
        return ref
            .read(playlistsControllerProvider.notifier)
            .removeFromPlaylist(
              favlist.id,
              song.id,
            );
      }

      return ref.read(playlistsControllerProvider.notifier).addToPlaylist(
            favlist.id,
            song.id,
          );
    }

    final favsongs = await ref.read(songsControllerProvider(
      query: favlist.playlist,
      queryType: SongQueryType.songsForPlaylist,
    ).future);

    final exists = favsongs.contains(song);

    if (exists) {
      return ref.read(playlistsControllerProvider.notifier).removeFromPlaylist(
            favlist.id,
            song.id,
          );
    }

    return ref.read(playlistsControllerProvider.notifier).addToPlaylist(
          favlist.id,
          song.id,
        );
  }
}
