import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/smart_playlists.dart';
import 'package:tunes/views/songs_list_view.dart';

/// The songs of a [SmartPlaylistKind], in the order the playlist defines.
class SmartPlaylistPage extends ConsumerWidget {
  const SmartPlaylistPage({
    super.key,
    required this.kind,
  });

  final SmartPlaylistKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSongs = ref.watch(smartPlaylistSongsProvider(kind));

    return Scaffold(
      appBar: AppBar(title: Text(kind.title)),
      body: WithPlayer(
        child: asyncSongs.when(
          data: (songs) {
            if (songs.isEmpty) {
              return Center(
                child: Text(
                  "Nothing played yet",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                return SongListTile(
                  song: song,
                  onTap: (song) async {
                    await ref
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
                        builder: (context) => SongTileOptions(song: song),
                      );
                    },
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return AsyncErrorView(error: error, stackTrace: stackTrace);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
