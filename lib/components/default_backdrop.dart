import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';

class DefaultBackdrop extends StatelessWidget {
  const DefaultBackdrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withOpacity(0.5),
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(.4),
          ),
        ),
      ),
    );
  }
}
