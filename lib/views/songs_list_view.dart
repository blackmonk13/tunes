import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/pages/song_info.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class AsyncSongsListView extends StatelessWidget {
  final AsyncValue<List<SongModel>> asyncSongs;
  final ScrollController? scrollController;
  const AsyncSongsListView({
    super.key,
    required this.asyncSongs,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return asyncSongs.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text("No Songs");
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final currentSong = data[index];

            return SongListTile(song: currentSong);
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

class SongsListView extends ConsumerWidget {
  const SongsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSongs = ref.watch(songsControllerProvider);

    return AsyncSongsListView(
      asyncSongs: asyncSongs,
    );
  }
}

class SongListTile extends ConsumerWidget {
  const SongListTile({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final audioQuery = ref.watch(onAudioQueryProvider);
    return ListTile(
      onTap: () async {
        // Play song
        final audioSource = AudioSource.uri(
          Uri.parse(song.data),
          tag: MediaItem(
            id: song.id.toString(),
            title: song.title,
            artist: song.artist,
            album: song.album,
            genre: song.genre,
          ),
        );
        await player.setAudioSource(audioSource);
        if (player.playing) {
          return;
        }
        player.play();
        // Navigate to song info page
        // Navigator.of(context).push(
        //   routeTo(
        //     page: SongInfo(
        //       songInfo: song,
        //     ),
        //   ),
        // );
      },
      title: Text(
        song.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        song.artist ?? "No Artist",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      // This Widget will query/load image.
      // You can use/create your own widget/method using [queryArtwork].
      leading: QueryArtworkWidget(
        controller: audioQuery,
        id: song.id,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(20.0),
        nullArtworkWidget: GlassContainer(
          height: 50,
          width: 50,
          borderColor: context.colorScheme.outline.withOpacity(.3),
          borderRadius: BorderRadius.circular(20.0),
          gradient: RadialGradient(
            colors: [
              context.colorScheme.primaryContainer.withOpacity(0.40),
              context.colorScheme.primaryContainer.withOpacity(0.10)
            ],
          ),
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
