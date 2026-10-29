import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart' show Sort;
import 'package:tunes/utils/group_sort.dart';

GroupSortKey<String> _key(String name, {int songs = 0, String artist = ''}) {
  return GroupSortKey(
    item: name,
    name: name,
    songCount: songs,
    artist: artist,
  );
}

void main() {
  group('sortGroups by name', () {
    final keys = [_key('beta'), _key('Émile'), _key('Alpha'), _key('eagle')];

    test('ignores case and accents', () {
      expect(
        sortGroups(keys, type: GroupSortType.name, order: Sort.asc),
        ['Alpha', 'beta', 'eagle', 'Émile'],
      );
    });

    test('descending reverses it', () {
      expect(
        sortGroups(keys, type: GroupSortType.name, order: Sort.desc),
        ['Émile', 'eagle', 'beta', 'Alpha'],
      );
    });
  });

  group('sortGroups by song count', () {
    final keys = [
      _key('b', songs: 3),
      _key('a', songs: 3),
      _key('c', songs: 10),
      _key('d', songs: 1),
    ];

    test('ascending puts the fewest first and ties go by name', () {
      expect(
        sortGroups(keys, type: GroupSortType.songCount, order: Sort.asc),
        ['d', 'a', 'b', 'c'],
      );
    });

    test('descending puts the most first', () {
      expect(
        sortGroups(keys, type: GroupSortType.songCount, order: Sort.desc),
        ['c', 'b', 'a', 'd'],
      );
    });
  });

  group('sortGroups by artist', () {
    test('sorts by the artist, then by title', () {
      final keys = [
        _key('Two', artist: 'Zed'),
        _key('One', artist: 'Ann'),
        _key('Another', artist: 'Ann'),
      ];

      expect(
        sortGroups(keys, type: GroupSortType.artist, order: Sort.asc),
        ['Another', 'One', 'Two'],
      );
    });
  });

  test('an empty list stays empty', () {
    expect(
      sortGroups<String>([], type: GroupSortType.name, order: Sort.asc),
      isEmpty,
    );
  });
}
