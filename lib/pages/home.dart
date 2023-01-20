import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/album_view.dart';
import 'package:tunes/components/artists_view.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/songs_view.dart';
import 'package:tunes/pages/find_songs.dart';
import 'package:tunes/pages/media_folders.dart';
import 'package:tunes/pages/scan_music.dart';
import 'package:tunes/providers/main.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaPths = ref.watch(mediaPathsProvider);
    final mpaths = mediaPths.valueOrNull;

    if (mpaths == null) {
      return const MediaFolders();
    }

    if (mpaths.isEmpty) {
      return const MediaFolders();
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const HeroIcon(
                HeroIcons.clock,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: context.screenHeight * .3,
                    child: Column(
                      children: [
                        Slider(
                          value: 30,
                          min: 0,
                          max: 90,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const HeroIcon(
                HeroIcons.magnifyingGlass,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => const FindSongs(),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const HeroIcon(
                HeroIcons.ellipsisVertical,
              ),
              onSelected: (value) {
                if (value.isEmpty) {
                  return;
                }
                switch (value) {
                  case "/scanmusic":
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const ScanMusic();
                      },
                    );
                    break;
                  default:
                }
                // Navigator.of(context).pushNamed(value);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "/scanmusic",
                    child: Text("Find Local Songs"),
                  ),
                  ...[
                    "Manage Songs",
                    "Settings",
                  ].map(
                    (menuEntry) {
                      return PopupMenuItem<String>(
                        child: Text(menuEntry),
                      );
                    },
                  ).toList()
                ];
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              top: 8.0,
              bottom: context.screenHeight * .05,
              left: 16.0,
            ),
            title: Text(
              "MUSIC",
              style: context.textTheme.headline5,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor:
                context.colorScheme.onBackground.withOpacity(.5),
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
                text: "Playlists",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SongsView(),
            ArtistsView(),
            AlbumView(),
            Icon(Icons.directions_bike),
          ],
        ),
        bottomNavigationBar: const CollapsedPlayer(),
      ),
    );
  }
}
