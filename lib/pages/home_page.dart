import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/components/common/play_pause_btn.dart';

import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/views/albums_list_view.dart';
import 'package:tunes/views/artists_list_view.dart';
import 'package:tunes/views/genres_list_view.dart';
import 'package:tunes/views/playlists_list_view.dart';
import 'package:tunes/views/songs_list_view.dart';

import '../components/mini_player.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialTabIndex = ref.watch(tabIndexProvider);

    final tabController = useTabController(
      initialLength: 5,
      initialIndex: initialTabIndex,
    );

    useEffect(
      () {
        void tabChanged() {
          ref
              .read(
                tabIndexProvider.notifier,
              )
              .changeIndex(
                tabController.index,
              );
          debugPrint(
            'Tab changed: ${tabController.index}',
          );
        }

        tabController.addListener(tabChanged); // Add listener

        return () => tabController
            .removeListener(tabChanged); // Remove listener when not needed
      },
      [tabController],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tunes"),
      ),
      body: WithPlayer(
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor:
                  context.textTheme.labelLarge?.color?.withOpacity(.5),
              labelStyle: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(
                  text: "Songs",
                ),
                Tab(
                  text: "Artists",
                ),
                Tab(
                  text: "Albums",
                ),
                Tab(
                  text: "Genres",
                ),
                Tab(
                  text: "Playlists",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  SongsListView(),
                  ArtistsListView(),
                  AlbumsListView(),
                  GenresListView(),
                  PlaylistsListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithPlayer extends HookConsumerWidget {
  final Widget child;
  const WithPlayer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncPlayerState = ref.watch(playerStateProvider);
    const hiddenPosition = -72.0;
    const visiblePosition = 10.0;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: child,
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut,
          bottom: asyncPlayerState.when(
            data: (data) {
              switch (data.processingState) {
                case ProcessingState.idle:
                  return hiddenPosition;
                case ProcessingState.loading:
                  return hiddenPosition;
                case ProcessingState.buffering:
                  return hiddenPosition;
                case ProcessingState.ready:
                  return visiblePosition;
                case ProcessingState.completed:
                  return visiblePosition;
              }
            },
            error: (error, stackTrace) => hiddenPosition,
            loading: () => hiddenPosition,
          ),
          child: const MiniPlayer(),
        )
      ],
    );
  }
}
