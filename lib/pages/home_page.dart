import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQuery = ref.watch(onAudioQueryProvider);
    final asyncSongs = ref.watch(songsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tunes"),
      ),
      body: asyncSongs.when(
        data: (data) {
          if (data.isEmpty) {
            return const Text("No Songs");
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final currentSong = data[index];
              
              return ListTile(
                onTap: () {
                  
                },
                title: Text(
                  currentSong.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                subtitle: Text(
                  currentSong.artist ?? "No Artist",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                // This Widget will query/load image.
                // You can use/create your own widget/method using [queryArtwork].
                leading: QueryArtworkWidget(
                  controller: audioQuery,
                  id: currentSong.id,
                  type: ArtworkType.AUDIO,
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
      ),
    );
  }
}


class SongInfo extends ConsumerWidget {
  final SongModel songInfo;
  const SongInfo({super.key, required this.songInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}