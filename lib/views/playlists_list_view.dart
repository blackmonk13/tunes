import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/dialog_title.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/pages/smart_playlist.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/utils/constants.dart';
import 'package:tunes/utils/playlist_names.dart';
import 'package:tunes/utils/smart_playlists.dart';

class AsyncPlaylistView extends StatelessWidget {
  const AsyncPlaylistView({
    super.key,
    required this.asyncPlaylists,
    this.onTap,
    this.onNew,
    this.searchQuery = "",
    this.showSmartPlaylists = false,
    this.favorites,
  });
  final AsyncValue<List<Playlist>> asyncPlaylists;
  final bool showSmartPlaylists;

  /// Pinned above the smart playlists, and left out of the list below them.
  final Playlist? favorites;
  final ValueChanged<Playlist>? onTap;
  final ValueChanged<Playlist>? onNew;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final playlistsView = _buildPlaylists(context);
    if (!showSmartPlaylists || searchQuery.isNotEmpty) return playlistsView;

    return Column(
      children: [
        if (favorites != null)
          PlaylistListTile(playlist: favorites!, onTap: onTap),
        for (final kind in SmartPlaylistKind.values)
          ListTile(
            leading: Icon(kind.icon),
            title: Text(kind.title),
            subtitle: Text(kind.description),
            onTap: () {
              Navigator.of(context).push(
                routeTo(page: SmartPlaylistPage(kind: kind)),
              );
            },
          ),
        const Divider(height: 1.5),
        Expanded(child: playlistsView),
      ],
    );
  }

  Widget _buildPlaylists(BuildContext context) {
    return asyncPlaylists.when(
      data: (data) {
        List<Playlist> playlists = data;

        if (showSmartPlaylists && searchQuery.isEmpty && favorites != null) {
          playlists = data.where((el) => el.name != favsPlaylistName).toList();
        }

        if (searchQuery.isNotEmpty) {
          playlists = data.where((el) {
            for (final e in [el.displayName]) {
              if (e.toLowerCase().contains(searchQuery.toLowerCase())) {
                return true;
              }
            }
            return false;
          }).toList();
        }

        if (playlists.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  "No playlists yet",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            MaterialButton(
              minWidth: context.screenWidth - 32.0,
              shape: StadiumBorder(
                side: BorderSide(color: context.colorScheme.outline, width: .3),
              ),
              onPressed: () async {
                final playlist = await showDialog<Playlist>(
                  context: context,
                  builder: (context) {
                    return const NewPlaylistdialog();
                  },
                );

                if (playlist == null) {
                  return;
                }

                onNew?.call(playlist);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.add_20_regular),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text("Create a New Playlist")
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                // padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: playlists.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentPlaylist = playlists[index];

                  return PlaylistListTile(
                    playlist: currentPlaylist,
                    onTap: onTap,
                  );
                },
              ),
            ),
          ],
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

class PlaylistsListView extends ConsumerWidget {
  const PlaylistsListView({
    super.key,
    this.onTap,
    this.onNew,
    this.searchQuery = "",
  });
  final ValueChanged<Playlist>? onTap;
  final ValueChanged<Playlist>? onNew;
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesPlaylistProvider).valueOrNull;
    final asyncPlaylists = ref.watch(playlistsControllerProvider);

    return AsyncPlaylistView(
      asyncPlaylists: asyncPlaylists,
      searchQuery: searchQuery,
      onTap: onTap,
      onNew: onNew,
      showSmartPlaylists: true,
      favorites: favorites,
    );
  }
}

class PlaylistListTile extends ConsumerWidget {
  const PlaylistListTile({
    super.key,
    required this.playlist,
    this.onTap,
  });

  final Playlist playlist;
  final ValueChanged<Playlist>? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        onTap?.call(playlist);
      },
      leading: PlaylistThumbnail(
        playlist: playlist,
        size: 50,
        hasBorder: true,
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        playlist.displayName,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        (() {
          final songCount = playlist.songs.length;

          if (songCount == 1) {
            return "$songCount song";
          }
          return "$songCount songs";
        })(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      // This Widget will query/load image.
      // You can use/create your own widget/method using [queryArtwork].
      // leading: SongArtwork(
      //   id: playlist.id,
      //   type: ArtworkType.PLAYLIST,
      //   borderRadius: BorderRadius.circular(20.0),
      //   size: 50,
      //   width: 50,
      //   height: 50,
      //   hasBorder: true,
      // ),
    );
  }
}

