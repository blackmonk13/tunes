import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class MiniProgress extends ConsumerWidget {
  const MiniProgress({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncPosition = ref.watch(playerPositionProvider);

    return CircularProgressIndicator(
      strokeWidth: 2.5,
      strokeCap: StrokeCap.round,
      backgroundColor:
          player.duration == null ? null : context.colorScheme.outline,
      value: asyncPosition.when(
        data: (position) {
          final total = player.duration;
          if (total == null) {
            return 0.0;
          }

          final positionRatio =
              position.inMilliseconds / total.inMilliseconds * 1.0;

          return positionRatio;
        },
        error: (error, stackTrace) => 0.0,
        loading: () => null,
      ),
    );
  }
}
