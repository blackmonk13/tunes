import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/artwork_data_builder.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/views/songs_list_view.dart';

class GenreInfoPage extends ConsumerWidget {
  const GenreInfoPage({
    super.key,
    required this.genre,
  });

  final GenreModel genre;

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
                  id: genre.id,
                  artworkType: ArtworkType.GENRE,
                  builder: (image, palette) {
                    final fgColor = calculateFgColor(palette);

                    return Text(
                      genre.genre,
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
                    id: genre.id,
                    type: ArtworkType.GENRE,
                    size: (context.screenHeight * 0.3).toInt(),
                    height: context.screenHeight * 0.3,
                    width: context.screenHeight * 0.3,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: SongsView(
                queryType: SongQueryType.genre,
                query: genre.genre,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
