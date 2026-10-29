import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marquee/marquee.dart';
import 'package:tunes/components/scrolling_text.dart';

Widget _host(double width, String text) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          child: ScrollingText(text),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('short text stays still', (tester) async {
    await tester.pumpWidget(_host(300, 'Short'));

    expect(find.text('Short'), findsOneWidget);
    expect(find.byType(Marquee), findsNothing);
  });

  testWidgets('long text scrolls', (tester) async {
    await tester.pumpWidget(
      _host(80, 'A title that is far too long to fit in eighty pixels'),
    );

    expect(find.byType(Marquee), findsOneWidget);

    // The marquee waits a second before it starts scrolling. Let that timer
    // fire before the test ends, or the test reports a pending timer.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
