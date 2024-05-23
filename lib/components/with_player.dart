import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/components/player.dart';
import 'package:tunes/providers/providers.dart';

class WithPlayer extends HookConsumerWidget {
  final Widget child;
  const WithPlayer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingController = ref.watch(nowPlayingControllerProvider);
    final asyncPlayerState = ref.watch(playerStateProvider);
    const hiddenPosition = -72.0;
    const visiblePosition = 10.0;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: child,
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          bottom: asyncPlayerState.when(
            data: (data) {
              final playlistSongs = nowPlayingController.valueOrNull;

              if (playlistSongs == null) {
                return hiddenPosition;
              }

              if (playlistSongs.isEmpty) {
                return hiddenPosition;
              }
              
              switch (data.processingState) {
                case ProcessingState.idle:
                  return visiblePosition;
                case ProcessingState.loading:
                  return hiddenPosition;
                case ProcessingState.buffering:
                  return hiddenPosition;
                case ProcessingState.ready:
                  if (playlistSongs.isNotEmpty) {
                    return visiblePosition;
                  }
                  return hiddenPosition;
                case ProcessingState.completed:
                  return visiblePosition;
              }
            },
            error: (error, stackTrace) => hiddenPosition,
            loading: () => hiddenPosition,
          ),
          child: const PlayerView(),
        )
      ],
    );
  }
}
