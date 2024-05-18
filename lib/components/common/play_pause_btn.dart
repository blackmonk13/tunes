import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/providers/providers.dart';

class PlayPauseBtn extends HookConsumerWidget {
  const PlayPauseBtn({
    super.key,
    this.size = 42.0,
  });
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);
    final asyncPlayerState = ref.watch(playerStateProvider);

    return asyncPlayerState.when(
      data: (state) {
        if (state.playing) {
          return IconButton(
            icon: Icon(
              FluentIcons.pause_circle_24_filled,
              size: size,
            ),
            onPressed: () => player.pause(),
          );
        } else {
          switch (state.processingState) {
            case ProcessingState.idle:
              if (player.currentIndex == null) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(
                  FluentIcons.play_circle_28_filled,
                  size: size,
                ),
                onPressed: () {
                  player.seek(
                    Duration.zero,
                    index: 0,
                  );
                  player.play();
                },
              );
            case ProcessingState.loading:
              return const CircularProgressIndicator(
                strokeWidth: 2.0,
              );
            case ProcessingState.buffering:
              return const CircularProgressIndicator(
                strokeWidth: 2.0,
              );
            case ProcessingState.ready:
              return IconButton(
                icon: Icon(
                  player.playing
                      ? FluentIcons.pause_circle_24_filled
                      : FluentIcons.play_circle_28_filled,
                  size: size,
                ),
                onPressed: () => player.play(),
              );
            case ProcessingState.completed:
              return IconButton(
                icon: Icon(
                  FluentIcons.play_circle_28_filled,
                  size: size,
                ),
                onPressed: () {
                  player.seek(
                    Duration.zero,
                    index: 0,
                  );
                  player.play();
                },
              );
            default:
              return const SizedBox.shrink();
          }
        }
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const CircularProgressIndicator(
          strokeWidth: 2.0,
        );
      },
    );
  }
}
