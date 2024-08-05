
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/pages/playlist_info.dart';

import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

import 'package:tunes/views/albums_list_view.dart';
import 'package:tunes/views/artists_list_view.dart';
import 'package:tunes/views/genres_list_view.dart';
import 'package:tunes/views/playlists_list_view.dart';
import 'package:tunes/views/songs_list_view.dart';

import 'package:tunes/components/with_player.dart';

import 'package:tunes/components/options_view.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(indexingControllerProvider);
            },
            icon: const Icon(FluentIcons.arrow_reset_24_regular),
          ),
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: CustomSearchHintDelegate(
                  tabController: tabController,
                ),
              );
            },
            icon: const Icon(
              FluentIcons.search_24_filled,
            ),
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                // backgroundColor: Colors.transparent,
                constraints: BoxConstraints(
                  minWidth: context.shortestSide,
                  maxWidth: context.shortestSide,
                  minHeight: 300.0,
                  maxHeight: 300.0,
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
                  return const OptionsView();
                },
              );
            },
            icon: const Icon(
              FluentIcons.options_24_regular,
            ),
          ),
        ],
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
                children: [
                  const SongsView(),
                  const ArtistsListView(),
                  const AlbumsListView(),
                  const GenresListView(),
                  PlaylistsListView(
                    onTap: (value) {
                      // Navigate to song info page
                      Navigator.of(context).push(
                        routeTo(
                          page: PlaylistInfoPage(
                            playlist: value,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchHintDelegate extends SearchDelegate<String> {
  CustomSearchHintDelegate({
    required this.tabController,
  }) : super(
          searchFieldLabel: "Search",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  final TabController tabController;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return TabBar(
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        SongsView(
          searchQuery: query,
        ),
        ArtistsListView(
          searchQuery: query,
        ),
        AlbumsListView(
          searchQuery: query,
        ),
        GenresListView(
          searchQuery: query,
        ),
        PlaylistsListView(
          searchQuery: query,
          onTap: (value) {
            // Navigate to song info page
            Navigator.of(context).push(
              routeTo(
                page: PlaylistInfoPage(
                  playlist: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        SongsView(
          searchQuery: query,
        ),
        ArtistsListView(
          searchQuery: query,
        ),
        AlbumsListView(
          searchQuery: query,
        ),
        GenresListView(
          searchQuery: query,
        ),
        PlaylistsListView(
          searchQuery: query,
          onTap: (value) {
            // Navigate to song info page
            Navigator.of(context).push(
              routeTo(
                page: PlaylistInfoPage(
                  playlist: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[];

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }
}
