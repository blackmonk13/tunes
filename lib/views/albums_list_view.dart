import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/pages/album_info.dart';

class AsyncAlbumsListView extends StatelessWidget {
  final AsyncValue<List<AlbumModel>> asyncAlbums;
  final ScrollController? scrollController;
  final String searchQuery;
  const AsyncAlbumsListView({
    super.key,
    required this.asyncAlbums,
    this.scrollController,
    this.searchQuery = "",
  });

  @override
  Widget build(BuildContext context) {
    return asyncAlbums.when(
      data: (data) {
        List<AlbumModel> albums = data;

        if (searchQuery.isNotEmpty) {
          albums = data.where((el) {
            for (final e in [el.album, el.artist]) {
              if (e?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false) {
                return true;
              }
            }
            return false;
          }).toList();
        }
        if (albums.isEmpty) {
          return Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "No albums",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: albums.length,
          itemBuilder: (BuildContext context, int index) {
            final currentAlbum = albums[index];

            return AlbumListTile(album: currentAlbum);
          },
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const SongListTileLoading();
          },
        );
      },
    );
  }
}

class AlbumListTile extends ConsumerWidget {
  const AlbumListTile({
    super.key,
    required this.album,
  });

  final AlbumModel album;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(onAudioQueryProvider);

    return ListTile(
      onTap: () {
        // Navigate to song info page
        Navigator.of(context).push(
          routeTo(
            page: AlbumInfoPage(
              album: album,
            ),
          ),
        );
      },
      title: Text(
        album.album,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        album.artist ?? "No Artist",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: SongArtwork(
        id: album.id,
        type: ArtworkType.ALBUM,
        hasBorder: true,
        borderRadius: BorderRadius.circular(20.0),
        width: 50,
        height: 50,
        size: 50,
      ),
    );
  }
}

class AlbumsListView extends ConsumerWidget {
  const AlbumsListView({
    super.key,
    this.searchQuery = "",
  });
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbums = ref.watch(albumsControllerProvider);

    return AsyncAlbumsListView(
      asyncAlbums: asyncAlbums,
      searchQuery: searchQuery,
    );
  }
}
