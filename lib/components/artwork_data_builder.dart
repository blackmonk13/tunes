import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tunes/providers/providers.dart';

class ThumbnailDataBuilder extends ConsumerWidget {
  const ThumbnailDataBuilder({
    super.key,
    required this.builder,
    this.thumbnail,
    this.nullWidget,
    this.errorBuilder,
    this.loadingWidget,
  });

  final String? thumbnail;
  final Widget? nullWidget;
  final Widget Function(Object error, StackTrace stackTrace)? errorBuilder;
  final Widget? loadingWidget;
  final Widget Function(FileImage image, PaletteGenerator palette) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArtworkData = ref.watch(thumbnailDataProvider(
      thumbnail,
    ));
    return asyncArtworkData.when(
      data: (data) {
        if (data == null) {
          return nullWidget ?? const SizedBox.shrink();
        }

        return builder(data.image, data.palette);
      },
      error: (error, stackTrace) {
        return errorBuilder?.call(error, stackTrace) ?? const SizedBox.shrink();
      },
      loading: () {
        return loadingWidget ?? const SizedBox.shrink();
      },
    );
  }
}
