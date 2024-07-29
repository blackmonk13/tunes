import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/pages/genre_info.dart';

class AsyncGenreListView extends StatelessWidget {
  final AsyncValue<List<GenreModel>> asyncGenre;
  const AsyncGenreListView({
    super.key,
    required this.asyncGenre,
    this.searchQuery = "",
  });
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return asyncGenre.when(
      data: (data) {
        List<GenreModel> genres = data;

        if (searchQuery.isNotEmpty) {
          genres = data.where((el) {
            for (final e in [el.genre]) {
              if (e.toLowerCase().contains(searchQuery.toLowerCase())) {
                return true;
              }
            }
            return false;
          }).toList();
        }

        if (genres.isEmpty) {
          return Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "No genres",
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
          itemCount: genres.length,
          itemBuilder: (BuildContext context, int index) {
            final currentGenre = genres[index];

            return GenreListTile(
              genre: currentGenre,
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

class GenresListView extends ConsumerWidget {
  const GenresListView({
    super.key,
    this.searchQuery = "",
  });
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGenre = ref.watch(genresControllerProvider);

    return AsyncGenreListView(
      asyncGenre: asyncGenre,
      searchQuery: searchQuery,
    );
  }
}

class GenreListTile extends ConsumerWidget {
  const GenreListTile({
    super.key,
    required this.genre,
  });

  final GenreModel genre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    return ListTile(
      onTap: () {
        // Navigate to song info page
        Navigator.of(context).push(
          routeTo(
            page: GenreInfoPage(
              genre: genre,
            ),
          ),
        );
      },
      title: Text(
        genre.genre,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        (() {
          final songCount = genre.numOfSongs;

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
        id: genre.id,
        type: ArtworkType.GENRE,
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
