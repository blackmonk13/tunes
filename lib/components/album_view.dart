import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/pages/album_songs.dart';
import 'package:tunes/providers/main.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbums = ref.watch(albumsProvider);
    return asyncAlbums.when(
      data: (albums) {
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(albumsProvider);
          },
          child: ListView.separated(
            itemBuilder: (context, index) {
              final album = albums.elementAt(index);
              return ListTile(
                dense: true,
                onTap: () {
                  // context.go("/artists/$artistName");
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AlbumSongs(
                        album: album,
                      );
                    },
                  );
                },
                title: Text(album.name ?? "Unknown"),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: albums.length,
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
