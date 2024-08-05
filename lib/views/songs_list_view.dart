import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/options_view.dart';
import 'package:tunes/pages/song_info.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/components/song_list_tile.dart';

import 'package:tunes/components/sort_order_view.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/views/playlists_list_view.dart';

class SongsList extends ConsumerWidget {
  final SongQueryType queryType;
  final String? query;
  final String? searchQuery;
  final bool withHeader;
  final ScrollController? scrollController;
  final void Function(Song song)? onTap;
  final void Function(Song song)? onLongPress;
  final void Function(Song song)? onDoubleTap;
  final Widget Function(Song song)? trailing;
  final void Function(
    Song song,
    List<Song> songs,
    DismissDirection direction,
  )? onDismiss;
  const SongsList({
    super.key,
    this.queryType = SongQueryType.all,
    this.query,
    this.searchQuery,
    this.withHeader = true,
    this.scrollController,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.trailing,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsSortOrder = ref.watch(songsSortOrderProvider(queryType));

    if (!withHeader) {
      return SongsListView(
        query: query,
        searchQuery: searchQuery,
        queryType: queryType,
        scrollController: scrollController,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        trailing: trailing,
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // PlayAllBtn(
              //   songs: songs,
              // ),
              TextButton.icon(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: context.colorScheme.outlineVariant,
                    showDragHandle: true,
                    // constraints: BoxConstraints(
                    //   minWidth: context.shortestSide,
                    //   maxWidth: context.shortestSide,
                    //   minHeight: 350.0,
                    //   maxHeight: 350.0,
                    // ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return SortOrderView(
                        queryType: queryType,
                      );
                    },
                  );
                },
                icon: Icon(
                  (() {
                    switch (songsSortOrder.orderType) {
                      case Sort.asc:
                        return FluentIcons.text_sort_ascending_24_regular;
                      case Sort.desc:
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
        const Divider(
          height: 1.5,
        ),
        Expanded(
          child: SongsListView(
            query: query,
            searchQuery: searchQuery,
            queryType: queryType,
            scrollController: scrollController,
            onTap: onTap,
            onLongPress: onLongPress,
            onDoubleTap: onDoubleTap,
            trailing: trailing,
          ),
        ),
      ],
    );
  }
}

class SongsListView extends ConsumerWidget {
  const SongsListView({
    super.key,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.scrollController,
    this.trailing,
    this.queryType = SongQueryType.all,
    this.query,
    this.searchQuery,
  });

  final ScrollController? scrollController;
  final SongQueryType queryType;
  final String? query;
  final String? searchQuery;
  final void Function(Song song)? onTap;
  final void Function(Song song)? onLongPress;
  final void Function(Song song)? onDoubleTap;
  final Widget Function(Song song)? trailing;

  static const pageSize = 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsCountAsyncValue = ref.watch(songsCountProvider(
      query: query,
      searchQuery: searchQuery,
      queryType: queryType,
    ));

    return songsCountAsyncValue.when(
      data: (itemCount) {
        if (itemCount == 0) {
          return Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "No songs",
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
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            final page = index ~/ pageSize;
            final offset = page * pageSize;
            final indexInPage = index % pageSize;
            final songsQueryAsyncValue = ref.watch(songsQueryProvider(
              pageSize,
              offset,
              query: query,
              searchQuery: searchQuery,
              queryType: queryType,
            ));
            return songsQueryAsyncValue.when(
              data: (data) {
                final song = data.elementAt(indexInPage);
                return SongListTile(
                  song: song,
                  onTap: onTap,
                  onDoubleTap: onDoubleTap,
                  onLongPress: onLongPress,
                  trailing: trailing?.call(song),
                );
              },
              error: (error, stackTrace) {
                return ListTile(
                  leading: const Icon(FluentIcons.warning_24_regular),
                  title: const Text("Error"),
                  subtitle: Text(error.toString()),
                );
              },
              loading: () {
                return const SongListTileLoading();
              },
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
        return const CircularProgressIndicator();
      },
    );
  }
}

class SongsView extends ConsumerWidget {
  final SongQueryType queryType;
  final String? query;
  final ScrollController? scrollController;
  final void Function(
    Song song,
    List<Song> songs,
    DismissDirection direction,
  )? onDismiss;
  final String searchQuery;
  const SongsView({
    super.key,
    this.queryType = SongQueryType.all,
    this.query,
    this.scrollController,
    this.onDismiss,
    this.searchQuery = "",
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SongsList(
      query: query,
      queryType: queryType,
      scrollController: scrollController,
      searchQuery: searchQuery,
      onTap: (song) async {
        return ref.read(nowPlayingControllerProvider.notifier).queue(
          [song],
          startWith: song,
        );
      },
      trailing: (song) {
        return IconButton(
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
              builder: (context) {
                return SongTileOptions(
                  song: song,
                  songs: [song],
                );
              },
            );
          },
        );
      },
    );
  }
}

class SongTileOptions extends ConsumerWidget {
  const SongTileOptions({
    super.key,
    required this.song,
    required this.songs,
    this.queue = true,
  });
  final Song song;
  final List<Song> songs;
  final bool queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    return Padding(
      padding: const EdgeInsets.only(
        // top: 16.0,
        left: 8.0,
      ),
      child: Column(
        children: <Widget>[
          if (queue) ...[
            OptionsTile(
              trailing: false,
              onTap: () async {
                final sequence = player.sequence;

                if (sequence == null) {
                  return ref.read(nowPlayingControllerProvider.notifier).queue(
                        songs,
                        startWith: song,
                      );
                }
                if (sequence.isNotEmpty) {
                  return ref.read(nowPlayingControllerProvider.notifier).queue(
                    [
                      song,
                    ],
                  );
                }
              },
              leading: FluentIcons.reading_list_add_24_regular,
              title: "Queue",
            ),
            OptionsTile(
              trailing: false,
              onTap: () async {
                await ref.read(nowPlayingControllerProvider.notifier).queue(
                      songs,
                      startWith: song,
                    );
              },
              leading: FluentIcons.receipt_play_24_regular,
              title: "Queue All",
            ),
            OptionsTile(
              trailing: false,
              onTap: () async {
                await ref.read(nowPlayingControllerProvider.notifier).playAll(
                      songs,
                      startWith: song,
                    );
              },
              leading: FluentIcons.arrow_shuffle_24_regular,
              title: "Shuffle All",
            ),
          ],
          OptionsTile(
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                showDragHandle: true,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  side: BorderSide(
                    color: context.colorScheme.outline.withOpacity(.3),
                  ),
                ),
                builder: (context) {
                  return AddToPlaylistView(
                    song: song,
                  );
                },
              );
            },
            leading: FluentIcons.receipt_add_24_regular,
            title: "Add to playlist",
          ),
          OptionsTile(
            onTap: () {
              // Navigate to song info page
              Navigator.of(context).push(
                routeTo(
                  page: SongInfo(
                    song: song,
                  ),
                ),
              );
            },
            leading: FluentIcons.info_24_regular,
            title: "Song Info",
          ),
        ],
      ),
    );
  }
}

