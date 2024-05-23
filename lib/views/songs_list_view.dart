import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/components/song_list_tile.dart';

import 'package:tunes/components/sort_order_view.dart';

class AsyncSongsListView extends ConsumerWidget {
  final AsyncValue<List<SongModel>> asyncSongs;
  final ScrollController? scrollController;
  const AsyncSongsListView({
    super.key,
    required this.asyncSongs,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final songsSortOrder = ref.watch(songsSortOrderProvider('all_songs'));
    return asyncSongs.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text("No Songs"),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await ref
                          .read(nowPlayingControllerProvider.notifier)
                          .playAll(data);
                    },
                    icon: Icon(
                      FluentIcons.play_circle_28_filled,
                      color: context.colorScheme.primary,
                    ),
                    label: Text(
                      "Play All",
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        backgroundColor: Colors.grey[900],
                        builder: (BuildContext context) {
                          return const SortOrderView(viewKey: 'all_songs');
                        },
                      );
                    },
                    icon: Icon(
                      (() {
                        switch (songsSortOrder.orderType) {
                          case OrderType.ASC_OR_SMALLER:
                            return FluentIcons.text_sort_ascending_24_regular;
                          case OrderType.DESC_OR_GREATER:
                            return FluentIcons.text_sort_descending_24_regular;

                          default:
                            return FluentIcons.text_sort_descending_24_regular;
                        }
                      })(),
                      size: 18.0,
                      color: context.iconTheme.color,
                    ),
                    label: Text(
                      "Sort",
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentSong = data[index];

                  return SongListTile(
                    song: currentSong,
                    onTap: (song) async {
                      final sequence = player.sequence;

                      if (sequence == null) {
                        return ref
                            .read(nowPlayingControllerProvider.notifier)
                            .queue(
                              data,
                              startWith: song,
                            );
                      }
                      if (sequence.isNotEmpty) {
                        return ref
                            .read(nowPlayingControllerProvider.notifier)
                            .queue([song]);
                      }
                      await ref
                          .read(nowPlayingControllerProvider.notifier)
                          .queue(
                            data,
                            startWith: song,
                          );
                      // Navigate to song info page
                      // Navigator.of(context).push(
                      //   routeTo(
                      //     page: SongInfo(
                      //       songInfo: song,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ),
          ],
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
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            strokeCap: StrokeCap.round,
          ),
        );
      },
    );
  }
}

class AsyncSongsSliverListView extends StatelessWidget {
  final AsyncValue<List<SongModel>> asyncSongs;
  const AsyncSongsSliverListView({
    super.key,
    required this.asyncSongs,
  });

  @override
  Widget build(BuildContext context) {
    return asyncSongs.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text("No Songs");
        }

        return SliverList.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final currentSong = data[index];

            return SongListTile(song: currentSong);
          },
        );
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: AsyncErrorView(
            error: error,
            stackTrace: stackTrace,
          ),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
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
