part of 'providers.dart';

/// The songs of a smart playlist, refreshed when the songs change, for
/// example when a play is counted.
@riverpod
Future<List<Song>> smartPlaylistSongs(
  SmartPlaylistSongsRef ref,
  SmartPlaylistKind kind,
) async {
  final isar = ref.watch(isarProvider).requireValue;
  ref.watch(songsWatcherProvider());

  switch (kind) {
    case SmartPlaylistKind.recentlyPlayed:
      return isar.songs
          .filter()
          .lastPlayedAtGreaterThan(0)
          .sortByLastPlayedAtDesc()
          .limit(smartPlaylistLength)
          .findAll();
    case SmartPlaylistKind.mostPlayed:
      return isar.songs
          .filter()
          .playCountGreaterThan(0)
          .sortByPlayCountDesc()
          .thenByLastPlayedAtDesc()
          .limit(smartPlaylistLength)
          .findAll();
    case SmartPlaylistKind.leastPlayed:
      // Never played songs come first, then the ones played longest ago.
      return isar.songs
          .where()
          .sortByPlayCount()
          .thenByLastPlayedAt()
          .limit(smartPlaylistLength)
          .findAll();
  }
}
