import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/playlist_songs.dart';
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
  bool get isPlaying {
    return player.playerState.playing &&
        player.playerState.processingState != ProcessingState.completed;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(playpositionProvider);
    ref.watch(playerStateProvider);
    final playlist = ref.watch(playlistProvider);
    final nowPlaying = ref.watch(nowPlayingProvider);

    final artWork = nowPlaying?.artWork;

    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(getAlbum(nowPlaying) ?? ""),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                        image: artWork == null
                            ? null
                            : DecorationImage(
                                image: Image.memory(artWork).image,
                              ),
                      ),
                      child: artWork == null
                          ? const Icon(
                              Icons.music_note,
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: Text(
                      getTitle(nowPlaying) ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      getArtist(nowPlaying) ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ProgressBar(
                    progressBarColor: context.colorScheme.primary,
                    thumbColor: context.colorScheme.primary,
                    timeLabelTextStyle: context.textTheme.bodySmall,
                    barHeight: 3.0,
                    thumbRadius: 6.0,
                    progress: player.position,
                    buffered: player.bufferedPosition,
                    total: player.duration ?? Duration.zero,
                    onSeek: (duration) {
                      player.seek(duration);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LoopButton(),
                      IconButton(
                        onPressed: () {},
                        icon: const HeroIcon(HeroIcons.heart),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            SheetRoute(
                              initialExtent: .6,
                              fit: SheetFit.loose,
                              stops: [0, .6, .9],
                              builder: (context) {
                                return const PlaylistSongs();
                              },
                            ),
                          );

                          // showMaterialModalBottomSheet(
                          //   context: context,
                          //   builder: (context) {

                          //   },
                          // );
                        },
                        icon: const HeroIcon(HeroIcons.queueList),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await player.seekToPrevious();
                        },
                        icon: const HeroIcon(HeroIcons.previous),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await player.pause();
                            return;
                          }
                          await player.play();
                        },
                        icon: HeroIcon(
                          isPlaying
                              ? HeroIcons.pauseCircle
                              : HeroIcons.playCircle,
                          style: HeroIconStyle.solid,
                          size: context.screenWidth * .2,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await player.seekToNext();
                        },
                        icon: const HeroIcon(HeroIcons.next),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(testText(playlist)),
            ),
          )
        ],
      ),
    );
  }

  String testText(ConcatenatingAudioSource playlist) {
    return "testing 123";
  }
}

class LoopButton extends ConsumerWidget {
  const LoopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<LoopMode>(
      stream: player.loopModeStream,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () async {
            switch (player.loopMode) {
              case LoopMode.all:
                await player.setLoopMode(LoopMode.one);
                break;
              case LoopMode.one:
                await player.setLoopMode(LoopMode.off);
                break;
              default:
                await player.setLoopMode(LoopMode.all);
                break;
            }
          },
          icon: Stack(
            alignment: Alignment.center,
            children: [
              HeroIcon(
                HeroIcons.arrowPathRoundedSquare,
                color: player.loopMode == LoopMode.off
                    ? null
                    : context.colorScheme.primary,
              ),
              if (player.loopMode == LoopMode.one)
                Text(
                  "1",
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: player.loopMode == LoopMode.off
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
