import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/views/songs_list_view.dart';

class AlbumInfoPage extends HookConsumerWidget {
  final Album album;
  const AlbumInfoPage({
    super.key,
    required this.album,
  });

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
                title: Text(album.title),
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
                  child: Thumbnail(
                    thumbnail:
                        album.artworkPath ?? album.songs.firstOrNull?.thumbnailPath,
                    height: context.screenHeight * 0.3,
                    width: context.screenHeight * 0.3,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: SongsView(
                queryType: SongQueryType.album,
                query: album.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
