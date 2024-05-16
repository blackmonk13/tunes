import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class GenresListView extends ConsumerWidget {
  const GenresListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGenre = ref.watch(genresControllerProvider);

    return asyncGenre.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text("No Albums");
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final currentGenre = data[index];

            return GenreListTile(
              currentGenre: currentGenre,
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

class GenreListTile extends ConsumerWidget {
  const GenreListTile({
    super.key,
    required this.currentGenre,
  });

  final GenreModel currentGenre;

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
        currentGenre.genre,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        (() {
          final songCount = currentGenre.numOfSongs;

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
        id: currentGenre.id,
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
