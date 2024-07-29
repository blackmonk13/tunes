import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class AsyncPlaylistView extends StatelessWidget {
  const AsyncPlaylistView({
    super.key,
    required this.asyncPlaylists,
    this.onTap,
    this.onNew,
    this.searchQuery = "",
  });
  final AsyncValue<List<PlaylistModel>> asyncPlaylists;
  final ValueChanged<PlaylistModel>? onTap;
  final ValueChanged<PlaylistModel>? onNew;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return asyncPlaylists.when(
      data: (data) {
        List<PlaylistModel> playlists = data;

        if (searchQuery.isNotEmpty) {
          playlists = data.where((el) {
            for (final e in [el.playlist]) {
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
            ListTile(
              onTap: () async {
                final playlist = await showDialog<PlaylistModel>(
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
              leading: const Icon(
                FluentIcons.add_24_regular,
              ),
              title: const Text("New playlist"),
            ),
            const Divider(
              height: 2.0,
            ),
            Expanded(
              child: ListView.builder(
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
  final ValueChanged<PlaylistModel>? onTap;
  final ValueChanged<PlaylistModel>? onNew;
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesPlaylistProvider);
    final asyncPlaylists = ref.watch(playlistsControllerProvider);

    return AsyncPlaylistView(
      asyncPlaylists: asyncPlaylists,
      searchQuery: searchQuery,
      onTap: onTap,
      onNew: onNew,
    );
  }
}

class PlaylistListTile extends ConsumerWidget {
  const PlaylistListTile({
    super.key,
    required this.playlist,
    this.onTap,
  });

  final PlaylistModel playlist;
  final ValueChanged<PlaylistModel>? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        onTap?.call(playlist);
      },
      title: Text(
        playlist.playlist,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      subtitle: Text(
        (() {
          final songCount = playlist.numOfSongs;

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
      leading: SongArtwork(
        id: playlist.id,
        type: ArtworkType.PLAYLIST,
        borderRadius: BorderRadius.circular(20.0),
        size: 50,
        width: 50,
        height: 50,
        hasBorder: true,
      ),
    );
  }
}

class NewPlaylistdialog extends HookConsumerWidget {
  const NewPlaylistdialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    return Dialog(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Playlist",
                  ),
                  IconButton(
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
                    icon: const Icon(
                      FluentIcons.checkmark_circle_24_filled,
                    ),
                  ),
                ],
              ),
              const Divider(),
              FormBuilderTextField(
                name: 'name',
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
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  label: Text("Name"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
