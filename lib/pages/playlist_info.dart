import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/artwork_data_builder.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';
import 'package:tunes/utils/media_query.dart';
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
                title: ArtworkDataBuilder(
                  id: playlist.id,
                  artworkType: ArtworkType.PLAYLIST,
                  builder: (image, palette) {
                    final fgColor = calculateFgColor(palette);

                    return Text(
                      playlist.name,
                      style: TextStyle(
                        color: fgColor,
                      ),
                    );
                  },
                ),
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
                  child: SongArtwork(
                    id: playlist.id,
                    type: ArtworkType.PLAYLIST,
                    size: (context.screenHeight * 0.3).toInt(),
                    height: context.screenHeight * 0.3,
                    width: context.screenHeight * 0.3,
                    borderRadius: BorderRadius.circular(5.0),
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
                            .read(nowPlayingControllerProvider.notifier)
                            .queue(
                          [song],
                          startWith: song,
                        );
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
                                songs: [song],
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
