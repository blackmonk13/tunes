import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/components/mini_player.dart';
import 'package:tunes/components/player_controls.dart';


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
    return WoltModalSheet.show(
      context: context,
      useSafeArea: false,
      pageListBuilder: (context) {
        return [
          playerView(context),
        ];
      },
    );
  }

  WoltModalSheetPage playerView(
    BuildContext context,
  ) {
    final artworkSize = context.screenHeight * .4;

    return WoltModalSheetPage(
      heroImageHeight: artworkSize,
      forceMaxHeight: true,
      heroImage: PlayerSongInfo(
        artworkSize: artworkSize,
      ),
      child: const PlayerControls(
      ),
    );
  }
}

class PlayerSongInfo extends ConsumerWidget {
  const PlayerSongInfo({
    super.key,
    required this.artworkSize,
  });

  final double artworkSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    final borderRadius = BorderRadius.circular(5.0);
    return asyncCurrentSong.when(
      data: (data) {
        if (data == null) {
          // FIXME:
          return const SizedBox.shrink();
        }
        return Stack(
          children: [
            Positioned.fill(
              child: QueryArtworkWidget(
                controller: audioQuery,
                id: data.id,
                type: ArtworkType.AUDIO,
                size: artworkSize.toInt(),
                quality: 100,
                artworkQuality: FilterQuality.high,
                artworkBorder: borderRadius,
                artworkHeight: artworkSize,
                artworkWidth: artworkSize,
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: borderRadius,
                  ),
                  width: artworkSize,
                  height: artworkSize,
                  child: Icon(
                    FluentIcons.music_note_2_24_regular,
                    color: context.colorScheme.onPrimaryContainer,
                    size: 72.0,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.colorScheme.background.withOpacity(.3),
                      context.colorScheme.background.withOpacity(.7),
                      context.colorScheme.background,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge,
                      ),
                      // TODO: Link to ArtistPage
                      Text(
                        data.artist ?? "Unknown Artist",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.textTheme.labelSmall?.color
                              ?.withOpacity(.7),
                        ),
                      ),
                      // TODO: Show Albums with link to corresponding page
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        // FIXME:
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        // TODO: Shimmer
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      },
    );
  }
}