class PlayAllBtn extends ConsumerWidget {
  final List<SongModel> songs;
  const PlayAllBtn({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingController = ref.watch(nowPlayingControllerProvider);
    return TextButton.icon(
      onPressed: () async {
        // await ref.read(nowPlayingControllerProvider.notifier).playAll(songs);
      },
      icon: SizedBox.square(
        dimension: 32.0,
        child: nowPlayingController.when(
          data: (data) {
            return _icon();
          },
          error: (error, stackTrace) {
            return _icon();
          },
          loading: () {
            return Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: _icon(),
                ),
              ],
            );
          },
        ),
      ),
      label: Text(
        "Play All",
        style: context.textTheme.labelSmall,
      ),
    );
  }

  Widget _icon() {
    return Builder(builder: (context) {
      return Icon(
        FluentIcons.play_circle_28_filled,
        color: context.colorScheme.primary,
      );
    });
  }
}

class AddToPlaylistView extends ConsumerWidget {
  const AddToPlaylistView({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onAddToPlaylist(Playlist value) async {
      final added =
          await ref.read(playlistsControllerProvider.notifier).addToPlaylist(
                value,
                song,
              );
      if (added) {
        if (context.mounted) {
          context.showSnackBar(
            message: "${song.title} has been added to ${value.name}",
          );
          Navigator.of(context).maybePop();
        }
        return;
      }
      if (context.mounted) {
        context.showErrorSnackBar(
          message: "${song.title} could not be added to ${value.name}",
        );
        Navigator.of(context).maybePop();
      }
    }

    return Column(
      children: [
        const Divider(
          height: 2.0,
        ),
        Expanded(
          child: PlaylistsListView(
            onTap: onAddToPlaylist,
            onNew: onAddToPlaylist,
          ),
        ),
      ],
    );
  }
}
