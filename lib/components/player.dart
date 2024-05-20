import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tunes/components/audio_progress_bar.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'package:tunes/components/player_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class PlayerView extends ConsumerWidget {
  const PlayerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        final primaryVelocity = details.primaryVelocity;

        if (primaryVelocity == null) {
          return;
        }

        double velocityThreshold = 500;

        if (primaryVelocity < -velocityThreshold) {
          // Swipe Up detected
          showPlayerView(asyncCurrentSong, context, audioQuery);
        }
      },
      onTap: () {
        showPlayerView(asyncCurrentSong, context, audioQuery);
      },
      child: GlassContainer(
        width: context.screenWidth - 32.0,
        height: 80.0,
        gradient: LinearGradient(
          colors: [
            context.colorScheme.background.withOpacity(0.40),
            context.colorScheme.background.withOpacity(0.10)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: context.colorScheme.outline.withOpacity(.4),
        borderRadius: BorderRadius.circular(20.0),
        blur: 15.0,
        borderWidth: .7,
        elevation: 3.0,
        isFrostedGlass: true,
        shadowColor: Colors.black.withOpacity(0.20),
        alignment: Alignment.center,
        frostedOpacity: 0.12,
        padding: const EdgeInsets.all(8.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NowPlayingInfo(),
            SizedBox.square(
              dimension: 60.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: MiniProgress(),
                    ),
                  ),
                  Positioned.fill(
                    child: PlayPauseBtn(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AsyncValue<void> showPlayerView(AsyncValue<SongModel?> asyncCurrentSong,
      BuildContext context, OnAudioQuery audioQuery) {
    return asyncCurrentSong.whenData((value) {
      if (value == null) {
        return;
      }
      WoltModalSheet.show(
        context: context,
        useSafeArea: false,
        pageListBuilder: (context) {
          return [
            playerView(audioQuery, value, context),
          ];
        },
      );
    });
  }

  SliverWoltModalSheetPage playerView(
    OnAudioQuery audioQuery,
    SongModel value,
    BuildContext context,
  ) {
    final artworkSize = context.screenHeight * .4;
    final borderRadius = BorderRadius.circular(5.0);

    return SliverWoltModalSheetPage(
      heroImageHeight: artworkSize,
      forceMaxHeight: true,
      heroImage: Stack(
        children: [
          Positioned.fill(
            child: QueryArtworkWidget(
              controller: audioQuery,
              id: value.id,
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
                      value.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge,
                    ),
                    Text(
                      value.artist ?? "Unknown Artist",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.textTheme.labelSmall?.color
                            ?.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      mainContentSlivers: [
        const SliverToBoxAdapter(
          child: Column(
            children: [
              PlayerProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RepeatBtn(),
                  ShuffleBtn(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PreviousBtn(
                    alwaysShow: true,
                  ),
                  PlayPauseBtn(
                    size: 72.0,
                  ),
                  NextBtn(
                    alwaysShow: true,
                  ),
                ],
              ),
              // Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerProgressBar extends ConsumerWidget {
  const PlayerProgressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncPosition = ref.watch(playerPositionProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AudioProgressBar(
        textStyle: context.textTheme.labelSmall?.copyWith(
          color: context.textTheme.labelSmall?.color?.withOpacity(.7),
        ),
        durationDisplay: DurationDisplay.bottom,
        progress: asyncPosition.when(
          data: (data) => data,
          error: (error, stackTrace) => Duration.zero,
          loading: () => Duration.zero,
        ),
        total: player.duration ?? Duration.zero,
        onSeek: (value) async {
          await player.seek(value);
        },
      ),
    );
  }
}

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

class NowPlayingInfo extends ConsumerWidget {
  const NowPlayingInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    const artworkSize = 64.0;
    final borderRadius = BorderRadius.circular(12.0);
    return asyncCurrentSong.when(
      data: (data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return Expanded(
          child: Row(
            children: [
              QueryArtworkWidget(
                controller: audioQuery,
                id: data.id,
                type: ArtworkType.AUDIO,
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
                    size: 32.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        data.artist ?? "No Artist",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall?.copyWith(
                            color: context.textTheme.labelSmall?.color
                                ?.withOpacity(.7)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
