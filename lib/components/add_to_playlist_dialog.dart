import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/dialog_title.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/utils/playlist_names.dart';
import 'package:tunes/views/playlists_list_view.dart';

class AddToPlaylistDialog extends HookConsumerWidget {
  const AddToPlaylistDialog({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlaylists = ref.watch(playlistsControllerProvider);
    // Using useState hook to track selected playlists
    final selectedPlaylists = useState<Set<int>>({});

    Future<void> onAddToPlaylist(Playlist value) async {
      final added =
          await ref.read(playlistsControllerProvider.notifier).addToPlaylist(
                value,
                song,
              );
      if (added) {
        if (context.mounted) {
          context.showSnackBar(
            message: "${song.title} has been added to ${value.displayName}",
          );
          Navigator.of(context).maybePop();
        }
        return;
      }
      if (context.mounted) {
        context.showErrorSnackBar(
          message: "${song.title} could not be added to ${value.displayName}",
        );
        Navigator.of(context).maybePop();
      }
    }

    return Dialog(
      backgroundColor: context.colorScheme.outlineVariant,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        side: BorderSide(
          color: context.colorScheme.outline.withOpacity(.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitle(
              title: "Add to Playlist",
            ),
            const Divider(),
            MaterialButton(
              minWidth: context.screenWidth,
              shape: StadiumBorder(
                side: BorderSide(
                  color: context.colorScheme.outline,
                ),
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
            const Divider(),
            asyncPlaylists.when(
              data: (data) {
                List<Playlist> playlists = data;

                if (playlists.isEmpty) {
                  return SizedBox.shrink();
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: context.screenHeight * .4,
                  ),
                  child: ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (BuildContext context, int index) {
                      final playlist = playlists.elementAt(index);

                      return CheckboxListTile(
                        checkboxShape: CircleBorder(
                          side: BorderSide(
                            width: .3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        title: Text(
                          playlist.displayName,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text.rich(
                          TextSpan(
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.textTheme.labelSmall?.color
                                  ?.withOpacity(.5),
                            ),
                            children: [
                              TextSpan(
                                text: playlist.songs.countSync().toString(),
                              ),
                              TextSpan(text: "\t"),
                              TextSpan(
                                text: [
                                  "Song",
                                  playlist.songs.countSync() == 1 ? "" : "s"
                                ].join(""),
                              )
                            ],
                          ),
                        ),
                        value: selectedPlaylists.value.contains(playlist.id),
                        onChanged: (bool? checked) {
                          final newSelection =
                              Set<int>.from(selectedPlaylists.value);
                          if (checked == true) {
                            newSelection.add(playlist.id);
                          } else {
                            newSelection.remove(playlist.id);
                          }
                          selectedPlaylists.value = newSelection;
                        },
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return Expanded(
                  child: AsyncErrorView(
                    error: error,
                    stackTrace: stackTrace,
                  ),
                );
              },
              loading: () {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return const SongListTileLoading();
                    },
                  ),
                );
              },
            ),
            const Divider(),
            MaterialButton(
              color: context.colorScheme.primary,
              textColor: selectedPlaylists.value.isEmpty
                  ? null
                  : context.colorScheme.onPrimary,
              minWidth: context.screenWidth,
              onPressed: selectedPlaylists.value.isEmpty
                  ? null
                  : () async {
                      final selectedItems = asyncPlaylists.valueOrNull
                          ?.where((p) => selectedPlaylists.value.contains(p.id))
                          .toList();
                      if (selectedItems == null) {
                        return;
                      }

                      await Future.wait(
                          selectedItems.map((item) => onAddToPlaylist(item)));
                    },
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
