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
    final hide = asyncPlayerState.when(
      data: (data) {
        final playlistSongs = nowPlayingController.valueOrNull;

        if (playlistSongs == null) {
          return true;
        }

        if (playlistSongs.isEmpty) {
          return true;
        }

        switch (data.processingState) {
          case ProcessingState.idle:
            return false;
          case ProcessingState.loading:
            return true;
          case ProcessingState.buffering:
            return true;
          case ProcessingState.ready:
            if (playlistSongs.isNotEmpty) {
              return false;
            }
            return true;
          case ProcessingState.completed:
            return false;
        }
      },
      error: (error, stackTrace) => true,
      loading: () => true,
    );
    const hiddenPosition = -72.0;
    const visiblePosition = 0.0;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: AnimatedPadding(
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.only(
              bottom: hide ? 0 : hiddenPosition.abs(),
              // bottom: 72.0,
            ),
            child: child,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          bottom: hide ? hiddenPosition : visiblePosition,
          // bottom: visiblePosition,
          child: const PlayerView(),
        )
      ],
    );
  }
}
