import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A row that moves back and forth by itself when its children do not fit,
/// and stays still when they do. It can still be scrolled by hand.
///
/// [restartKey] restarts the movement when the children change.
class AutoScrollRow extends HookWidget {
  const AutoScrollRow({
    super.key,
    required this.children,
    this.restartKey,
    this.padding = EdgeInsets.zero,
    this.pause = const Duration(seconds: 2),
    this.pixelsPerSecond = 30.0,
  });

  final List<Widget> children;
  final Object? restartKey;
  final EdgeInsetsGeometry padding;

  /// How long the row rests at each end.
  final Duration pause;
  final double pixelsPerSecond;

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();

    useEffect(() {
      var cancelled = false;

      Future<void> glide(double target) async {
        if (cancelled || !controller.hasClients) return;

        final distance = (target - controller.offset).abs();
        if (distance < 1.0) return;

        await controller.animateTo(
          target,
          duration: Duration(
            milliseconds: (distance / pixelsPerSecond * 1000).round(),
          ),
          curve: Curves.linear,
        );
      }

      Future<void> run() async {
        while (!cancelled) {
          await Future<void>.delayed(pause);
          if (cancelled || !controller.hasClients) continue;

          final end = controller.position.maxScrollExtent;
          if (end <= 0) continue;

          try {
            await glide(end);
            await Future<void>.delayed(pause);
            await glide(0);
          } catch (_) {
            // The row went away while it was moving.
            return;
          }
        }
      }

      run();
      return () => cancelled = true;
    }, [controller, restartKey]);

    return ListView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      padding: padding,
      children: children,
    );
  }
}
