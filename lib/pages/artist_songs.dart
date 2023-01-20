import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';

class ArtistSongs extends ConsumerWidget {
  final String? artistName;
  const ArtistSongs({
    super.key,
    required this.artistName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(artistsProvider);
    final artistSongs = artists[artistName];
    final playlist = ref.watch(playlistProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(artistName ?? "Something is wrong"),
      ),
      body: artistSongs == null
          ? const Text("Nothing to see here.")
          : ListView.separated(
              restorationId: "artist_songs",
              itemCount: artistSongs.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return SongTile(
                  tune: artistSongs[index],
                );
              },
            ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }
}
