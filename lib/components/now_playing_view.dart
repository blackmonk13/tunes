import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/views/songs_list_view.dart';

class NowPlayingBtn extends StatelessWidget {
  const NowPlayingBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      onPressed: () async {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.outlineVariant,
          // constraints: BoxConstraints(
          //   minWidth: context.shortestSide,
          //   maxWidth: context.shortestSide,
          //   minHeight: context.longestSide * .6,
          //   maxHeight: context.longestSide * .6,
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            side: BorderSide(
              color: context.colorScheme.outline.withOpacity(.3),
            ),
          ),
          builder: (context) {
            return const NowPlayingView();
          },
        );
      },
      icon: const Icon(
        FluentIcons.reading_list_24_regular,
      ),
    );
  }
}

class NowPlayingView extends HookConsumerWidget {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackController = ref.watch(playbackControllerProvider);

    final scrollController = useScrollController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Now Playing",
                style: context.textTheme.headlineSmall,
              ),
              const Spacer(),
            ],
          ),
          const Divider(
            height: 1.2,
          ),
          Expanded(
            child: playbackController.when(
              skipLoadingOnReload: true,
              data: (data) {
                return SongsListView(
                  scrollController: scrollController,
                  indices: data,
                  onTap: (song) async {
                    await ref
                        .read(playbackControllerProvider.notifier)
                        .addAndPlay(song);
                  },
                  trailing: (song) {
                    return IconButton(
                      onPressed: () async {
                        await ref
                            .read(playbackControllerProvider.notifier)
                            .removeSongFromQueue(song);
                      },
                      icon: const Icon(
                        FluentIcons.dismiss_circle_24_filled,
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
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    strokeCap: StrokeCap.round,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
