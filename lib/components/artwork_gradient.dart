import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/artwork_data_builder.dart';
import 'package:tunes/utils/extensions.dart';

import 'default_backdrop.dart';

class ArtworkGradient extends ConsumerWidget {
  final SongModel song;
  const ArtworkGradient({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArtworkDataBuilder(
      id: song.id,
      artworkType: ArtworkType.AUDIO,
      size: context.screenHeight.toInt(),
      nullWidget: const DefaultBackdrop(),
      errorBuilder: (error, stackTrace) {
        return const DefaultBackdrop();
      },
      loadingWidget: const DefaultBackdrop(),
      builder: (image, palette) {
        final dominantColor = palette.dominantColor;

        if (dominantColor == null) {
          return const DefaultBackdrop();
        }
        return Container(
          decoration: BoxDecoration(
            // color: data.palette.dominantColor?.color,
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(.4),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0,
                .4,
                .45,
              ],
              colors: [
                Colors.transparent,
                dominantColor.color.withOpacity(.9),
                dominantColor.color,
              ],
            ),
          ),
        );
      },
    );
  }
}
