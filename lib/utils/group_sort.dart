import 'package:isar/isar.dart' show Sort;
import 'package:tunes/utils/search_text.dart';

/// The lists of songs grouped by artist, album or genre.
enum GroupKind { artists, albums, genres }

enum GroupSortType {
  /// The name of an artist or genre, or the title of an album.
  name,
  songCount,

  /// The artist of an album. Only albums have one.
  artist,
}

/// An item to sort together with the values it can be sorted by.
class GroupSortKey<T> {
  const GroupSortKey({
    required this.item,
    required this.name,
    this.songCount = 0,
    this.artist = '',
  });

  final T item;
  final String name;
  final int songCount;
  final String artist;
}

/// Sorts [keys] by [type] in [order] and returns the items.
///
/// Names compare ignoring case and accents, so "Émile" sorts with the Es. Ties
/// are broken by name.
List<T> sortGroups<T>(
  Iterable<GroupSortKey<T>> keys, {
  required GroupSortType type,
  required Sort order,
}) {
  int byName(GroupSortKey<T> a, GroupSortKey<T> b) {
    return foldForSearch(a.name).compareTo(foldForSearch(b.name));
  }

  int compare(GroupSortKey<T> a, GroupSortKey<T> b) {
    switch (type) {
      case GroupSortType.name:
        return byName(a, b);
      case GroupSortType.songCount:
        final byCount = a.songCount.compareTo(b.songCount);
        return byCount != 0 ? byCount : byName(a, b);
      case GroupSortType.artist:
        final byArtist =
            foldForSearch(a.artist).compareTo(foldForSearch(b.artist));
        return byArtist != 0 ? byArtist : byName(a, b);
    }
  }

  final sorted = keys.toList()
    ..sort(order == Sort.asc ? compare : (a, b) => compare(b, a));

  return [for (final key in sorted) key.item];
}
