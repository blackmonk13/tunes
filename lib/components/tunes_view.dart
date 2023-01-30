import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/floating_modal.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/extensions.dart';

class TunesView extends ConsumerWidget {
  const TunesView({
    super.key,
    required this.restorationId,
    required this.asyncSongs,
    this.controller,
  });
  final String restorationId;
  final AsyncValue<List<Audio>> asyncSongs;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _TunesViewHeader(
          asyncSongs: asyncSongs,
        ),
        Expanded(
          child: asyncSongs.when(
            data: (songList) {
              return ListView.separated(
                restorationId: restorationId,
                itemCount: songList.length,
                separatorBuilder: (BuildContext context, int index) {
                  final indent = context.screenWidth * .18;
                  return Divider(
                    indent: indent,
                    endIndent: indent,
                    color: context.colorScheme.outline.withOpacity(.5),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return SongTile(
                    audio: songList[index],
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return const Text("Error");
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        const _TunesViewFooter()
      ],
    );
  }
}

class _TunesViewHeader extends ConsumerWidget {
  const _TunesViewHeader({
    super.key,
    required this.asyncSongs,
  });
  final AsyncValue<List<Audio>> asyncSongs;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiSelect = ref.watch(multiSelectSongsProvider);
    ref.watch(selectedSongsProvider);

    final songList = asyncSongs.valueOrNull;

    if (songList == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.background,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: multiSelect
          ? _selectionWidgets()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    ref.read(nowPlayingPlaylistProvider).addAll(songList);
                  },
                  icon: const HeroIcon(
                    HeroIcons.playCircle,
                    style: HeroIconStyle.solid,
                  ),
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Play All",
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "\t${songList.length} songs",
                          style: context.textTheme.labelSmall?.copyWith(
                              color: context.textTheme.labelSmall?.color
                                  ?.withOpacity(.5)),
                        ),
                      ],
                    ),
                  ),
                ),
                _sortBtn(),
              ],
            ),
    );
  }

  Widget _sortBtn() {
    return Consumer(
      builder: (context, ref, child) {
        final sortMode = ref.watch(songsSortModeProvider);
        final sortKey = ref.watch(songsSortKeyProvider);

        return GestureDetector(
          onLongPress: () {
            switch (sortMode) {
              case OrderingMode.asc:
                ref.read(songsSortModeProvider.notifier).state =
                    OrderingMode.desc;
                break;
              default:
                ref.read(songsSortModeProvider.notifier).state =
                    OrderingMode.asc;
                break;
            }
          },
          child: IconButton(
            onPressed: () {
              showFloatingModalBottomSheet(
                context: context,
                builder: (context) {
                  return _sortModal();
                },
              );
            },
            icon: HeroIcon(
              sortMode == OrderingMode.asc
                  ? HeroIcons.barsArrowDown
                  : HeroIcons.barsArrowUp,
            ),
          ),
        );
      },
    );
  }

  Widget _sortModal() {
    return Consumer(
      builder: (context, ref, child) {
        final sortKey = ref.watch(songsSortKeyProvider);
        return AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Sort By',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontSize:
                              context.textTheme.headlineSmall!.fontSize! * .85,
                        ),
                      ),
                    ],
                  ),
                  ...['title', 'artist', 'album', 'date'].map(
                    (e) => RadioListTile<String>(
                      value: e,
                      groupValue: sortKey,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        ref.read(songsSortKeyProvider.notifier).state = e;
                      },
                      title: Text(e.capitalize()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _selectionWidgets() {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(multiSelectSongsProvider);
        final selectedSongs = ref.watch(selectedSongsProvider);

        final songList = asyncSongs.valueOrNull;

        if (songList == null) return const SizedBox.shrink();

        final selectedAll = songList.length == selectedSongs.length;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                if (selectedAll) {
                  ref.read(selectedSongsProvider.notifier).clear();
                  return;
                }
                ref.read(selectedSongsProvider.notifier).addAll(songList);
              },
              icon: const HeroIcon(
                HeroIcons.listBullet,
              ),
              label: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: [selectedAll ? "De" : "", "select All"]
                          .join()
                          .capitalize(),
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (selectedSongs.isNotEmpty)
                      TextSpan(
                        text: [
                          "\t${selectedSongs.length}",
                          ["song", selectedSongs.length <= 1 ? "" : "s"].join(),
                          "selected",
                        ].join(" "),
                        style: context.textTheme.labelSmall?.copyWith(
                            color: context.textTheme.labelSmall?.color
                                ?.withOpacity(.5)),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ref.read(multiSelectSongsProvider.notifier).state = false;
                ref.read(selectedSongsProvider.notifier).clear();
              },
              icon: const HeroIcon(
                HeroIcons.xMark,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TunesViewFooter extends ConsumerWidget {
  const _TunesViewFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(multiSelectSongsProvider);
    final selectedSongs = ref.watch(selectedSongsProvider);

    if (selectedSongs.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colorScheme.background, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBtn(
              onPressed: () {},
              icon: HeroIcons.queueList,
              label: "Add to Playlist",
            ),
            _buildBtn(
              onPressed: () {
                ref.read(nowPlayingPlaylistProvider).addAll(selectedSongs);
              },
              icon: HeroIcons.next,
              label: "Play Next",
            ),
            _buildBtn(
              onPressed: () async {
                final deleted = await ref
                    .read(tunesRepositoryProvider)
                    .deleteTunes(selectedSongs.map((e) => e.path).toList());
                if (!context.mounted) return;
                if (deleted < 1) {
                  context.showErrorSnackBar(
                    message: 'Failed to delete ${selectedSongs.length} files.',
                  );
                } else {
                  context.showSnackBar(
                    message: 'Deleted ${selectedSongs.length} files.',
                  );
                }
                ref.read(selectedSongsProvider.notifier).clear();
              },
              icon: HeroIcons.trash,
              label: "Delete",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn({
    required void Function()? onPressed,
    required HeroIcons icon,
    required String label,
  }) {
    return Builder(builder: (context) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: HeroIcon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: context.textTheme.bodySmall,
        ),
      );
    });
  }
}
