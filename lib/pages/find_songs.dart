import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/album_view.dart';
import 'package:tunes/components/artists_view.dart';
import 'package:tunes/components/collapsed_player.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/song_tile.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/providers/main.dart';

final queryProvider = StateProvider.autoDispose<String>(
  (ref) {
    return "";
  },
);

class FindSongs extends ConsumerWidget {
  const FindSongs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(queryProvider);
    final asyncSongs = ref.watch(songsProvider);
    final asyncAlbums = ref.watch(albumsProvider);
    final asyncArtists = ref.watch(artistsProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              top: context.screenHeight * .1,
              child: CustomScrollView(
                slivers: <Widget>[
                  if (query.isNotEmpty && query.length > 2) ...[
                    ..._buildSongs(context, asyncSongs, query),
                    ..._buildAlbums(context, asyncAlbums, query),
                    ..._buildArtists(context, asyncArtists, query),
                  ]
                ],
              ),
            ),
            Positioned(
              width: context.screenWidth,
              height: context.screenHeight * .1,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: SearchField(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CollapsedPlayer(),
    );
  }

  Widget _boxSliver({Widget? child}) {
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget _errorSliver(Object error, StackTrace stackTrace) {
    return _boxSliver(
      child: const Text("Error"),
    );
  }

  Widget _loadingSliver() {
    return _boxSliver(
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );
  }

  List<Widget> _buildSongs(
    BuildContext context,
    AsyncValue<List<Audio>> asyncSongs,
    String query,
  ) {
    return asyncSongs.when(
      data: (data) {
        final filteredSongs = data.where(
          (element) {
            if (query.isEmpty) {
              return false;
            }
            if (query.length < 3) {
              return false;
            }
            return element.metas.title?.toLowerCase().trim().contains(query) ??
                false;
          },
        ).toList();
        if (filteredSongs.isEmpty) {
          return [];
        }
        return headerList(
          title: const Text("Songs"),
          itemExtent: 70,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return SongTile(
                audio: filteredSongs[index],
              );
            },
            childCount: filteredSongs.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return [_errorSliver(error, stackTrace)];
      },
      loading: () {
        return [_loadingSliver()];
      },
    );
  }

  List<Widget> _buildAlbums(
    BuildContext context,
    AsyncValue<List<Album>> asyncAlbums,
    String query,
  ) {
    return asyncAlbums.when(
      data: (data) {
        final filteredAlbums = data.where(
          (element) {
            if (query.isEmpty) {
              return false;
            }
            if (query.length < 3) {
              return false;
            }
            return element.name?.toLowerCase().trim().contains(query) ?? false;
          },
        ).toList();

        if (filteredAlbums.isEmpty) {
          return [];
        }

        return headerList(
          title: const Text("Albums"),
          itemExtent: 70,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return AlbumTile(
                album: filteredAlbums[index],
              );
            },
            childCount: filteredAlbums.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return [_errorSliver(error, stackTrace)];
      },
      loading: () {
        return [_loadingSliver()];
      },
    );
  }

  List<Widget> _buildArtists(
    BuildContext context,
    AsyncValue<List<Artist>> asyncArtists,
    String query,
  ) {
    return asyncArtists.when(
      data: (data) {
        final filteredArtists = data.where(
          (element) {
            if (query.isEmpty) {
              return false;
            }
            if (query.length < 3) {
              return false;
            }
            return element.name?.toLowerCase().trim().contains(query) ?? false;
          },
        ).toList();

        if (filteredArtists.isEmpty) {
          return [];
        }

        return headerList(
          title: const Text("Artists"),
          itemExtent: 70,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ArtistTile(
                artist: filteredArtists[index],
              );
            },
            childCount: filteredArtists.length,
          ),
        );
      },
      error: (error, stackTrace) {
        return [_errorSliver(error, stackTrace)];
      },
      loading: () {
        return [_loadingSliver()];
      },
    );
  }
}

class SearchField extends HookConsumerWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return TextFormField(
      autofocus: true,
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        ref.read(queryProvider.notifier).state = controller.text;
      },
      onEditingComplete: () {
        ref.read(queryProvider.notifier).state = controller.text;
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          right: 28.0,
        ),
        hintText: "Search",
        suffixIconConstraints: BoxConstraints.tightFor(
          width: 24,
          height: 24,
        ),
        suffixIcon: HeroIcon(
          HeroIcons.magnifyingGlass,
        ),
      ),
    );
  }
}
