import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/views/songs_list_view.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'package:tunes/components/player_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'mini_progress.dart';
import 'player_controls.dart';

class PlayerView extends HookConsumerWidget {
  const PlayerView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState(0);
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        final primaryVelocity = details.primaryVelocity;

        if (primaryVelocity == null) {
          return;
        }

        double velocityThreshold = 500;

        if (primaryVelocity < -velocityThreshold) {
          // Swipe Up detected
          showPlayerView(context, pageIndex);
        }
      },
      onTap: () {
        showPlayerView(context, pageIndex);
      },
      child: const MiniPlayer(),
    );
  }

  showPlayerView(
    BuildContext context,
    ValueNotifier<int> pageIndex,
  ) {
    return WoltModalSheet.show(
      context: context,
      useSafeArea: false,
      pageIndexNotifier: pageIndex,
      pageListBuilder: (context) {
        return [
          playerView(context, pageIndex),
          playlistView(context, pageIndex),
        ];
      },
    );
  }

  WoltModalSheetPage playerView(
    BuildContext context,
    ValueNotifier<int> pageIndex,
  ) {
    final artworkSize = context.screenHeight * .4;

    return WoltModalSheetPage(
      heroImageHeight: artworkSize,
      forceMaxHeight: true,
      heroImage: PlayerSongInfo(
        artworkSize: artworkSize,
      ),
      child: PlayerControls(
        onPlaylistPressed: () => pageIndex.value = 1,
      ),
    );
  }

  SliverWoltModalSheetPage playlistView(
    BuildContext context,
    ValueNotifier<int> pageIndex,
  ) {
    return SliverWoltModalSheetPage(
      forceMaxHeight: true,
      leadingNavBarWidget: IconButton(
        onPressed: () => pageIndex.value = 0,
        icon: const Icon(
          FluentIcons.arrow_left_24_filled,
        ),
      ),
      mainContentSlivers: [
        const SliverAppBar(
          automaticallyImplyLeading: false,
          primary: false,
          title: Text("Now Playing"),
        ),
        const NowPlayingList(),
      ],
      stickyActionBar: const MiniPlayer()
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
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

class NowPlayingList extends ConsumerWidget {
  const NowPlayingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingController = ref.watch(nowPlayingControllerProvider);
    return AsyncSongsSliverListView(
      asyncSongs: nowPlayingController,
    );
  }
}
