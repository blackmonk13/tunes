import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sheet/sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/current_builder.dart';
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
  final SheetController controller = SheetController();
  Audio? currently;
  @override
  Widget build(BuildContext context) {
    ref.watch(playerStateProvider);

    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: context.screenHeight * .1,
                left: 16.0,
                right: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.getCurrentAudioAlbum,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      player.getCurrentAudioTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      player.getCurrentAudioArtist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _playingNowInfo(),
                    _progressBar(),
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
                            controller.relativeAnimateTo(
                              .6,
                              duration: kThemeAnimationDuration,
                              curve: Curves.easeInOut,
                            );
                            return;
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
                    const Text(
                      "",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Sheet(
            controller: controller,
            physics: const SnapSheetPhysics(
              stops: <double>[0, 0.6, 1],
            ),
            child: PlaylistSongs(
              onClose: () {
                controller.relativeAnimateTo(
                  0.0,
                  duration: kThemeAnimationDuration,
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _playingNowInfo() {
    return PlayingNowOrPreviousBuilder(
      builder: (context, artwork, title, album, artist) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(
                20.0,
              ),
              image: artwork == null
                  ? null
                  : DecorationImage(
                      image: Image.memory(artwork).image,
                    ),
            ),
            child: artwork == null
                ? const Icon(
                    Icons.music_note,
                    size: 50,
                  )
                : null,
          ),
        );
      },
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
