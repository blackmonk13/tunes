import 'dart:math';
import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tunes/components/common/arc_menu.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/mini_progress.dart';
import 'package:tunes/components/player_btns.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

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
          backgroundColor: Colors.transparent,
          constraints: BoxConstraints(
            minWidth: context.shortestSide,
            maxWidth: context.shortestSide,
            minHeight: context.longestSide * .6,
            maxHeight: context.longestSide * .6,
          ),
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
    final player = ref.watch(audioPlayerProvider);
    final nowPlayingController = ref.watch(nowPlayingControllerProvider);

    final scrollController = useScrollController();

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface.withOpacity(0.5),
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outline.withOpacity(.4),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
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
                    const PreviousBtn(
                      alwaysShow: true,
                    ),
                    const SizedBox.square(
                      dimension: 40.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: MiniProgress(),
                            ),
                          ),
                          Positioned.fill(
                            child: PlayPauseBtn(
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const NextBtn(
                      alwaysShow: true,
                    ),
                  ],
                ),
                const Divider(
                  height: 1.2,
                ),
                Expanded(
                  child: nowPlayingController.when(
                    skipLoadingOnReload: true,
                    data: (data) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final song = data.elementAt(index);
                          return SongListTile(song: song);
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
          ),
        ),
        Positioned(
          bottom: -40,
          right: -40,
          child: ArcMenu(
            mini: true,
            radius: 80.0,
            startAngle: pi,
            endAngle: pi * 1.5,
            children: [
              IconButton.filled(
                onPressed: () async {
                  final songs = player.sequence?.length;
                  final currentIndex = player.currentIndex;
                  if (songs == null || currentIndex == null) {
                    return;
                  }
                  print("The current index: $currentIndex");
                  await scrollController.animateTo(
                    70.0 * currentIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                icon: const Icon(FluentIcons.arrow_step_in_24_regular),
              ),
              const ShuffleBtn(
                filled: true,
              ),
              const RepeatBtn(
                filled: true,
              ),
            ],
            child: (opened, anim) {
              return AnimatedSwitcher(
                duration: anim.duration ?? const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  !opened
                      ? FluentIcons.options_24_regular
                      : FluentIcons.dismiss_24_regular,
                  key: ValueKey<bool>(opened),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
