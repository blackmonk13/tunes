part of 'providers.dart';

/// The key the sort order of the artists, albums or genres list is saved under.
String groupSortPrefsKey(GroupKind kind) => 'sort_${kind.name}';

/// The sort order of the artists, albums or genres list, remembered between
/// launches.
@Riverpod(keepAlive: true)
class GroupSortOrder extends _$GroupSortOrder {
  @override
  ({GroupSortType sortType, Sort orderType}) build(GroupKind kind) {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    final saved = prefs.getString(groupSortPrefsKey(kind))?.split(':');

    final sortType = GroupSortType.values.asNameMap()[saved?.first];
    final orderType = Sort.values
        .asNameMap()[saved != null && saved.length > 1 ? saved[1] : null];

    return (
      sortType: sortType ?? GroupSortType.name,
      orderType: orderType ?? Sort.asc,
    );
  }

  Future<void> sort({GroupSortType? sortType, Sort? orderType}) async {
    state = (
      sortType: sortType ?? state.sortType,
      orderType: orderType ?? state.orderType,
    );

    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    await prefs.setString(
      groupSortPrefsKey(kind),
      '${state.sortType.name}:${state.orderType.name}',
    );
  }
}

@riverpod
Future<List<Artist>> sortedArtists(
  SortedArtistsRef ref, {
  String? searchQuery,
}) async {
  // Everything is watched before the first await, which Riverpod requires.
  final sort = ref.watch(groupSortOrderProvider(GroupKind.artists));
  ref.watch(artistsWatcherProvider(searchQuery: searchQuery));
  final artists = await ref
      .watch(mediaQueryProvider)
      .queryArtists(searchQuery: searchQuery)
      .findAll();

  final byCount = sort.sortType == GroupSortType.songCount;
  return sortGroups(
    [
      for (final artist in artists)
        GroupSortKey(
          item: artist,
          name: artist.name,
          songCount: byCount ? await artist.songs.count() : 0,
        ),
    ],
    type: sort.sortType,
    order: sort.orderType,
  );
}

@riverpod
Future<List<Album>> sortedAlbums(
  SortedAlbumsRef ref, {
  String? searchQuery,
}) async {
  final sort = ref.watch(groupSortOrderProvider(GroupKind.albums));
  ref.watch(albumsWatcherProvider(searchQuery: searchQuery));
  final albums = await ref
      .watch(mediaQueryProvider)
      .queryAlbums(searchQuery: searchQuery)
      .findAll();

  final byCount = sort.sortType == GroupSortType.songCount;
  final byArtist = sort.sortType == GroupSortType.artist;
  final keys = <GroupSortKey<Album>>[];
  for (final album in albums) {
    if (byArtist) await album.artist.load();
    keys.add(
      GroupSortKey(
        item: album,
        name: album.title,
        songCount: byCount ? await album.songs.count() : 0,
        artist: album.artist.value?.name ?? '',
      ),
    );
  }

  return sortGroups(keys, type: sort.sortType, order: sort.orderType);
}

@riverpod
Future<List<Genre>> sortedGenres(
  SortedGenresRef ref, {
  String? searchQuery,
}) async {
  final sort = ref.watch(groupSortOrderProvider(GroupKind.genres));
  ref.watch(genresWatcherProvider(searchQuery: searchQuery));
  final genres = await ref
      .watch(mediaQueryProvider)
      .queryGenres(searchQuery: searchQuery)
      .findAll();

  final byCount = sort.sortType == GroupSortType.songCount;
  return sortGroups(
    [
      for (final genre in genres)
        GroupSortKey(
          item: genre,
          name: genre.name,
          songCount: byCount ? await genre.songs.count() : 0,
        ),
    ],
    type: sort.sortType,
    order: sort.orderType,
  );
}
