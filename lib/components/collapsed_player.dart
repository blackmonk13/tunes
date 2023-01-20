import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sheet/route.dart';
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
    final height = context.screenHeight * .1;

    final artWork = nowPlaying?.artWork;

    if (nowPlaying == null) {
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
        print(details.primaryVelocity);
      },
      child: Container(
        width: context.screenWidth,
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.background,
        ),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: playPos ?? 0,
              minHeight: 3,
              color: context.colorScheme.primary,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).push(
                        SheetRoute(
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
                ),
                IconButton(
                  icon: HeroIcon(
                    isPlaying ? HeroIcons.pause : HeroIcons.play,
                    style: HeroIconStyle.solid,
                    size: height * .5,
                  ),
                  onPressed: () async {
                    if (player.playing) {
                      await player.pause();
                      return;
                    }
                    await player.play();
                  },
                ),
                IconButton(
                  icon: HeroIcon(
                    HeroIcons.next,
                    size: height * .3,
                    style: HeroIconStyle.solid,
                  ),
                  onPressed: () async {
                    await player.seekToNext();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double? get playPos {
    final drt = player.duration?.inMilliseconds;
    if (drt == null) {
      return null;
    }
    return player.position.inMilliseconds / drt;
  }
}
