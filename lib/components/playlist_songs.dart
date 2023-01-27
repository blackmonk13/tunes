import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class PlaylistSongs extends ConsumerWidget {
  const PlaylistSongs({
    super.key,
    this.onClose,
  });
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songList = ref.watch(nowPlayingPlaylistProvider);
    ref.watch(nowPlayingProvider);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          // pinned: true,
          title: const Text("Now Playing"),
          actions: [
            IconButton(
              onPressed: onClose,
              icon: const HeroIcon(
                HeroIcons.xMark,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: Row(
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: context.textTheme.displaySmall?.color,
                  ),
                  onPressed: () {
                    ref
                        .read(nowPlayingPlaylistProvider.notifier)
                        .clearPlaylist();
                  },
                  icon: const HeroIcon(HeroIcons.trash),
                  label: const Text("Clear playlist"),
                )
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          child: ListView.separated(
            itemCount: songList.numberOfItems,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                indent: context.screenWidth * .1,
                endIndent: context.screenWidth * .1,
                color: context.colorScheme.outline,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final thisTune = songList.audios.elementAt(index);

              return player.builderCurrent(
                builder: (context, playing) {
                  final nowPlaying = playing.audio.audio;
                  final selected = thisTune.path == nowPlaying.path;
                  return SongTile(
                    audio: thisTune,
                    selected: selected,
                    onTap: () async {
                      player.stop();
                      player.playlistPlayAtIndex(index);
                      await player.seek(
                        Duration.zero,
                      );
                      // player.play();
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
