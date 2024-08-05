import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/artwork_data_builder.dart';
import 'package:tunes/components/mini_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';
import 'package:tunes/views/songs_list_view.dart';

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
      // backgroundColor: Colors.transparent,
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
    final song = asyncCurrentSong.valueOrNull;

    return Stack(
      children: [
        Positioned(
          top: 0,
          width: context.shortestSide,
          height: context.shortestSide,
          child: song == null
              ? SongArtworkLoading(
                  width: context.shortestSide,
                  height: context.shortestSide,
                )
              : Hero(
                  tag: "player_img",
                  child: Thumbnail(
                    thumbnail: song.thumbnailPath,
                    width: context.shortestSide,
                    height: context.shortestSide,
                    filterQuality: FilterQuality.high,
                  ),
                ),
        ),
        Positioned.fill(
          child: ThumbnailDataBuilder(
            thumbnail: song?.thumbnailPath,
            builder: (image, palette) {
              final bgColor =
                  palette.dominantColor?.color ?? context.colorScheme.surface;
              final foregroundColor = calculateFgColor(palette);
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      .3,
                      .35,
                      .4,
                    ],
                    colors: [
                      Colors.transparent,
                      bgColor.withOpacity(.4),
                      bgColor,
                    ],
                  ),
                ),
                child: AnimatedCrossFade(
                  firstChild: PlayerDetailsAndControls(
                    song: song,
                  ),
                  secondChild: song == null
                      ? PlayerDetailsAndControls(
                          song: song,
                        )
                      : PlayerDetailsAndControls(
                          song: song,
                          fgColor: foregroundColor,
                          bgColor: palette.dominantColor?.color,
                        ),
                  crossFadeState: song == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: kThemeAnimationDuration,
                ),
              );
            },
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
                backgroundColor: context.colorScheme.outlineVariant,
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

}
