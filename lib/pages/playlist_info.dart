import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/views/playlists_list_view.dart';
import 'package:tunes/views/songs_list_view.dart';

class PlaylistInfoPage extends ConsumerWidget {
  const PlaylistInfoPage({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: WithPlayer(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: context.screenHeight * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.colorScheme.surface,
                        context.colorScheme.surface.withOpacity(.0),
                      ],
                    ),
                  ),
                  child: PlaylistThumbnail(
                    playlist: playlist,
                    size: context.screenHeight * 0.3,
                    hasBorder: false,
                    mini: false,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: ListView.builder(
                itemCount: playlist.songs.length,
                itemBuilder: (BuildContext context, int index) {
                  final song = playlist.songs.elementAt(index);
                  return Dismissible(
                    key: Key(song.filePath),
                    onDismissed: (direction) async {
                      await ref
                          .read(playlistsControllerProvider.notifier)
                          .removeFromPlaylist(playlist, song);
                    },
                    child: SongListTile(
                      song: song,
                      onTap: (song) async {
                        return ref
                            .read(playbackControllerProvider.notifier)
                            .addAndPlay(song);
                      },
                      trailing: IconButton(
                        icon: const Icon(FluentIcons.more_vertical_24_regular),
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: context.colorScheme.outlineVariant,
                            showDragHandle: true,
                            constraints: BoxConstraints(
                              minWidth: context.shortestSide,
                              maxWidth: context.shortestSide,
                              minHeight: 350.0,
                              maxHeight: 350.0,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            builder: (context) {
                              return SongTileOptions(
                                song: song,
                                indices:
                                    playlist.songs.map((e) => e.id).toList(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
