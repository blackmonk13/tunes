import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/mini_progress.dart';
import 'package:tunes/components/player_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: context.screenWidth - 32.0,
      height: 80.0,
      gradient: LinearGradient(
        colors: [
          context.colorScheme.background.withOpacity(0.40),
          context.colorScheme.background.withOpacity(0.10)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: context.colorScheme.outline.withOpacity(.4),
      borderRadius: BorderRadius.circular(20.0),
      blur: 15.0,
      borderWidth: .7,
      elevation: 3.0,
      isFrostedGlass: true,
      shadowColor: Colors.black.withOpacity(0.20),
      alignment: Alignment.center,
      frostedOpacity: 0.12,
      padding: const EdgeInsets.all(8.0),
      child: const Row(
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
    );
  }
}

class NowPlayingInfo extends ConsumerWidget {
  const NowPlayingInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncCurrentSong = ref.watch(currentSongInfoProvider);
    const artworkSize = 64.0;
    final borderRadius = BorderRadius.circular(12.0);
    return asyncCurrentSong.when(
      data: (data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return Expanded(
          child: Row(
            children: [
              QueryArtworkWidget(
                controller: audioQuery,
                id: data.id,
                type: ArtworkType.AUDIO,
                artworkBorder: borderRadius,
                artworkHeight: artworkSize,
                artworkWidth: artworkSize,
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: borderRadius,
                  ),
                  width: artworkSize,
                  height: artworkSize,
                  child: Icon(
                    FluentIcons.music_note_2_24_regular,
                    color: context.colorScheme.onPrimaryContainer,
                    size: 32.0,
                  ),
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
                        data.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        data.artist ?? "No Artist",
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
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
