import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/utils/extensions.dart';

import 'package:tunes/pages/artist_info.dart';
import 'package:tunes/utils/media_query.dart';

class ArtistListTile extends StatelessWidget {
  const ArtistListTile({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigate to song info page
        Navigator.of(context).push(
          routeTo(
            page: ArtistInfoPage(
              artist: artist,
            ),
          ),
        );
      },
      title: Text(
        artist.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: context.textTheme.bodyLarge,
      ),
      subtitle: Text(
        (() {
          final songCount = artist.songs.length;

          if (songCount == 1) {
            return "$songCount song";
          }
          return "$songCount songs";
        })(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: (() {
          final textTheme = context.textTheme.labelSmall;
          return textTheme?.copyWith(
            color: textTheme.color?.withOpacity(.7),
          );
        })(),
      ),
      leading: Thumbnail(
        thumbnail: artist.artworkPath ?? artist.songs.first.thumbnailMiniPath,
        borderRadius: BorderRadius.circular(20.0),
        width: 50,
        height: 50,
        hasBorder: true,
      ),
    );
  }
}

class ArtistsView extends HookConsumerWidget {
  const ArtistsView({
    super.key,
    this.searchQuery,
  });
  final String? searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    return ArtistsListView(
      searchQuery: searchQuery,
      scrollController: scrollController,
    );
  }
}

class ArtistsListView extends ConsumerWidget {
  const ArtistsListView({
    super.key,
    this.scrollController,
    this.searchQuery,
  });

  final ScrollController? scrollController;
  final String? searchQuery;

  static const pageSize = 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCount = ref.watch(artistsCountProvider(
      searchQuery: searchQuery,
    ));
    return asyncCount.when(
      data: (itemCount) {
        if (itemCount == 0) {
          return Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "No albums",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            final page = index ~/ pageSize;
            final offset = page * pageSize;
            final indexInPage = index % pageSize;
            final asyncQueryValue = ref.watch(artistsQueryProvider(
              pageSize,
              offset,
              searchQuery: searchQuery,
            ));
            return asyncQueryValue.when(
              data: (data) {
                final item = data.elementAt(indexInPage);
                return ArtistListTile(
                  artist: item,
                );
              },
              error: (error, stackTrace) {
                return ListTile(
                  leading: const Icon(FluentIcons.warning_24_regular),
                  title: const Text("Error"),
                  subtitle: Text(error.toString()),
                );
              },
              loading: () {
                return const SongListTileLoading();
              },
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
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const SongListTileLoading();
          },
        );
      },
    );
  }
}
