import 'package:flutter_test/flutter_test.dart';
import 'package:tunes/components/now_playing_view.dart';

double _offset(int position, {double viewport = 400, double max = 4000}) {
  return queueScrollOffset(
    position: position,
    rowExtent: 80,
    viewport: viewport,
    maxScrollExtent: max,
  );
}

void main() {
  group('queueScrollOffset', () {
    test('centres a row in the middle of the list', () {
      // Row 20 starts at 1600; half a viewport minus half a row is 160.
      expect(_offset(20), 1440);
    });

    test('does not scroll above the top for the first rows', () {
      expect(_offset(0), 0);
      expect(_offset(1), 0);
    });

    test('does not scroll past the end for the last rows', () {
      expect(_offset(60), 4000);
    });

    test('is zero when the list is shorter than the viewport', () {
      expect(_offset(3, max: 0), 0);
    });
  });
}
