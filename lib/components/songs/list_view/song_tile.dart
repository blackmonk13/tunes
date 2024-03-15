import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:tunes/models/tunesong.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class SongTile extends HookConsumerWidget {
  const SongTile({
    super.key,
    required this.tuneSong,
    this.selected = false,
  });

  final TuneSong tuneSong;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final playlist = ref.watch(playlistControllerProvider);

    return ListTile.selectable(
      selected: selected,
      onPressed: () {
        ref.read(playlistControllerProvider.notifier).addSong(tuneSong);
        if (player.audioSource != playlist) {
          player.setAudioSource(playlist);
        }

        // player.audioSource?.sequence.indexWhere((element) => element.)
        if (player.playing) {
          return;
        }
        player.play();
      },
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Icon(
          FluentIcons.music_note_2_24_regular,
          size: 32,
        ),
      ),
      title: TitleText(
        tuneSong: tuneSong,
      ),
      subtitle: ArtistText(
        tuneSong: tuneSong,
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.tuneSong,
  });

  final TuneSong tuneSong;

  @override
  Widget build(BuildContext context) {
    return Text(
      tuneSong.songInfo.title ??
          basenameWithoutExtension(tuneSong.songInfo.pathname),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class ArtistText extends StatelessWidget {
  const ArtistText({
    super.key,
    required this.tuneSong,
  });

  final TuneSong tuneSong;

  @override
  Widget build(BuildContext context) {
    return Text(
      tuneSong.artistInfo?.name ?? "Unknown",
      style: TextStyle(
        color: context.textTheme.bodySmall?.color?.withOpacity(
          .5,
        ),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
