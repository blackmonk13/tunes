import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/playlist_songs.dart';
import 'package:tunes/providers/main.dart';

class PlayListsView extends ConsumerWidget {
  const PlayListsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        _nowPlaylistTile(),
      ],
    );
  }

  Widget _nowPlaylistTile() {
    return Consumer(builder: (context, ref, child) {
      final playlist = ref.watch(nowPlayingPlaylistProvider);
      return ListTile(
        title: const Text("Now Playing"),
        subtitle: Text("${playlist.numberOfItems} songs"),
        trailing: const HeroIcon(HeroIcons.chevronRight),
        onTap: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => const PlaylistSongs(),
          );
        },
      );
    });
  }
}
