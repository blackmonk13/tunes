import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/pages/artist_songs.dart';
import 'package:tunes/providers/main.dart';

class ArtistsView extends ConsumerWidget {
  const ArtistsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(songsProvider);
    final asyncArtists = ref.watch(artistsProvider);

    return asyncArtists.when(
      data: (artists) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(artistsProvider);
          },
          child: ListView.separated(
            itemBuilder: (context, index) {
              final artist = artists.elementAt(index);
              return ListTile(
                dense: true,
                onTap: () {
                  // context.go("/artists/$artistName");
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ArtistSongs(
                        artist: artist,
                      );
                    },
                  );
                },
                title: Text(artist.name ?? "Unknown"),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: artists.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return const Center(child: Text("Unexpected Error Occurred"));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );

    
  }
}
