import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class AsyncAlbumsListView extends StatelessWidget {
  final AsyncValue<List<AlbumModel>> asyncAlbums;
  final ScrollController? scrollController;
  const AsyncAlbumsListView({
    super.key,
    required this.asyncAlbums,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return asyncAlbums.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text("No Albums");
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final currentAlbum = data[index];

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
        return const Center(
          child: CircularProgressIndicator(),
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
    final audioQuery = ref.watch(onAudioQueryProvider);

    return ListTile(
      onTap: () {
        // Navigate to song info page
        // Navigator.of(context).push(
        //   routeTo(
        //     page: SongInfo(
        //       songInfo: currentSong,
        //     ),
        //   ),
        // );
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
      // This Widget will query/load image.
      // You can use/create your own widget/method using [queryArtwork].
      leading: QueryArtworkWidget(
        controller: audioQuery,
        id: album.id,
        type: ArtworkType.ALBUM,
        artworkBorder: BorderRadius.circular(20.0),
        nullArtworkWidget: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: 50,
          height: 50,
          child: Icon(
            FluentIcons.music_note_2_24_regular,
            color: context.colorScheme.onPrimaryContainer,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}

class AlbumsListView extends ConsumerWidget {
  const AlbumsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAlbums = ref.watch(albumsControllerProvider);

    return AsyncAlbumsListView(asyncAlbums: asyncAlbums);
  }
}
