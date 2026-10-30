import 'package:flutter_test/flutter_test.dart';
import 'package:tunes/models/smart_rules.dart';

void main() {
  group('rules', () {
    test('every field starts with an operator that belongs to it', () {
      for (final field in RuleField.values) {
        expect(
          field.operators,
          contains(SmartRule.forField(field).operator),
          reason: field.name,
        );
      }
    });

    test('text rules need text, number rules need a number', () {
      const text = SmartRule(
        field: RuleField.genre,
        operator: RuleOperator.contains,
      );
      expect(text.isComplete, isFalse);
      expect(text.copyWith(value: ' rock ').isComplete, isTrue);

      const number = SmartRule(
        field: RuleField.playCount,
        operator: RuleOperator.greaterThan,
      );
      expect(number.copyWith(value: 'many').isComplete, isFalse);
      expect(number.copyWith(value: '-1').isComplete, isFalse);
      expect(number.copyWith(value: '5').isComplete, isTrue);
    });

    test('the favorite rule needs no value', () {
      final rule = SmartRule.forField(RuleField.favorite);
      expect(rule.needsValue, isFalse);
      expect(rule.isComplete, isTrue);
    });
  });

  group('json', () {
    test('a definition survives a round trip', () {
      const definition = SmartPlaylistDefinition(
        id: 'a',
        name: 'Fresh rock',
        matchAll: false,
        rules: [
          SmartRule(
            field: RuleField.genre,
            operator: RuleOperator.contains,
            value: 'rock',
          ),
          SmartRule(
            field: RuleField.lastPlayed,
            operator: RuleOperator.notInTheLast,
            value: '30',
          ),
        ],
        limit: 25,
        sort: SmartSort.playCount,
        ascending: false,
      );

      final read = SmartPlaylistDefinition.fromJson(definition.toJson())!;

      expect(read.id, 'a');
      expect(read.name, 'Fresh rock');
      expect(read.matchAll, isFalse);
      expect(read.limit, 25);
      expect(read.sort, SmartSort.playCount);
      expect(read.ascending, isFalse);
      expect(read.rules, hasLength(2));
      expect(read.rules.last.operator, RuleOperator.notInTheLast);
      expect(read.rules.last.value, '30');
    });

    test('unknown or mismatched rules are dropped, damaged input is null', () {
      final read = SmartPlaylistDefinition.fromJson({
        'id': 'a',
        'name': 'x',
        'rules': [
          {'field': 'nope', 'operator': 'contains', 'value': 'a'},
          {'field': 'genre', 'operator': 'greaterThan', 'value': '1'},
          {'field': 'genre', 'operator': 'contains', 'value': 'ok'},
        ],
      })!;

      expect(read.rules, hasLength(1));
      expect(read.rules.single.value, 'ok');
      expect(SmartPlaylistDefinition.fromJson({'name': 'no id'}), isNull);
    });

    test('clearing the limit removes it', () {
      const definition = SmartPlaylistDefinition(
        id: 'a',
        name: 'x',
        limit: 10,
      );

      expect(definition.copyWith(clearLimit: true).limit, isNull);
      expect(definition.copyWith(name: 'y').limit, 10);
    });
  });

  group('combineMatches', () {
    const all = {1, 2, 3, 4, 5};

    test('match all intersects, match any joins', () {
      final perRule = [
        {1, 2, 3},
        {2, 3, 4},
      ];

      expect(
        combineMatches(matchAll: true, perRule: perRule, all: all),
        {2, 3},
      );
      expect(
        combineMatches(matchAll: false, perRule: perRule, all: all),
        {1, 2, 3, 4},
      );
    });

    test('no rules match every song', () {
      expect(
        combineMatches(matchAll: true, perRule: [], all: all),
        all,
      );
    });

    test('the inputs are not changed', () {
      final first = {1, 2};
      combineMatches(
        matchAll: false,
        perRule: [
          first,
          {3}
        ],
        all: all,
      );

      expect(first, {1, 2});
    });
  });
}
