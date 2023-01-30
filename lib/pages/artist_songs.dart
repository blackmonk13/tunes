import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/tunes_view.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/providers/main.dart';

class ArtistSongs extends ConsumerWidget {
  final Artist artist;
  const ArtistSongs({
    super.key,
    required this.artist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistSongs = ref.watch(artistSongsProvider(artist.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(artist.name ?? "Something is wrong"),
      ),
      body: TunesView(
        restorationId: 'artist_songs',
        asyncSongs: artistSongs,
      ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }

}
