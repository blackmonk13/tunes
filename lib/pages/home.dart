import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/album_view.dart';
import 'package:tunes/components/artists_view.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/playlists_view.dart';
import 'package:tunes/components/set_timer.dart';
import 'package:tunes/components/songs_view.dart';
import 'package:tunes/controllers/main.dart';
import 'package:tunes/pages/find_songs.dart';
import 'package:tunes/pages/media_folders.dart';
import 'package:tunes/pages/scan_music.dart';
import 'package:tunes/pages/settings.dart';
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
    final songList = ref.watch(songsProvider);
    final mpaths = mediaPths.valueOrNull;

    if (mpaths == null) {
      return const MediaFolders();
    }

    if (mpaths.isEmpty) {
      return const MediaFolders();
    }

    return songList.when(
      data: (data) {
        if (data.isEmpty) {
          return const ScanMusic();
        }
        return _defaultView();
      },
      error: (error, stackTrace) {
        return const ScanMusic();
      },
      loading: () {
        return _defaultView(loading: true);
      },
    );
  }

  Widget _defaultView({bool loading = false}) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (kDebugMode)
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DriftDbViewer(ref.read(databaseProvider)),
                    ),
                  );
                },
                icon: const HeroIcon(
                  HeroIcons.circleStack,
                ),
              ),
            _timerBtn(),
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
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Settings()),
                    );
                }
                // Navigator.of(context).pushNamed(value);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "/scanmusic",
                    child: Text("Scan Songs"),
                  ),
                  const PopupMenuItem(
                    value: "/settings",
                    child: Text("Settings"),
                  ),
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
              style: context.textTheme.headlineSmall,
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
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: context.colorScheme.primary,
                  strokeWidth: 2.0,
                ),
              )
            : const TabBarView(
                children: [
                  SongsView(),
                  ArtistsView(),
                  AlbumView(),
                  PlayListsView(),
                ],
              ),
        bottomNavigationBar: const CollapsedPlayer(),
      ),
    );
  }

  Widget _timerBtn() {
    return Consumer(builder: (context, ref, child) {
      final timer = ref.watch(timerControllerProvider);
      return IconButton(
        icon: HeroIcon(
          HeroIcons.clock,
          color: timer.when(
            data: (data) => null,
            error: (error, stackTrace) => null,
            loading: () => context.colorScheme.primary,
          ),
        ),
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            enableDrag: false,
            builder: (context) => const SetTimer(),
          );
        },
      );
    });
  }
}
