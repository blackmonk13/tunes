import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class PlaylistsListView extends ConsumerWidget {
  const PlaylistsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncPlaylists = ref.watch(playlistsControllerProvider);

    return asyncPlaylists.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text("No Playlists");
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final currentPlaylist = data[index];

            return PlaylistListTile(
              playlist: currentPlaylist,
            );
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

class PlaylistListTile extends ConsumerWidget {
  const PlaylistListTile({
    super.key,
    required this.playlist,
  });

  final PlaylistModel playlist;

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
        playlist.playlist,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        (() {
          final songCount = playlist.numOfSongs;

          if (songCount == 1) {
            return "$songCount song";
          }
          return "$songCount songs";
        })(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      // This Widget will query/load image.
      // You can use/create your own widget/method using [queryArtwork].
      leading: QueryArtworkWidget(
        controller: audioQuery,
        id: playlist.id,
        type: ArtworkType.PLAYLIST,
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
