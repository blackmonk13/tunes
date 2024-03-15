import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:tunes/providers/providers.dart';

import 'music_controls.dart';
import 'music_player.dart';

class CollapsedPlayer extends HookConsumerWidget {
  const CollapsedPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    ref.watch(playlistControllerProvider);
    final asyncPlayerState = ref.watch(playerStateProvider);
    final player = ref.watch(audioPlayerProvider);
    

    return asyncPlayerState.when(
      data: (state) {
        if (state.playing) {
          return const MiniPlayer();
        } else {
          switch (state.processingState) {
            case ProcessingState.idle:
              if (player.currentIndex == null) {
                return const SizedBox.shrink();
              }
              return const MiniPlayer();
            case ProcessingState.loading:
              return const ProgressBar();
            case ProcessingState.buffering:
              return const ProgressBar();
            default:
              return const MiniPlayer();
          }
        }
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const ProgressBar();
      },
    );
  }
}

class MiniPlayer extends HookConsumerWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showMusicPlayer(context);
      },
      onVerticalDragEnd: (details) {
        final primaryVelocity = details.primaryVelocity;

        if (primaryVelocity == null) {
          return;
        }

        if (primaryVelocity.abs().compareTo(100) < 0) {
          return;
        }

        if (primaryVelocity.isNegative) {
          // Swipe Up
          showMusicPlayer(context);
        }
      },
      child: const MusicControls(
        mini: true,
      ),
    );
  }

  Future<void> showMusicPlayer(BuildContext context) {
    return showBarModalBottomSheet(
      context: context,
      backgroundColor: FluentTheme.of(context).inactiveBackgroundColor,
      builder: (context) {
        return const MusicPlayer();
      },
    );
  }
}
