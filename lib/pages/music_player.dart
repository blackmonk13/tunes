import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sheet/sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/current_builder.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  final SheetController controller = SheetController();
  Audio? currently;
  @override
  Widget build(BuildContext context) {
    ref.watch(playerStateProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          PlayingNowOrPreviousBuilder(
            builder: (context, artwork, title, album, artist, filepath) {
              return SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: context.screenHeight * .5,
                // title: Text(album ?? ""),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  titlePadding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  title: SafeArea(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "$title\n"),
                          TextSpan(text: "$artist / $album\n"),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: _currentArtwork(artwork),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: .3,
                            sigmaY: .3,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.colorScheme.surface.withOpacity(
                                    .7,
                                  ),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            primary: false,
            pinned: true,
            title: _progressBar(),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LoopButton(),
                IconButton(
                  onPressed: () {},
                  icon: const HeroIcon(HeroIcons.heart),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    ref.watch(playpositionProvider);
                    return IconButton(
                      onPressed: () {
                        player.toggleShuffle();
                      },
                      icon: HeroIcon(
                        HeroIcons.arrowsRightLeft,
                        color:
                            player.shuffle ? context.colorScheme.primary : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            primary: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(42.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      await player.previous();
                    },
                    icon: const HeroIcon(HeroIcons.previous),
                  ),
                  _playPauseBtn(),
                  IconButton(
                    onPressed: () async {
                      await player.next();
                    },
                    icon: const HeroIcon(HeroIcons.next),
                  ),
                ],
              ),
            ),
          ),
          _nowPlayingPlaylist(),
        ],
      ),
    );
  }

  Widget _nowPlayingPlaylist() {
    final playlistItems = player.playlist?.audios.reversed.toList();
    if (playlistItems == null) {
      return const SliverToBoxAdapter();
    }
    return PlayingNowOrPreviousBuilder(
      builder: (context, artwork, title, album, artist, filepath) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final realIndex =
                  player.playlist?.audios.indexOf(playlistItems[index]) ?? 0;
              return SongTile(
                selected: playlistItems[index].path == filepath,
                audio: playlistItems[index],
                onTap: () async {
                  player.stop();
                  player.playlistPlayAtIndex(realIndex);
                  await player.seek(
                    Duration.zero,
                  );
                  // player.play();
                },
              );
            },
            childCount: playlistItems.length,
          ),
        );
      },
    );
  }

  Widget _currentArtwork(Uint8List? artwork) {
    if (artwork == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.primaryContainer,
              context.colorScheme.secondaryContainer,
            ],
          ),
        ),
      );
    }
    return Image.memory(
      artwork,
      fit: BoxFit.cover,
    );
  }

  Widget _playPauseBtn() {
    return player.builderIsPlaying(builder: (context, isPlaying) {
      return IconButton(
        onPressed: () async {
          if (isPlaying) {
            await player.pause();
            return;
          }
          await player.play();
        },
        icon: HeroIcon(
          isPlaying ? HeroIcons.pauseCircle : HeroIcons.playCircle,
          style: HeroIconStyle.solid,
          size: context.screenWidth * .2,
        ),
      );
    });
  }

  Widget _progressBar() {
    return player.builderCurrentPosition(
      builder: (context, position) {
        final duration = player.current.valueOrNull?.audio.duration;
        return ProgressBar(
          progressBarColor: context.colorScheme.primary,
          thumbColor: context.colorScheme.primary,
          timeLabelTextStyle: context.textTheme.bodySmall,
          barHeight: 3.0,
          thumbRadius: 6.0,
          progress: position,
          total: duration ?? Duration.zero,
          onSeek: (duration) {
            player.seek(duration);
          },
        );
      },
    );
  }
}

class LoopButton extends ConsumerWidget {
  const LoopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return player.builderLoopMode(
      builder: (context, loopMode) {
        return IconButton(
          onPressed: () async {
            switch (loopMode) {
              case LoopMode.none:
                await player.setLoopMode(LoopMode.single);
                break;
              case LoopMode.single:
                await player.setLoopMode(LoopMode.none);
                break;
              default:
                await player.setLoopMode(LoopMode.playlist);
                break;
            }
          },
          icon: Stack(
            alignment: Alignment.center,
            children: [
              HeroIcon(
                HeroIcons.arrowPathRoundedSquare,
                color: loopMode == LoopMode.none
                    ? null
                    : context.colorScheme.primary,
              ),
              if (loopMode == LoopMode.single)
                Text(
                  "1",
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: loopMode == LoopMode.none
                        ? null
                        : context.colorScheme.primary,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
