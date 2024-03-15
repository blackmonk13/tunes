import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/player/music_controls.dart';
import 'package:tunes/components/songs/list_view/song_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class MusicPlayer extends HookConsumerWidget {
  const MusicPlayer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    ref.watch(playlistControllerProvider);
    ref.watch(playerStateProvider);
    final player = ref.watch(audioPlayerProvider);

    final asyncPlayerSequence = ref.watch(playlistSequenceProvider);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: CustomScrollView(
            controller: ModalScrollController.of(context),
            slivers: <Widget>[
              material.SliverAppBar(
                primary: false,
                pinned: true,
                automaticallyImplyLeading: false,
                collapsedHeight: 120,
                expandedHeight: context.screenHeight * .5,
                backgroundColor: FluentTheme.of(context).acrylicBackgroundColor,
                flexibleSpace: const material.FlexibleSpaceBar(
                  collapseMode: material.CollapseMode.pin,
                  expandedTitleScale: 1,
                  titlePadding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  title: Row(
                    children: [
                      MusicTextInfo(),
                    ],
                  ),
                ),
              ),
              asyncPlayerSequence.when(
                data: (data) {
                  if (data == null) {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                  return SliverPadding(
                    padding:
                        EdgeInsets.only(bottom: context.screenHeight * .13),
                    sliver: SliverList.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final mediaItem =
                            data.elementAt(index).tag as MediaItem;
                        final song = mediaItem.extras!['song'];
                        return SongTile(
                          selected: player.currentIndex == index,
                          tuneSong: song,
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return SliverFillRemaining(
                    child: AsyncErrorView(
                      error: error,
                      stackTrace: stackTrace,
                    ),
                  );
                },
                loading: () {
                  return const SliverFillRemaining(
                    child: ProgressRing(),
                  );
                },
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 0,
          child: MusicControls(
            mini: false,
          ),
        ),
      ],
    );
  }
}
