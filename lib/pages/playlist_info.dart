import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/views/songs_list_view.dart';

class PlaylistInfoPage extends ConsumerWidget {
  const PlaylistInfoPage({
    super.key,
    required this.playlist,
  });

  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncPlaylistSongs = ref.watch(playlistSongsProvider(playlist));
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: context.screenHeight * 0.3,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlist.playlist),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.colorScheme.background,
                      context.colorScheme.background.withOpacity(.0),
                    ],
                  ),
                ),
                child: QueryArtworkWidget(
                  controller: audioQuery,
                  id: playlist.id,
                  type: ArtworkType.PLAYLIST,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                  size: (context.screenHeight * 0.3).toInt(),
                  artworkHeight: context.screenHeight * 0.3,
                  artworkWidth: context.screenHeight * 0.3,
                  artworkBorder: BorderRadius.circular(5.0),
                  nullArtworkWidget: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(5.0),
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
              ),
            ),
          ),
          SliverFillRemaining(
            child: AsyncSongsListView(
              asyncSongs: asyncPlaylistSongs,
            ),
          ),
        ],
      ),
    );
  }
}
