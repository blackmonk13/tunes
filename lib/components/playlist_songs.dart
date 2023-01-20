import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/models/tune.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

final playlistSongsProvider = Provider<List<Tune>>(
  (ref) {
    ref.watch(playIdProvider);
    ref.watch(playpositionProvider);
    final songStream = ref.watch(songsProvider);
    final playlist = ref.watch(playlistProvider);

    if (player.audioSource != playlist) {
      return [];
    }

    if (playlist.children.isEmpty) {
      return [];
    }

    final playlistPas = playlist.children.map((e) {
      return e as UriAudioSource;
    }).toList();

    final playlistSongs = songStream.where((element) {
      return playlistPas
          .where((el) => el.uri.toFilePath() == element.filePath)
          .isNotEmpty;
    }).toList();
    playlistSongs.sort(
      (a, b) {
        return playlistPas.indexOf(a.audioSource).compareTo(
              playlistPas.indexOf(b.audioSource),
            );
      },
    );
    return playlistSongs;
  },
);

class PlaylistSongs extends ConsumerWidget {
  const PlaylistSongs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songList = ref.watch(playlistSongsProvider);
    final nowPlaying = ref.watch(nowPlayingProvider);

    return Material(
      child: CupertinoScaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Now Playing",
                    style: context.textTheme.headline6,
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(playlistItemsProvider.notifier).clear();
                    },
                    icon: Icon(
                      Icons.delete_outline,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 16,
              endIndent: 16,
              color: context.colorScheme.outline,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: songList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  final selected =
                      songList[index].filePath == nowPlaying?.filePath;
                  return SongTile(
                    tune: songList[index],
                    selected: selected,
                    onTap: () async {
                      // await player.setAudioSource(playlist);
                      // await player.seekToNext();
                      await player.seek(Duration.zero, index: index);
                      // player.play();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
