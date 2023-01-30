import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/floating_modal.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/pages/album_songs.dart';
import 'package:tunes/providers/main.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbums = ref.watch(albumsProvider);
    return asyncAlbums.when(
      data: (albums) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final album = albums.elementAt(index);
            return AlbumTile(album: album);
          },
          separatorBuilder: (context, index) {
            final indent = context.screenWidth;
            return Divider(
              indent: indent,
              endIndent: indent,
              color: context.colorScheme.outline.withOpacity(.49),
            );
          },
          itemCount: albums.length,
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

class AlbumTile extends StatelessWidget {
  const AlbumTile({
    super.key,
    required this.album,
  });

  final Album album;

  @override
  Widget build(BuildContext context) {
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
      onLongPress: () {
        showFloatingModalBottomSheet(
          context: context,
          builder: (context) {
            return AspectRatio(
              aspectRatio: 4/3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: () {
                        
                      },
                      leading: const HeroIcon(HeroIcons.pencilSquare),
                      title: const Text("Rename"),
                    ),
                    ListTile(
                      onTap: () {
                        
                      },
                      leading: const HeroIcon(HeroIcons.trash),
                      title: const Text("Delete"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      title: Text(album.name ?? "Unknown"),
      trailing: const Icon(
        Icons.chevron_right_rounded,
      ),
    );
  }
}
