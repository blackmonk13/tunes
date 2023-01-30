import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/tunes_view.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/providers/main.dart';

class AlbumSongs extends HookConsumerWidget {
  final Album album;
  const AlbumSongs({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumSongs = ref.watch(albumSongsProvider(album.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: context.screenHeight * .3,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.2,
              title: Text(
                album.name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              background: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: _albumArtwork(albumSongs),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: .3,
                        sigmaY: .3,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.colorScheme.surface.withOpacity(.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TunesView(
              restorationId: "album_songs",
              asyncSongs: albumSongs,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }

  Widget _albumArtwork(AsyncValue<List<Audio>> asyncSongs) {
    final albumSongs = asyncSongs.valueOrNull;
    if (albumSongs == null) return const SizedBox.shrink();
    if (albumSongs.isEmpty) return const SizedBox.shrink();
    final songsWithCovers = albumSongs
        .where((element) => element.metas.extra?['artWork'] != null)
        .toList();
    if (songsWithCovers.isEmpty) return const SizedBox.shrink();
    final firstImage =
        songsWithCovers.first.metas.extra?['artWork'] as Uint8List?;
    if (firstImage == null) return const SizedBox.shrink();

    return Image.memory(
      firstImage,
      fit: BoxFit.cover,
    );
  }
}
