import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/mini_progress.dart';
import 'package:tunes/components/player_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'song_artwork.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: context.shortestSide - 16.0,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: context.colorScheme.outlineVariant,
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
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
}

class NowPlayingInfo extends ConsumerWidget {
  const NowPlayingInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    const artworkSize = 64.0;
    final borderRadius = BorderRadius.circular(25.0);

    final currentSong = asyncCurrentSong.valueOrNull;
    final error = asyncCurrentSong.error;

    if (error != null) {
      return const SizedBox.shrink();
    }

    if (currentSong == null && error == null) {
      return const SizedBox.shrink();
    }

    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Row(
        children: [
          Hero(
            tag: "player_img",
            child: Thumbnail(
              thumbnail: currentSong.thumbnailMiniPath,
              width: artworkSize,
              height: artworkSize,
              borderRadius: borderRadius,
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
                    currentSong.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    currentSong.artist,
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
  }
}
