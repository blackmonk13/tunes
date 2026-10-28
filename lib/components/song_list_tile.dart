import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tunes/components/song_artwork.dart';

import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

class SongListTile extends ConsumerWidget {
  final Song song;
  final void Function(Song song)? onTap;
  final void Function(Song song)? onLongPress;
  final void Function(Song song)? onDoubleTap;
  final Color? color;
  final Widget? trailing;
  const SongListTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.color = Colors.transparent,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onTap?.call(song),
      onLongPress: () => onLongPress?.call(song),
      onDoubleTap: () => onDoubleTap?.call(song),
      child: Card(
        elevation: 0.0,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Thumbnail(
                thumbnail: song.thumbnailMiniPath,
                width: 50,
                height: 50,
                hasBorder: true,
                borderRadius: BorderRadius.circular(20.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        song.artist.value?.name ?? 'Unknown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (() {
                          final textTheme = context.textTheme.labelSmall;
                          return textTheme?.copyWith(
                            color: textTheme.color?.withOpacity(.7),
                          );
                        })(),
                      ),
                      // Text("${song.thumbnailPath}"),
                    ],
                  ),
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class SongListTileLoading extends StatelessWidget {
  const SongListTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Colors.transparent;
    final width = context.screenWidth * .5;
    return Card(
      elevation: 0.0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SongArtworkLoading(
              width: 50,
              height: 50,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: context.colorScheme.outline.withOpacity(.5),
                      highlightColor:
                          context.colorScheme.outline.withOpacity(.8),
                      child: Container(
                        width: width,
                        height: context.textTheme.bodyLarge?.fontSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: context.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Shimmer.fromColors(
                      baseColor: context.colorScheme.outline.withOpacity(.5),
                      highlightColor:
                          context.colorScheme.outline.withOpacity(.8),
                      child: Container(
                        width: width * .8,
                        height: context.textTheme.labelSmall?.fontSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: context.textTheme.labelSmall?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
