import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sheet/route.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/models/tune.dart';
import 'package:tunes/pages/album_songs.dart';
import 'package:tunes/pages/artist_songs.dart';
import 'package:tunes/pages/song_info.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class SongTile extends ConsumerStatefulWidget {
  const SongTile({
    super.key,
    required this.tune,
    this.onTap,
    this.selected = false,
  });
  final Tune tune;
  final void Function()? onTap;
  final bool selected;

  @override
  ConsumerState<SongTile> createState() => _SongTileState();
}

class _SongTileState extends ConsumerState<SongTile> {
  String get artistName {
    return getArtist(widget.tune) ?? "Unknown";
  }

  String get albumName {
    return getAlbum(widget.tune) ?? "Unknown";
  }

  String get songTitle {
    return getTitle(widget.tune) ?? "Unknown";
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
        value: selectedSongs.contains(widget.tune),
        onChanged: (value) {
          ref.read(selectedSongsProvider.notifier).add(widget.tune);
        },
      );
    }
    return ListTile(
      dense: true,
      selected: widget.selected,
      onTap: onTap,
      onLongPress: () {
        ref.read(multiSelectSongsProvider.notifier).state = !multiSelect;
        ref.read(selectedSongsProvider.notifier).add(widget.tune);
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
    final tagImg = widget.tune.artWork;
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
              height: context.screenHeight * .35,
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
                              artistName: artistName,
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
                              albumName: albumName,
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
                      Navigator.of(context).pushReplacement(
                        SheetRoute(
                          builder: (context) {
                            return SongInfo(
                              tune: widget.tune,
                            );
                          },
                        ),
                      );
                    },
                    leading: const HeroIcon(HeroIcons.informationCircle),
                    title: const Text("Song info"),
                  ),
                  ListTile(
                    onTap: () {},
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
    // final tuneAs = AudioSource.file(widget.tune.filePath);
    // player.setAudioSource(widget.tune.audioSource);
    // player.play();
    ref.read(playlistItemsProvider.notifier).add(widget.tune.audioSource);
  }
}
