/// Bump when the text stored for searching changes, so songs indexed with an
/// older version are re-read on the next scan.
const searchIndexVersion = 1;

const _foldTable = {
  'a': 'àáâãäåāăąǎ',
  'c': 'çćĉċč',
  'd': 'ďđ',
  'e': 'èéêëēĕėęě',
  'g': 'ĝğġģ',
  'h': 'ĥħ',
  'i': 'ìíîïĩīĭįıǐ',
  'j': 'ĵ',
  'k': 'ķ',
  'l': 'ĺļľŀł',
  'n': 'ñńņňŉ',
  'o': 'òóôõöøōŏőǒ',
  'r': 'ŕŗř',
  's': 'śŝşš',
  't': 'ţťŧ',
  'u': 'ùúûüũūŭůűųǔ',
  'w': 'ŵ',
  'y': 'ýÿŷ',
  'z': 'źżž',
  'ss': 'ß',
  'ae': 'æ',
  'oe': 'œ',
};

final _foldMap = {
  for (final entry in _foldTable.entries)
    for (final rune in entry.value.runes) rune: entry.key,
};

/// Lowercases [text] and strips common Latin diacritics, so that `Beyoncé`,
/// `BEYONCE` and `beyonce` all fold to the same string.
String foldForSearch(String text) {
  final buffer = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    final folded = _foldMap[rune];
    if (folded != null) {
      buffer.write(folded);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// The folded, whitespace-separated words of a search query.
List<String> searchTokens(String query) {
  return foldForSearch(query)
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList();
}