class NewPlaylistdialog extends HookConsumerWidget {
  const NewPlaylistdialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    return Dialog(
      backgroundColor: context.colorScheme.outlineVariant,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
        side: BorderSide(
          color: context.colorScheme.outline.withOpacity(.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitle(
                title: "Create a New Playlist",
              ),
              const Divider(),
              FormBuilderTextField(
                name: 'name',
                keyboardType: TextInputType.name,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    (value) {
                      if (value == null) {
                        return "Must be a valid name";
                      }

                      if (value.isEmpty) {
                        return "Name should not be empty";
                      }

                      return null;
                    }
                  ],
                ),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 24.0,
                    ),
                    filled: true,
                    fillColor: context.colorScheme.outline.withOpacity(.5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    // label: const Text("Name"),
                    hintText: "Name"),
              ),
              const Divider(),
              MaterialButton(
                color: context.colorScheme.primary,
                textColor: context.colorScheme.onPrimary,
                minWidth: context.screenWidth,
                onPressed: () async {
                  if (!context.mounted) {
                    return;
                  }
                  // Validate and save the form values
                  final validated = formKey.currentState?.saveAndValidate();
                  if (validated != true) {
                    return;
                  }

                  final formMap = formKey.currentState?.value;

                  if (formMap == null) {
                    return;
                  }

                  final playlistName = formMap['name'];

                  if (playlistName == null) {
                    return;
                  }

                  final playlist = await ref
                      .read(playlistsControllerProvider.notifier)
                      .createPlaylist(
                        playlistName,
                      );

                  if (playlist == null) {
                    if (context.mounted) {
                      context.showErrorSnackBar(
                        message: "Error creating playlist $playlistName",
                      );
                      Navigator.of(context).maybePop();
                    }
                    return;
                  }

                  if (context.mounted) {
                    context.showSnackBar(
                      message: "Playlist $playlistName created",
                    );
                    Navigator.of(context).maybePop(playlist);
                  }
                },
                child: Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistThumbnail extends StatelessWidget {
  final Playlist playlist;
  final double size;
  final bool mini;
  final bool hasBorder;
  final BorderRadiusGeometry? borderRadius;
  final FilterQuality filterQuality;

  const PlaylistThumbnail({
    super.key,
    required this.playlist,
    this.size = 50.0,
    this.hasBorder = true,
    this.borderRadius,
    this.mini = true,
    this.filterQuality = FilterQuality.low,
  });

  @override
  Widget build(BuildContext context) {
    // Convert IsarLinks to List for easier manipulation
    final songsList = playlist.songs.toList();

    // Filter songs with non-null thumbnails
    final songsWithThumbnails = songsList
        .where((song) =>
            (mini ? song.thumbnailMiniPath : song.thumbnailPath) != null)
        .toList();

    // If no songs have thumbnails, show single placeholder
    if (songsWithThumbnails.isEmpty) {
      return Thumbnail(
        width: size,
        height: size,
        hasBorder: hasBorder,
        borderRadius: borderRadius,
      );
    }

    // If we have songs with thumbnails but less than 4, pad with nulls
    final thumbnailPaths = songsWithThumbnails.length >= 4
        ? songsWithThumbnails
            .take(4)
            .map((s) => (mini ? s.thumbnailMiniPath : s.thumbnailPath)!)
            .toList()
        : [
            ...songsWithThumbnails
                .map((s) => (mini ? s.thumbnailMiniPath : s.thumbnailPath)!),
            ...List.filled(4 - songsWithThumbnails.length, null)
          ];

    // Calculate dimensions for grid items
    final gridItemSize = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: hasBorder
              ? BoxDecoration(
                  border: Border.all(
                    color: context.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                )
              : null,
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: thumbnailPaths
                .map((path) => Thumbnail(
                      thumbnail: path,
                      width: gridItemSize,
                      height: gridItemSize,
                      hasBorder: false,
                      borderRadius: BorderRadius.zero,
                      filterQuality: filterQuality,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
