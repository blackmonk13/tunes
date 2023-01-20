import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/extensions.dart';

class SongsView extends ConsumerWidget {
  const SongsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(songStreamProvider);
    final songList = ref.watch(songsProvider);

    return Column(
      children: [
        const SongsViewHeader(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(songsListProvider);
            },
            child: ListView.separated(
              restorationId: "songsview",
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
                  tune: songList[index],
                );
              },
            ),
          ),
        ),
        SongsViewFooter(),
      ],
    );
  }
}

class SongsViewFooter extends ConsumerWidget {
  const SongsViewFooter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiSelect = ref.watch(multiSelectSongsProvider);
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const HeroIcon(
              HeroIcons.queueList,
            ),
            label: const Text("Add to Playlist"),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const HeroIcon(
              HeroIcons.next,
            ),
            label: const Text("Play Next"),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const HeroIcon(
              HeroIcons.trash,
            ),
            label: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class SongsViewHeader extends ConsumerStatefulWidget {
  const SongsViewHeader({super.key});

  @override
  ConsumerState<SongsViewHeader> createState() => _SongsViewHeaderState();
}

class _SongsViewHeaderState extends ConsumerState<SongsViewHeader> {
  @override
  Widget build(BuildContext context) {
    final songList = ref.watch(songsProvider);
    final multiSelect = ref.watch(multiSelectSongsProvider);
    final selectedSongs = ref.watch(selectedSongsProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colorScheme.background, Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: multiSelect
            ? selectionWidgets
            : [
                TextButton.icon(
                  onPressed: () {
                    final addSongs = songList
                        .map((e) => AudioSource.file(e.filePath))
                        .toList();
                    ref.read(playlistItemsProvider.notifier).addAll(addSongs);
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
                IconButton(
                  onPressed: () {},
                  icon: const HeroIcon(
                    HeroIcons.adjustmentsVertical,
                  ),
                ),
              ],
      ),
    );
  }

  List<Widget> get selectionWidgets {
    final songList = ref.watch(songsProvider);
    final multiSelect = ref.watch(multiSelectSongsProvider);
    final selectedSongs = ref.watch(selectedSongsProvider);
    final selectedAll = songList.length == selectedSongs.length;
    return [
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
                text:
                    [selectedAll ? "De" : "", "select All"].join().capitalize(),
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
                      color:
                          context.textTheme.labelSmall?.color?.withOpacity(.5)),
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
    ];
  }
}
