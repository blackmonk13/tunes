import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

/// A single line of text that stays still when it fits and scrolls across like
/// a ticker (a marquee) when it is too long for the available width.
class ScrollingText extends StatelessWidget {
  const ScrollingText(
    this.text, {
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: effectiveStyle),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();

        if (painter.width <= constraints.maxWidth) {
          return Text(text, maxLines: 1, style: style);
        }

        // Marquee needs a bounded height, so use the height of one line.
        return SizedBox(
          height: painter.height,
          child: Marquee(
            text: text,
            style: effectiveStyle,
            blankSpace: 48.0,
            velocity: 40.0,
            startAfter: const Duration(seconds: 1),
            pauseAfterRound: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
