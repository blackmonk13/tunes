import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tunes/components/player/audio_progress_bar.dart';
import 'package:tunes/components/player/next_btn.dart';
import 'package:tunes/components/player/play_pause_btn.dart';
import 'package:tunes/components/player/repeat_btn.dart';
import 'package:tunes/components/player/shuffle_btn.dart';
import 'package:tunes/components/songs/list_view/song_tile.dart';
import 'package:tunes/models/tunesong.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class MusicControls extends HookConsumerWidget {
  const MusicControls({
    super.key,
    required this.mini,
  });
  final bool mini;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerStateProvider);
    final player = ref.watch(audioPlayerProvider);
    final asyncPlayerPosition = ref.watch(playerPositionProvider);
    final playlistController = ref.watch(playlistControllerProvider);

    return Hero(
      tag: 'music_controls',
      child: Acrylic(
        luminosityAlpha: .3,
        tint: FluentTheme.of(context).resources.solidBackgroundFillColorBase,
        blurAmount: 10,
        elevation: 30.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(3.0),
          ),
        ),
        child: SizedBox(
          width: context.screenWidth,
          height: context.screenHeight * (mini ? .1 : .13),
          child: Column(
            children: [
              SizedBox(
                width: context.screenWidth * .96,
                child: asyncPlayerPosition.when(
                  data: (position) {
                    final currentIndex = player.currentIndex;

                    if (currentIndex == null) {
                      return const ProgressBar(
                        value: 0,
                      );
                    }

                    final currentTotalDuration = playlistController.sequence
                        .elementAtOrNull(currentIndex)
                        ?.duration;

                    if (currentTotalDuration == null) {
                      return const ProgressBar(
                        value: 0,
                      );
                    }

                    return AudioProgressBar(
                      progress: position,
                      total: currentTotalDuration,
                      durationDisplay:
                          mini ? DurationDisplay.none : DurationDisplay.bottom,
                      onSeek: (value) async {
                        await player.seek(value);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return const ProgressBar(
                      value: 0,
                    );
                  },
                  loading: () {
                    return const ProgressBar();
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (mini) ...[
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 14.0,
                          ),
                          // Artwork
                          child: Container(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            decoration: BoxDecoration(
                              color: FluentTheme.of(context)
                                  .inactiveBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                            ),
                            child: const Icon(
                              FluentIcons.music_note_2_24_regular,
                              size: 32,
                            ),
                          ),
                        ),
                        const MusicTextInfo(),
                      ],
                      if (!mini) ...[
                        const RepeatBtn(),
                        const Spacer(),
                        const PreviousBtn(
                          size: 32.0,
                          alwaysShow: true,
                        ),
                      ],
                      PlayPauseBtn(
                        size: mini ? 46.0 : 56.0,
                      ),
                      NextBtn(
                        size: mini ? 24.0 : 32.0,
                        alwaysShow: !mini,
                      ),
                      if (!mini) ...[
                        const Spacer(),
                        const ShuffleBtn(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MusicTextInfo extends HookConsumerWidget {
  const MusicTextInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerStateProvider);
    final player = ref.watch(audioPlayerProvider);
    ref.watch(playerPositionProvider);
    final playlistController = ref.watch(playlistControllerProvider);

    final currentIndex = player.currentIndex;

    if (currentIndex == null) {
      return const SizedBox.shrink();
    }
    final mediaItem = playlistController.sequence
        .elementAtOrNull(currentIndex)
        ?.tag as MediaItem?;

    if (mediaItem == null) {
      return const SizedBox.shrink();
    }

    final tuneSong = mediaItem.extras!['song'] as TuneSong;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleText(
            tuneSong: tuneSong,
          ),
          const SizedBox(
            height: 6.0,
          ),
          ArtistText(
            tuneSong: tuneSong,
          ),
        ],
      ),
    );
  }
}