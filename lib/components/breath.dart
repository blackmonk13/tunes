import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tunes/components/concentric_clipper.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/controllers/main.dart';

class Breath extends ConsumerWidget {
  const Breath({super.key, this.multiplier = 1.0});
  final double multiplier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(scanControllerProvider);
    final MovieTween tween = MovieTween()
      ..scene(
              begin: const Duration(milliseconds: 0),
              end: Duration(milliseconds: (1000 * multiplier).toInt()))
          .tween(
        'opacity',
        Tween(begin: 0.8, end: 1.0),
      )
      ..scene(
              begin: const Duration(milliseconds: 0),
              end: Duration(milliseconds: (2500 * multiplier).toInt()))
          .tween(
        'size',
        Tween(
          begin: 24.0,
          end: 36.0,
        ),
      );

    return MirrorAnimationBuilder(
        tween: tween, // Pass in tween
        duration: tween.duration, // Obtain duration
        curve: Curves.easeInOutSine,
        builder: (context, value, child) {
          return AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: EdgeInsets.all(value.get('size')),
              child: ClipPath(
                clipper: ConcentricCirclesClipper(
                  innerBorderWidth: .5,
                  innerSize: .6,
                  outerBorderWidth: .02,
                ),
                child: AnimatedContainer(
                  duration: tween.duration,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary
                        .withOpacity(value.get('opacity')),
                  ),
                ),
              ),
            ),
          );
        });
  }

  MirrorAnimationBuilder<double> pulse() {
    return MirrorAnimationBuilder<double>(
      tween: Tween(begin: .3, end: .33), // value for offset x-coordinate
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOutSine, // non-linear animation
      builder: (context, value, child) {
        return AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: CircleAvatar(
              backgroundColor: context.colorScheme.primary.withOpacity(value),
              radius: context.shortestSide * value,
              child: Icon(
                Icons.music_note_outlined,
                size: context.screenWidth * .25,
              ),
            ),
          ),
        );
      },
    );
  }
}
