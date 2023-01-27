import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sheet/route.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/database/database.dart';
import 'package:tunes/pages/album_songs.dart';
import 'package:tunes/pages/artist_songs.dart';
import 'package:tunes/pages/song_info.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class SongTile extends ConsumerStatefulWidget {
  const SongTile({
    super.key,
    required this.audio,
    this.onTap,
    this.selected = false,
  });
  final Audio audio;
  final void Function()? onTap;
  final bool selected;

  @override
  ConsumerState<SongTile> createState() => _SongTileState();
}

class _SongTileState extends ConsumerState<SongTile> {
  String get artistName {
    return widget.audio.metas.artist ?? "Unknown";
  }

  String get albumName {
    return widget.audio.metas.album ?? "Unknown";
  }

  String get songTitle {
    return widget.audio.metas.title ?? widget.audio.path;
  }

  Artist get artist {
    return widget.audio.metas.extra!['artist'];
  }

  Album get album {
    return widget.audio.metas.extra!['album'];
  }

  @override
  Widget build(BuildContext context) {
    final multiSelect = ref.watch(multiSelectSongsProvider);
    final selectedSongs = ref.watch(selectedSongsProvider);
    if (multiSelect) {
      return CheckboxListTile(
        dense: true,
        selected: widget.selected,
        title: titleW,
        subtitle: subTitle,
        value: selectedSongs.contains(widget.audio),
        onChanged: (value) {
          ref.read(selectedSongsProvider.notifier).add(widget.audio);
        },
      );
    }
    return ListTile(
      dense: true,
      selected: widget.selected,
      onTap: onTap,
      onLongPress: () {
        ref.read(multiSelectSongsProvider.notifier).state = !multiSelect;
        ref.read(selectedSongsProvider.notifier).add(widget.audio);
      },
      leading: leading,
      title: titleW,
      subtitle: subTitle,
      trailing: trailing,
    );
  }

  Widget get titleW {
    return Text(
      songTitle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget get subTitle {
    return Text(
      artistName,
    );
  }

  Widget get leading {
    // TODO:
    final tagImg = widget.audio.metas.extra?['artWork'];
    return CircleAvatar(
      backgroundImage: tagImg == null ? null : Image.memory(tagImg).image,
      child: tagImg == null ? const HeroIcon(HeroIcons.musicalNote) : null,
    );
  }

  Widget get trailing {
    return IconButton(
      onPressed: () {
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: context.screenHeight * .45,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        SheetRoute(
                          builder: (context) {
                            return ArtistSongs(
                              artist: artist,
                            );
                          },
                        ),
                      );
                    },
                    leading: const HeroIcon(HeroIcons.user),
                    title: Text(
                      artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        SheetRoute(
                          builder: (context) {
                            return AlbumSongs(
                              album: album,
                            );
                          },
                        ),
                      );
                    },
                    leading: const Icon(Icons.album_outlined),
                    title: Text(
                      albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      ref.read(nowPlayingPlaylistProvider).add(widget.audio);
                      Navigator.of(context).maybePop();
                    },
                    leading: const HeroIcon(HeroIcons.next),
                    title: const Text("Play Next"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        SheetRoute(
                          builder: (context) {
                            return SongInfo(
                              tune: widget.audio,
                            );
                          },
                        ),
                      );
                    },
                    leading: const HeroIcon(HeroIcons.informationCircle),
                    title: const Text("Song info"),
                  ),
                  ListTile(
                    onTap: () async {
                      if (!mounted) return;
                      Navigator.of(context).maybePop();
                      final deleted = await ref
                          .read(tunesRepositoryProvider)
                          .deleteTunes([widget.audio.path]);
                      if (!mounted) return;
                      if (deleted < 1) {
                        context.showErrorSnackBar(
                          message:
                              'Failed to delete ${widget.audio.metas.title}',
                        );
                      } else {
                        context.showSnackBar(
                          message: 'Deleted ${widget.audio.metas.title}',
                        );
                      }
                    },
                    leading: const HeroIcon(HeroIcons.trash),
                    title: const Text("Delete"),
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const HeroIcon(
        HeroIcons.ellipsisVertical,
      ),
    );
  }

  void onTap() {
    if (widget.onTap != null) {
      widget.onTap?.call();
      return;
    }
    ref.read(nowPlayingPlaylistProvider).add(widget.audio);
    final playlistAudios = ref.read(nowPlayingPlaylistProvider).audios;
    if (player.playlist == null) {
      player.open(
        ref.read(nowPlayingPlaylistProvider),
        autoStart: true,
        respectSilentMode: true,
        showNotification: true,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
        ),
        playInBackground: PlayInBackground.enabled,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
      );
    }
    final thisId = playlistAudios
        .indexWhere((element) => widget.audio.path == element.path);
    if (thisId > 0) {
      player.stop();
      player.playlistPlayAtIndex(thisId);
      return;
    }

    player.play();
  }
}
