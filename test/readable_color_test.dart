import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tunes/utils/functions.dart';

void main() {
  test('contrast ratio is 21 for black on white and 1 for the same colour', () {
    expect(contrastRatio(Colors.black, Colors.white), closeTo(21, .01));
    expect(contrastRatio(Colors.red, Colors.red), closeTo(1, .001));
  });

  test('a readable colour is kept', () {
    expect(readableOn(Colors.white, Colors.black), Colors.black);
    expect(readableOn(Colors.black, Colors.amber), Colors.amber);
  });

  test('a light colour on a bright background becomes black', () {
    const bright = Color(0xFFF2E6C8);
    const paleYellow = Color(0xFFE8DDB5);

    expect(readableOn(bright, paleYellow), Colors.black);
  });

  test('a dark colour on a dark background becomes white', () {
    const dark = Color(0xFF1B2A34);
    const navy = Color(0xFF24394A);

    expect(readableOn(dark, navy), Colors.white);
  });
}
