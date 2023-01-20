import 'package:flutter/material.dart';

class ConcentricCirclesClipper extends CustomClipper<Path> {
  /// Value from 0.0 to 1.0
  final double outerBorderWidth;
  /// Value from 0.0 to 1.0
  final double innerBorderWidth;
  /// Value from 0.0 to 1.0
  final double innerSize;

  ConcentricCirclesClipper({
    required this.outerBorderWidth,
    required this.innerBorderWidth,
    this.innerSize = .3,
  });

  @override
  Path getClip(Size size) {
    final Path outerMost = Path();
    final Path outerMid = Path();

    final Path innerMid = Path();
    final Path innerMost = Path();

    final double outerRadius = (size.shortestSide) / 2;
    final double innerRadius = outerRadius * innerSize;

    outerMost.addOval(Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: outerRadius,
    ));

    outerMid.addOval(
      Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: outerRadius * (1.0 - outerBorderWidth),
      ),
    );

    final outerCircle = Path.combine(
      PathOperation.difference,
      outerMost,
      outerMid,
    );

    innerMid.addOval(Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: innerRadius,
    ));

    innerMost.addOval(
      Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: innerRadius * (1.0 - innerBorderWidth),
      ),
    );

    final innerCircle = Path.combine(
      PathOperation.difference,
      innerMid,
      innerMost,
    );

    return Path.combine(PathOperation.union, outerCircle, innerCircle);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
