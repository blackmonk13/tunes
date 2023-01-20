import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';

class AlbumSongs extends ConsumerWidget {
  final String? albumName;
  const AlbumSongs({
    super.key,
    required this.albumName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    final albumSongs = albums[albumName];
    final playlist = ref.watch(playlistProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(albumName ?? "Something is wrong"),
      ),
      body: albumSongs == null
          ? const Text("Nothing to see here.")
          : ListView.separated(
            restorationId: "album_songs",
              itemCount: albumSongs.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                 
                return SongTile(tune: albumSongs[index]);
                
              },
            ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }
}
