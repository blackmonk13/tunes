import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/pages/music_player.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class CollapsedPlayer extends ConsumerStatefulWidget {
  const CollapsedPlayer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CollapsedPlayer> createState() => _CollapsedPlayerState();
}

class _CollapsedPlayerState extends ConsumerState<CollapsedPlayer> {
  @override
  Widget build(BuildContext context) {
    ref.watch(playerStateProvider);
    final playlist = ref.watch(nowPlayingPlaylistProvider);
    final height = context.screenHeight * .1;

    if (playlist.audios.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onVerticalDragEnd: (details) {
        final pvel = details.primaryVelocity;
        if (pvel == null) {
          return;
        }

        if (pvel.isNegative) {
          Navigator.of(context).push(
            SheetRoute(
              builder: (context) => const MusicPlayer(),
            ),
          );
        }
      },
      child: Container(
        width: context.screenWidth,
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.background,
        ),
        child: Column(
          children: [
            const MiniProgressBar(),
            Row(
              children: [
                Expanded(
                  child: player.builderCurrent(
                    builder: (context, playing) {
                      final artWork =
                          playing.audio.audio.metas.extra?['artWork'];
                      return ListTile(
                        dense: true,
                        onTap: () {
                          Navigator.of(context).push(
                            SheetRoute(
                              physics: const AlwaysDraggableSheetPhysics(),
                              builder: (context) => const MusicPlayer(),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              artWork == null ? null : Image.memory(artWork).image,
                          child: artWork == null
                              ? const Icon(
                                  Icons.music_note_outlined,
                                )
                              : null,
                        ),
                        title: Text(
                          player.getCurrentAudioTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          player.getCurrentAudioArtist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                  ),
                ),
                _playPauseButton(height),
                IconButton(
                  icon: HeroIcon(
                    HeroIcons.next,
                    size: height * .3,
                    style: HeroIconStyle.solid,
                  ),
                  onPressed: () async {
                    await player.next(stopIfLast: true);
                    
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _playPauseButton(double height) {
    return player.builderIsPlaying(
      builder: (context, isPlaying) {
        return IconButton(
          icon: HeroIcon(
            isPlaying ? HeroIcons.pause : HeroIcons.play,
            style: HeroIconStyle.solid,
            size: height * .5,
          ),
          onPressed: () async {
            if (isPlaying) {
              await player.pause();
              return;
            }
            await player.play();
          },
        );
      },
    );
  }
}

class MiniProgressBar extends StatelessWidget {
  const MiniProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return player.builderCurrentPosition(
      builder: (context, position) {
        final duration =
            player.current.valueOrNull?.audio.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == null ? 0 : position.inMilliseconds / duration,
          minHeight: 3,
          color: context.colorScheme.primary,
        );
      },
    );
  }
}
