
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class Thumbnail extends ConsumerWidget {
  const Thumbnail({
    super.key,
    this.thumbnail,
    this.height,
    this.width,
    this.borderRadius,
    this.hasBorder = false,
    this.filterQuality = FilterQuality.low,
  });
  final String? thumbnail;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final bool hasBorder;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThumbnailData = ref.watch(thumbnailDataProvider(thumbnail));
    final gradient = RadialGradient(
      colors: [
        context.colorScheme.primaryContainer.withOpacity(0.9),
        context.colorScheme.primaryContainer.withOpacity(0.1),
      ],
    );

    final border = hasBorder
        ? Border.all(
            color: context.colorScheme.outline.withOpacity(.3),
            width: .5,
          )
        : null;

    final hasSize = width != null && height != null;

    return asyncThumbnailData.when(
      data: (data) {
        if (data == null) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: borderRadius,
              border: border,
            ),
            child: ArtworkIcon(
              size: width ?? height,
            ),
          );
        }
        ImageProvider imageProvider = !hasSize
            ? data.image as ImageProvider
            : ResizeImage(
                width: width?.toInt(),
                height: height?.toInt(),
                data.image,
              );
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: filterQuality,
              fit: BoxFit.cover,
              image: imageProvider,
            ),
            color: data.palette.dominantColor?.color,
            borderRadius: borderRadius,
            border: border,
          ),
        );
      },
      error: (error, stackTrace) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
            border: border,
          ),
          child: ArtworkIcon(
            size: width ?? height,
          ),
        );
      },
      loading: () {
        return SongArtworkLoading(
          height: height,
          width: width,
        );
      },
    );
  }
}

class SongArtwork extends ConsumerWidget {
  final int id;
  final ArtworkType type;
  final int size;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final bool hasBorder;
  const SongArtwork({
    super.key,
    required this.id,
    required this.type,
    this.size = 200,
    this.height,
    this.width,
    this.borderRadius,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArtworkData = ref.watch(artworkDataProvider(
      id,
      type,
      size: size,
    ));

    final gradient = RadialGradient(
      colors: [
        context.colorScheme.primaryContainer.withOpacity(0.9),
        context.colorScheme.primaryContainer.withOpacity(0.1),
      ],
    );

    final border = hasBorder
        ? Border.all(
            color: context.colorScheme.outline.withOpacity(.3),
            width: .5,
          )
        : null;

    return asyncArtworkData.when(
      data: (data) {
        if (data == null) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: borderRadius,
              border: border,
            ),
            child: ArtworkIcon(
              size: width ?? height,
            ),
          );
        }
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              image: MemoryImage(
                data.image,
              ),
            ),
            color: data.palette.dominantColor?.color,
            borderRadius: borderRadius,
            border: border,
          ),
        );
      },
      error: (error, stackTrace) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
            border: border,
          ),
          child: ArtworkIcon(
            size: width ?? height,
          ),
        );
      },
      loading: () {
        return SongArtworkLoading(
          height: height,
          width: width,
        );
      },
    );
  }
}

class SongArtworkLoading extends ConsumerWidget {
  const SongArtworkLoading({
    super.key,
    this.width,
    this.height,
  });
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradient = RadialGradient(
      colors: [
        context.colorScheme.primaryContainer.withOpacity(0.9),
        context.colorScheme.primaryContainer.withOpacity(0.1),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(.3),
          width: .5,
        ),
      ),
      child: Shimmer(
        gradient: gradient,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: ArtworkIcon(
            size: width ?? height,
          ),
        ),
      ),
    );
  }
}

class ArtworkIcon extends StatelessWidget {
  const ArtworkIcon({
    super.key,
    this.size,
  });
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      FluentIcons.music_note_2_24_filled,
      size: size == null ? null : size! * .6,
    );
  }
}
