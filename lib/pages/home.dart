import 'package:beamer/beamer.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:tunes/components/album/list_view/album_list_view.dart';
import 'package:tunes/components/artists/list_view/artists_list_view.dart';
import 'package:tunes/components/player/collapsed_player.dart';
import 'package:tunes/components/songs/list_view/songs_list_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

enum SwipeDirection { left, right }

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(audioPathsWatcherProvider, (previous, next) {});
    final initialTabIndex = ref.watch(tabIndexProvider);

    final tabController = useTabController(
      initialLength: 4,
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

    return ScaffoldPage(
      padding: EdgeInsets.only(
        top: context.statusBarHeight,
      ),
      header: PageHeader(
        title: Text(
          "Tunes",
          style: context.textTheme.headlineSmall,
        ),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            if (kDebugMode)
              CommandBarButton(
                onPressed: () {
                  Navigator.of(context).push(
                    routeTo(
                      page: DriftDbViewer(
                        ref.read(databaseProvider),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  FluentIcons.window_database_24_regular,
                  size: 24.0,
                ),
              ),
            CommandBarButton(
              onPressed: () async {
                await ref
                    .read(
                      audioPathsProvider.notifier,
                    )
                    .pickMediaPath();
              },
              icon: const Icon(
                FluentIcons.folder_add_24_regular,
                size: 24.0,
              ),
            ),
            CommandBarButton(
              onPressed: () async {
                showBarModalBottomSheet(
                  context: context,
                  backgroundColor:
                      FluentTheme.of(context).inactiveBackgroundColor,
                  builder: (context) {
                    return const GlobalSearchBox();
                  },
                );
              },
              icon: const Icon(
                FluentIcons.search_24_regular,
                size: 24.0,
              ),
            ),
          ],
          secondaryItems: [
            CommandBarButton(
              onPressed: () {
                context.beamToNamed('/scan');
              },
              icon: const Icon(
                FluentIcons.slide_multiple_search_24_regular,
                size: 24.0,
              ),
              label: const Text("Scan Music"),
            ),
            CommandBarButton(
              onPressed: () {
                context.beamToNamed('/settings');
              },
              icon: const Icon(
                FluentIcons.settings_24_regular,
                size: 24.0,
              ),
              label: const Text("Settings"),
            ),
          ],
        ),
      ),
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: material.Material(
              type: material.MaterialType.transparency,
              child: Column(
                children: [
                  material.TabBar(
                    controller: tabController,
                    isScrollable: true,
                    indicatorSize: material.TabBarIndicatorSize.label,
                    unselectedLabelColor:
                        context.textTheme.labelLarge?.color?.withOpacity(.5),
                    labelStyle: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      material.Tab(
                        text: "Songs",
                      ),
                      material.Tab(
                        text: "Artists",
                      ),
                      material.Tab(
                        text: "Albums",
                      ),
                      material.Tab(
                        text: "Playlists",
                      ),
                    ],
                  ),
                  Expanded(
                    child: material.TabBarView(
                      controller: tabController,
                      children: const [
                        SongsListView(),
                        ArtistsListView(),
                        AlbumsListView(),
                        Placeholder(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            child: CollapsedPlayer(),
          ),
        ],
      ),
    );
  }
}

class GlobalSearchBox extends HookConsumerWidget {
  const GlobalSearchBox({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ).copyWith(
            bottom: 24.0,
            top: 36.0,
          ),
          child: AutoSuggestBox<String>(
            leadingIcon: const Icon(
              FluentIcons.search_24_regular,
            ),
            items: [
              'Abyssinian',
              'Aegean',
              'American Bobtail',
              'American Curl',
            ].map(
              (cat) {
                return AutoSuggestBoxItem<String>(
                  value: cat,
                  label: cat,
                  onFocusChange: (focused) {
                    if (focused) {
                      debugPrint('Focused $cat');
                    }
                  },
                );
              },
            ).toList(),
            onSelected: (item) {},
          ),
        ),
      ],
    );
  }
}
