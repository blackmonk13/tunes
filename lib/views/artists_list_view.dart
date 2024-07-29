import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/pages/artist_info.dart';

class ArtistsListView extends ConsumerWidget {
  const ArtistsListView({
    super.key,
    this.searchQuery = "",
  });
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArtists = ref.watch(artistsControllerProvider);

    return asyncArtists.when(
      data: (data) {
        List<ArtistModel> artists = data;

        if (searchQuery.isNotEmpty) {
          artists = data.where((el) {
            for (final e in [el.artist]) {
              if (e.toLowerCase().contains(searchQuery.toLowerCase())) {
                return true;
              }
            }
            return false;
          }).toList();
        }

        if (artists.isEmpty) {
          return Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "No artists",
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
          itemCount: artists.length,
          itemBuilder: (BuildContext context, int index) {
            final currentArtist = artists[index];

            return ListTile(
              onTap: () {
                // Navigate to song info page
                Navigator.of(context).push(
                  routeTo(
                    page: ArtistInfoPage(
                      artist: currentArtist,
                    ),
                  ),
                );
              },
              title: Text(
                currentArtist.artist,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              subtitle: Text(
                (() {
                  final songCount = currentArtist.numberOfTracks;

                  if (songCount == null) {
                    return "";
                  }

                  if (songCount == 1) {
                    return "$songCount song";
                  }
                  return "$songCount songs";
                })(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              leading: SongArtwork(
                id: currentArtist.id,
                type: ArtworkType.ARTIST,
                borderRadius: BorderRadius.circular(20.0),
                width: 50,
                height: 50,
                size: 50,
                hasBorder: true,
              ),
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
