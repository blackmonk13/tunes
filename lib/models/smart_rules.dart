/// What a smart playlist rule looks at.
enum RuleField {
  title('Title'),
  artist('Artist'),
  album('Album'),
  genre('Genre'),
  tag('Tag'),
  playCount('Play count'),
  lastPlayed('Last played'),
  duration('Duration'),
  favorite('Favorite');

  const RuleField(this.label);

  final String label;

  bool get isText => switch (this) {
        title || artist || album || genre || tag => true,
        _ => false,
      };

  /// The operators that make sense for this field, the first being the
  /// default.
  List<RuleOperator> get operators => switch (this) {
        title || artist || album || genre || tag => const [
            RuleOperator.contains,
            RuleOperator.doesNotContain,
            RuleOperator.isExactly,
            RuleOperator.isNot,
          ],
        playCount => const [
            RuleOperator.greaterThan,
            RuleOperator.lessThan,
            RuleOperator.equals,
          ],
        lastPlayed => const [
            RuleOperator.inTheLast,
            RuleOperator.notInTheLast,
          ],
        duration => const [
            RuleOperator.greaterThan,
            RuleOperator.lessThan,
          ],
        favorite => const [
            RuleOperator.isTrue,
            RuleOperator.isFalse,
          ],
      };

  /// What the value is measured in, shown next to the value.
  String? get unit => switch (this) {
        lastPlayed => 'days',
        duration => 'seconds',
        playCount => 'plays',
        _ => null,
      };

  bool get isNumber => switch (this) {
        playCount || lastPlayed || duration => true,
        _ => false,
      };
}

enum RuleOperator {
  contains('contains'),
  doesNotContain('does not contain'),
  isExactly('is'),
  isNot('is not'),
  greaterThan('is more than'),
  lessThan('is less than'),
  equals('is'),
  inTheLast('is in the last'),
  notInTheLast('is not in the last'),
  isTrue('is'),
  isFalse('is not');

  const RuleOperator(this.label);

  final String label;
}

/// One condition of a smart playlist, for example "genre contains rock".
class SmartRule {
  const SmartRule({
    required this.field,
    required this.operator,
    this.value = '',
  });

  final RuleField field;
  final RuleOperator operator;
  final String value;

  /// A rule with the default operator for [field].
  factory SmartRule.forField(RuleField field) {
    return SmartRule(field: field, operator: field.operators.first);
  }

  bool get needsValue => field != RuleField.favorite;

  int? get number => int.tryParse(value.trim());

  /// Whether the rule can be evaluated: text rules need text and number rules
  /// a number.
  bool get isComplete {
    if (!needsValue) return true;
    if (field.isNumber) return number != null && number! >= 0;
    return value.trim().isNotEmpty;
  }

  SmartRule copyWith({
    RuleField? field,
    RuleOperator? operator,
    String? value,
  }) {
    return SmartRule(
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => {
        'field': field.name,
        'operator': operator.name,
        'value': value,
      };

  static SmartRule? fromJson(Map<String, dynamic> json) {
    final field = RuleField.values.asNameMap()[json['field']];
    final operator = RuleOperator.values.asNameMap()[json['operator']];
    if (field == null || operator == null) return null;
    if (!field.operators.contains(operator)) return null;

    return SmartRule(
      field: field,
      operator: operator,
      value: json['value'] as String? ?? '',
    );
  }
}

/// What the songs of a smart playlist are ordered by.
enum SmartSort {
  title('Title'),
  playCount('Play count'),
  lastPlayed('Last played'),
  duration('Duration'),
  modified('Date modified');

  const SmartSort(this.label);

  final String label;
}

class SmartPlaylistDefinition {
  const SmartPlaylistDefinition({
    required this.id,
    required this.name,
    this.matchAll = true,
    this.rules = const [],
    this.limit,
    this.sort = SmartSort.title,
    this.ascending = true,
  });

  final String id;
  final String name;

  /// True when a song must satisfy every rule, false when one is enough.
  final bool matchAll;
  final List<SmartRule> rules;

  /// The most songs the playlist holds, or null for no limit.
  final int? limit;
  final SmartSort sort;
  final bool ascending;

  SmartPlaylistDefinition copyWith({
    String? name,
    bool? matchAll,
    List<SmartRule>? rules,
    int? limit,
    bool clearLimit = false,
    SmartSort? sort,
    bool? ascending,
  }) {
    return SmartPlaylistDefinition(
      id: id,
      name: name ?? this.name,
      matchAll: matchAll ?? this.matchAll,
      rules: rules ?? this.rules,
      limit: clearLimit ? null : (limit ?? this.limit),
      sort: sort ?? this.sort,
      ascending: ascending ?? this.ascending,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'matchAll': matchAll,
        'rules': [for (final rule in rules) rule.toJson()],
        'limit': limit,
        'sort': sort.name,
        'ascending': ascending,
      };

  static SmartPlaylistDefinition? fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final name = json['name'] as String?;
      if (id == null || name == null) return null;

      return SmartPlaylistDefinition(
        id: id,
        name: name,
        matchAll: json['matchAll'] as bool? ?? true,
        rules: [
          for (final rule in (json['rules'] as List? ?? []))
            ...[SmartRule.fromJson((rule as Map).cast<String, dynamic>())]
                .whereType<SmartRule>(),
        ],
        limit: json['limit'] as int?,
        sort: SmartSort.values.asNameMap()[json['sort']] ?? SmartSort.title,
        ascending: json['ascending'] as bool? ?? true,
      );
    } catch (_) {
      // A definition written by a damaged or newer version is skipped.
      return null;
    }
  }
}

/// The ids of the songs that satisfy the rules, given the ids each rule
/// matches on its own and the ids of every song.
///
/// With no rules every song matches.
Set<int> combineMatches({
  required bool matchAll,
  required List<Set<int>> perRule,
  required Set<int> all,
}) {
  if (perRule.isEmpty) return {...all};

  var result = {...perRule.first};
  for (final matches in perRule.skip(1)) {
    result = matchAll ? result.intersection(matches) : result.union(matches);
  }
  return result;
}
