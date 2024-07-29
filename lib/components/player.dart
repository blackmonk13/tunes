import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/artwork_data_builder.dart';
import 'package:tunes/components/mini_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';
import 'package:tunes/views/songs_list_view.dart';

import 'artwork_gradient.dart';
import 'default_backdrop.dart';
import 'player_details_and_controls.dart';
import 'song_artwork.dart';

class PlayerView extends HookConsumerWidget {
  const PlayerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        final primaryVelocity = details.primaryVelocity;

        if (primaryVelocity == null) {
          return;
        }

        double velocityThreshold = 500;

        if (primaryVelocity < -velocityThreshold) {
          // Swipe Up detected
          showPlayerView(context);
        }
      },
      onTap: () {
        showPlayerView(context);
      },
      child: const MiniPlayer(),
    );
  }

  showPlayerView(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const PlayerPage();
      },
    );
  }
}

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    final artworkSize = context.screenHeight;
    final song = asyncCurrentSong.valueOrNull;

    return Stack(
      children: [
        const Positioned.fill(
          child: DefaultBackdrop(),
        ),
        Positioned(
          top: 0,
          width: context.shortestSide,
          height: context.shortestSide,
          child: song == null
              ? SongArtworkLoading(
                  width: context.shortestSide,
                  height: context.shortestSide,
                )
              : SongArtwork(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  size: context.shortestSide.toInt(),
                  width: context.shortestSide,
                  height: context.shortestSide,
                ),
        ),
        Positioned.fill(
          child: AnimatedCrossFade(
            firstChild: const DefaultBackdrop(),
            secondChild: song == null
                ? const DefaultBackdrop()
                : ArtworkGradient(
                    song: song,
                  ),
            crossFadeState: song == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: kThemeAnimationDuration,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: AnimatedCrossFade(
              firstChild: PlayerDetailsAndControls(
                song: song,
              ),
              secondChild: song == null
                  ? PlayerDetailsAndControls(
                      song: song,
                    )
                  : ArtworkDataBuilder(
                      id: song.id,
                      artworkType: ArtworkType.AUDIO,
                      nullWidget: PlayerDetailsAndControls(
                        song: song,
                      ),
                      builder: (image, palette) {
                        final foregroundColor = calculateFgColor(palette);

                        return PlayerDetailsAndControls(
                          song: song,
                          fgColor: foregroundColor,
                          bgColor: palette.dominantColor?.color,
                        );
                      },
                    ),
              crossFadeState: song == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: kThemeAnimationDuration,
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: 24,
          child: IconButton(
            onPressed: () async {
              if (song == null) return;
              await showModalBottomSheet<void>(
                context: context,
                backgroundColor: context.colorScheme.surfaceContainerHigh,
                showDragHandle: true,
                constraints: BoxConstraints(
                  minWidth: context.shortestSide,
                  maxWidth: context.shortestSide,
                  minHeight: 350.0,
                  maxHeight: 350.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  side: BorderSide(
                    color: context.colorScheme.outline.withOpacity(.3),
                  ),
                ),
                builder: (context) {
                  return SongTileOptions(
                    song: song,
                    songs: [song],
                    queue: false,
                  );
                },
              );
            },
            icon: const Icon(
              FluentIcons.options_24_regular,
            ),
          ),
        ),
      ],
    );
  }

  Widget _nullArtworkWidget(double artworkSize) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
          ),
          width: artworkSize,
          height: artworkSize,
          child: Icon(
            FluentIcons.music_note_2_24_regular,
            color: context.colorScheme.onPrimaryContainer,
            size: 72.0,
          ),
        );
      },
    );
  }
}
