import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/providers/main.dart';

class AlbumSongs extends ConsumerWidget {
  final Album album;
  const AlbumSongs({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumSongs = ref.watch(albumSongsProvider(album.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name ?? "Something is wrong"),
      ),
      body: albumSongs.when(
        data: (data) {
          return ListView.separated(
            restorationId: "album_songs",
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              final tune = data.elementAt(index);
              return _songTile(tune);
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text("Error"));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }

  Widget _songTile(Tune tune) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncAudio = ref.watch(tuneAudioProvider(tune: tune));
        return asyncAudio.when(
          data: (data) {
            return SongTile(
              audio: data,
            );
          },
          error: (error, stackTrace) {
            // TODO:
            return ListTile(
              dense: true,
              leading: HeroIcon(
                HeroIcons.exclamationTriangle,
                color: context.colorScheme.error,
              ),
              title: Text(
                error.toString(),
              ),
            );
          },
          loading: () {
            return ListTile(
              dense: true,
              leading: const SizedBox.square(
                dimension: 24,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              title: Text(
                tune.title ?? tune.pathname,
              ),
            );
          },
        );
      },
    );
  }
}
