part of 'providers.dart';

/// The smart playlists the user made from rules, kept in the preferences.
@Riverpod(keepAlive: true)
class SmartPlaylistStore extends _$SmartPlaylistStore {
  @override
  List<SmartPlaylistDefinition> build() {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    final saved = prefs.getStringList(smartPlaylistsPrefsKey) ?? [];

    final definitions = <SmartPlaylistDefinition>[];
    for (final raw in saved) {
      try {
        final definition = SmartPlaylistDefinition.fromJson(
          (json.decode(raw) as Map).cast<String, dynamic>(),
        );
        if (definition != null) definitions.add(definition);
      } catch (_) {
        // A damaged entry is skipped.
      }
    }
    return definitions;
  }

  String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  /// Adds the definition, or replaces the one with the same id.
  Future<void> save(SmartPlaylistDefinition definition) async {
    final next = [...state];
    final index = next.indexWhere((d) => d.id == definition.id);
    if (index == -1) {
      next.add(definition);
    } else {
      next[index] = definition;
    }
    state = next;
    await _persist();
  }

  Future<void> remove(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider).requireValue;
    await prefs.setStringList(
      smartPlaylistsPrefsKey,
      [for (final d in state) json.encode(d.toJson())],
    );
  }
}

/// The songs of the smart playlist with [id], refreshed when the songs, the
/// tags or the playlist itself change.
@riverpod
Future<List<Song>> customSmartPlaylistSongs(
  CustomSmartPlaylistSongsRef ref,
  String id,
) async {
  final definition = ref.watch(
    smartPlaylistStoreProvider.select(
      (all) => all.where((d) => d.id == id).firstOrNull,
    ),
  );
  final isar = ref.watch(isarProvider).requireValue;
  ref.watch(songsWatcherProvider());
  ref.watch(labelsWatcherProvider);

  if (definition == null) return [];
  return evaluateSmartPlaylist(isar, definition);
}

/// The songs that satisfy [definition], ordered and limited as it says.
Future<List<Song>> evaluateSmartPlaylist(
  Isar isar,
  SmartPlaylistDefinition definition, {
  DateTime? now,
}) async {
  final all = (await isar.songs.where().idProperty().findAll()).toSet();
  final favorites = await _favoriteIds(isar);
  final time = now ?? DateTime.now();

  // Rules that are not filled in yet match nothing instead of everything.
  final perRule = <Set<int>>[];
  for (final rule in definition.rules) {
    perRule.add(
      rule.isComplete
          ? await _songsMatching(isar, rule, all, favorites, time)
          : <int>{},
    );
  }

  final ids = combineMatches(
    matchAll: definition.matchAll,
    perRule: perRule,
    all: all,
  );

  final found = await isar.songs.getAll(ids.toList());
  final songs = found.whereType<Song>().toList();
  _sortSongs(songs, definition.sort, definition.ascending);

  final limit = definition.limit;
  return limit == null || limit >= songs.length
      ? songs
      : songs.take(limit).toList();
}

Future<Set<int>> _favoriteIds(Isar isar) async {
  final favorites =
      await isar.playlists.filter().nameEqualTo(favsPlaylistName).findFirst();
  if (favorites == null) return {};

  await favorites.songs.load();
  return favorites.songs.map((song) => song.id).toSet();
}

/// The ids of the songs a single rule matches.
Future<Set<int>> _songsMatching(
  Isar isar,
  SmartRule rule,
  Set<int> all,
  Set<int> favorites,
  DateTime now,
) async {
  final text = rule.value.trim();
  final number = rule.number ?? 0;

  Future<Set<int>> ids(
    QueryBuilder<Song, Song, QAfterFilterCondition> query,
  ) async {
    return (await query.idProperty().findAll()).toSet();
  }

  // Operators that say "not" take the songs that the positive form leaves
  // out.
  Set<int> unless(Set<int> matches) {
    return _isNegative(rule) ? all.difference(matches) : matches;
  }

  switch (rule.field) {
    case RuleField.title:
      return unless(await ids(
        _isExact(rule)
            ? isar.songs.filter().titleEqualTo(text, caseSensitive: false)
            : isar.songs.filter().titleContains(text, caseSensitive: false),
      ));
    case RuleField.artist:
      return unless(await ids(
        isar.songs.filter().artist(
              (q) => _isExact(rule)
                  ? q.nameEqualTo(text, caseSensitive: false)
                  : q.nameContains(text, caseSensitive: false),
            ),
      ));
    case RuleField.album:
      return unless(await ids(
        isar.songs.filter().album(
              (q) => _isExact(rule)
                  ? q.titleEqualTo(text, caseSensitive: false)
                  : q.titleContains(text, caseSensitive: false),
            ),
      ));
    case RuleField.genre:
      return unless(await ids(
        isar.songs.filter().genre(
              (q) => _isExact(rule)
                  ? q.nameEqualTo(text, caseSensitive: false)
                  : q.nameContains(text, caseSensitive: false),
            ),
      ));
    case RuleField.tag:
      return unless(await ids(
        isar.songs.filter().labels(
              (q) => _isExact(rule)
                  ? q.nameEqualTo(text, caseSensitive: false)
                  : q.nameContains(text, caseSensitive: false),
            ),
      ));
    case RuleField.playCount:
      switch (rule.operator) {
        case RuleOperator.greaterThan:
          return ids(isar.songs.filter().playCountGreaterThan(number));
        case RuleOperator.lessThan:
          return ids(isar.songs.filter().playCountLessThan(number));
        default:
          return ids(isar.songs.filter().playCountEqualTo(number));
      }
    case RuleField.lastPlayed:
      final since = now.subtract(Duration(days: number)).millisecondsSinceEpoch;
      final matches = await ids(
        isar.songs.filter().lastPlayedAtGreaterThan(since),
      );
      return rule.operator == RuleOperator.notInTheLast
          ? all.difference(matches)
          : matches;
    case RuleField.duration:
      final milliseconds = number * 1000;
      return rule.operator == RuleOperator.lessThan
          ? ids(isar.songs.filter().durationLessThan(milliseconds))
          : ids(isar.songs.filter().durationGreaterThan(milliseconds));
    case RuleField.favorite:
      return rule.operator == RuleOperator.isFalse
          ? all.difference(favorites)
          : {...favorites};
  }
}

bool _isExact(SmartRule rule) =>
    rule.operator == RuleOperator.isExactly ||
    rule.operator == RuleOperator.isNot;

bool _isNegative(SmartRule rule) =>
    rule.operator == RuleOperator.doesNotContain ||
    rule.operator == RuleOperator.isNot;

void _sortSongs(List<Song> songs, SmartSort sort, bool ascending) {
  int compare(Song a, Song b) {
    switch (sort) {
      case SmartSort.title:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case SmartSort.playCount:
        return a.playCount.compareTo(b.playCount);
      case SmartSort.lastPlayed:
        return a.lastPlayedAt.compareTo(b.lastPlayedAt);
      case SmartSort.duration:
        return a.duration.compareTo(b.duration);
      case SmartSort.modified:
        return a.lastModified.compareTo(b.lastModified);
    }
  }

  songs.sort((a, b) {
    final result = compare(a, b);
    if (result != 0) return ascending ? result : -result;
    // Equal songs keep a steady order.
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  });
}
