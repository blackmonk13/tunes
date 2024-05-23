import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class SongListTile extends ConsumerWidget {
  final SongModel song;
  final void Function(SongModel song)? onTap;
  final void Function(SongModel song)? onLongPress;
  final void Function(SongModel song)? onDoubleTap;
  const SongListTile({
    super.key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    return GestureDetector(
      onTap: () => onTap?.call(song),
      onLongPress: () => onLongPress?.call(song),
      onDoubleTap: () => onDoubleTap?.call(song),
      child: Card(
        elevation: 0.0,
        color: context.colorScheme.surface,
        child: Row(
          children: [
            QueryArtworkWidget(
              controller: audioQuery,
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(20.0),
              nullArtworkWidget: GlassContainer(
                height: 50,
                width: 50,
                borderColor: context.colorScheme.outline.withOpacity(.3),
                borderRadius: BorderRadius.circular(20.0),
                gradient: RadialGradient(
                  colors: [
                    context.colorScheme.primaryContainer.withOpacity(0.40),
                    context.colorScheme.primaryContainer.withOpacity(0.10)
                  ],
                ),
                child: Icon(
                  FluentIcons.music_note_2_24_regular,
                  color: context.colorScheme.onPrimaryContainer,
                  size: 32.0,
                ),
              ),
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
                      song.artist ?? "No Artist",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (() {
                        final textTheme = context.textTheme.labelSmall;
                        return textTheme?.copyWith(
                          color: textTheme.color?.withOpacity(.7),
                        );
                      })(),
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
