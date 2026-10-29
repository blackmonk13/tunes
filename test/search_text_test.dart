import 'package:flutter_test/flutter_test.dart';
import 'package:tunes/utils/search_text.dart';

void main() {
  group('foldForSearch', () {
    test('lowercases and strips diacritics', () {
      expect(foldForSearch('Beyoncé'), 'beyonce');
      expect(foldForSearch('Sigur Rós'), 'sigur ros');
      expect(foldForSearch('Mötley Crüe'), 'motley crue');
    });

    test('expands ligatures and ß', () {
      expect(foldForSearch('Straße'), 'strasse');
      expect(foldForSearch('Cœur'), 'coeur');
    });

    test('leaves other characters alone', () {
      expect(foldForSearch('AC/DC 99'), 'ac/dc 99');
      expect(foldForSearch('日本語'), '日本語');
    });
  });

  group('searchTokens', () {
    test('splits on whitespace and folds', () {
      expect(searchTokens('  Héllo   WORLD '), ['hello', 'world']);
    });

    test('is empty for a blank query', () {
      expect(searchTokens('   '), isEmpty);
    });
  });
}
