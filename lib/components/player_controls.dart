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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncPosition = ref.watch(playerPositionProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AudioProgressBar(
        textStyle: context.textTheme.labelSmall?.copyWith(
          color: context.textTheme.labelSmall?.color?.withOpacity(.7),
        ),
        durationDisplay: DurationDisplay.bottom,
        progress: asyncPosition.when(
          data: (data) => data,
          error: (error, stackTrace) => Duration.zero,
          loading: () => Duration.zero,
        ),
        total: player.duration ?? Duration.zero,
        onSeek: (value) async {
          await player.seek(value);
        },
      ),
    );
  }
}
