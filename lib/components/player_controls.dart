import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/audio_progress_bar.dart';
import 'package:tunes/components/now_playing_view.dart';
import 'package:tunes/components/player_btns.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PlayerProgressBar(),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RepeatBtn(),
            ShuffleBtn(),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PreviousBtn(
              alwaysShow: true,
            ),
            PlayPauseBtn(
              size: 72.0,
            ),
            NextBtn(
              alwaysShow: true,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FluentIcons.speaker_2_24_regular),
            ),
            const NowPlayingBtn(),
          ],
        ),
        // Spacer(),
      ],
    );
  }
}

class PlayerProgressBar extends ConsumerWidget {
  const PlayerProgressBar({
    super.key,
    this.color,
  });
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncPosition = ref.watch(playerPositionProvider);
    final textTheme = context.textTheme.labelMedium;
    final progressColor = color ?? context.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AudioProgressBar(
        trackHeight: 3.0,
        enabledThumbRadius: 10.0,
        activeTrackColor: progressColor.withOpacity(.8),
        inactiveTrackColor: progressColor.withOpacity(.6),
        thumbColor: progressColor,
        progressTextStyle: textTheme?.copyWith(
          color: progressColor.withOpacity(.7),
        ),
        totalTextStyle: textTheme?.copyWith(
          color: progressColor,
        ),
        durationDisplay: DurationDisplay.left,
        progress: asyncPosition.when(
          data: (data) => data,
          error: (error, stackTrace) => Duration.zero,
          loading: () => Duration.zero,
        ),
        total: player.duration ?? Duration.zero,
        onSeek: (value) async {
          await player.seek(value);
        },
        builder: (slider, progress, total) {
          return SizedBox(
            width: context.screenWidth,
            height: 100.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 28.0,
                  bottom: 15.0,
                  child: Text.rich(
                    TextSpan(
                      style: textTheme?.copyWith(
                        color: progressColor.withOpacity(.7),
                      ),
                      children: [
                        TextSpan(
                          text: progress,
                          style: textTheme?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: progressColor
                          ),
                        ),
                        const TextSpan(text: "  /  "),
                        TextSpan(text: total),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  width: context.screenWidth - 85,
                  child: slider,
                ),
                Positioned(
                  right: 8.0,
                  child: PlayPauseBtn(
                    size: 72.0,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
