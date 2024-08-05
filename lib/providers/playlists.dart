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
  FutureOr<List<Playlist>> build() {
    final playlistSortOrder = ref.watch(playlistSortOrderProvider);
    return ref.watch(isarProvider).requireValue.playlists.where().findAll();
  }

  Future<Playlist?> createPlaylist(
    String name, {
    String? author,
    String? desc,
  }) async {
    final isar = ref.read(isarProvider).requireValue;

    final playlist = Playlist()..name = name;
    int? newId;
    await isar.writeTxn(() async {
      newId = await isar.playlists.put(playlist);
    });

    if (newId == null) {
      return null;
    }

    ref.invalidateSelf();
    final playlists = await future;
    if (playlists.isEmpty) {
      return null;
    }

    final index = playlists.indexWhere((element) {
      return element.name == name;
    });

    if (index == -1) {
      return null;
    }

    return playlists.elementAt(index);
  }

  Future<bool> removePlaylist(int playlistId) async {
    final isar = ref.read(isarProvider).requireValue;

    return isar.writeTxn(() async {
      return isar.playlists.delete(playlistId);
    });
  }

  Future<bool> addToPlaylist(Playlist playlist, Song song) async {
    final isar = ref.read(isarProvider).requireValue;
    final added = playlist.songs.add(song);

    await isar.writeTxn(() async {
      await playlist.songs.save();
    });

    if (!added) {
      return false;
    }

    ref.invalidateSelf();
    await future;
    return added;
  }

  Future<bool> removeFromPlaylist(Playlist playlist, Song song) async {

    final isar = ref.read(isarProvider).requireValue;
    final removed = playlist.songs.remove(song);

    await isar.writeTxn(() async {
      await playlist.songs.save();
    });

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
Stream<void> playlistsWatcher(PlaylistsWatcherRef ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return isar.playlists.watchLazy(fireImmediately: true);
}

@riverpod
class FavoritesPlaylist extends _$FavoritesPlaylist {
  @override
  FutureOr<Playlist> build() async {
    ref.watch(playlistsWatcherProvider);
    final isar = ref.watch(isarProvider).requireValue;

    Playlist? favorites = await isar.playlists
        .where()
        .filter()
        .nameEqualTo(favsPlaylistName)
        .findFirst();
    if (favorites == null) {
      favorites = Playlist()..name = favsPlaylistName;
      await isar.writeTxn(() async {
        await isar.playlists.put(favorites!);
      });
    }

    return favorites;
  }

  Future<bool> toggleFavorite(Song song) async {
    final isar = ref.read(isarProvider).requireValue;
    final favlist = await future;

    bool toggled;
    if (favlist.songs.contains(song)) {
      toggled = favlist.songs.remove(song);
    } else {
      toggled = favlist.songs.add(song);
    }

    await isar.writeTxn(() async {
      await favlist.songs.save();
    });

    return toggled;
  }
}
