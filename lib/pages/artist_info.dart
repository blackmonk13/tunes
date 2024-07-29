import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/sliver.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/views/albums_list_view.dart';
import 'package:tunes/views/songs_list_view.dart';

class ArtistInfoPage extends HookConsumerWidget {
  const ArtistInfoPage({
    super.key,
    required this.artist,
  });

  final ArtistModel artist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArtistAlbums = ref.watch(artistAlbumsProvider(artist));

    final scrollController = useScrollController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: WithPlayer(
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: context.screenHeight * 0.3,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(artist.artist),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colorScheme.background,
                          context.colorScheme.background.withOpacity(.0),
                        ],
                      ),
                    ),
                    child: SongArtwork(
                      id: artist.id,
                      type: ArtworkType.ARTIST,
                      size: (context.screenHeight * 0.3).toInt(),
                      height: context.screenHeight * 0.3,
                      width: context.screenHeight * 0.3,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: StickyHeaderDelegate(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
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
                        text: "Albums",
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    SongsListView(
                      query: artist.artist,
                      queryType: SongQueryType.songsForArtist,
                      scrollController: scrollController,
                    ),
                    AsyncAlbumsListView(
                      scrollController: scrollController,
                      asyncAlbums: asyncArtistAlbums,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
