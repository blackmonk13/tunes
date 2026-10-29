import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:tunes/components/now_playing_view.dart';
import 'package:tunes/components/player_btns.dart';
import 'package:tunes/components/player_controls.dart';
import 'package:tunes/components/scrolling_text.dart';
import 'package:tunes/pages/album_info.dart';
import 'package:tunes/pages/artist_info.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

class PlayerDetailsAndControls extends ConsumerWidget {
  const PlayerDetailsAndControls({
    super.key,
    this.song,
    this.fgColor,
    this.bgColor,
  });
  final Song? song;
  final Color? fgColor;
  final Color? bgColor;

  /// Closes the full player sheet, then opens [page] on the app's navigator.
  void _openFromPlayer(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(routeTo(page: page));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artist = song?.artist.value;
    final album = song?.album.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (song != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ScrollingText(
              song?.title ?? "Unknown",
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: fgColor,
              ),
            ),
          ),
          DetailsText(
            text: song?.artist.value?.name,
            style: context.textTheme.headlineSmall?.copyWith(
              color: fgColor,
            ),
            onTap: artist == null
                ? null
                : () => _openFromPlayer(
                      context,
                      ArtistInfoPage(artist: artist),
                    ),
          ),
          DetailsText(
            text: song?.album.value?.title,
            style: context.textTheme.titleMedium?.copyWith(
              color: fgColor?.withOpacity(.8),
            ),
            onTap: album == null
                ? null
                : () => _openFromPlayer(
                      context,
                      AlbumInfoPage(album: album),
                    ),
          ),
        ],
        PlayerProgressBar(
          color: fgColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FavoriteBtn(
              song: song,
              fgColor: fgColor,
              bgColor: bgColor,
            ),
            ShuffleBtn(
              filled: true,
              builder: (icon, onTap) {
                return InkWell(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: fgColor,
                    foregroundColor: bgColor,
                    child: icon,
                  ),
                );
              },
            ),
            RepeatBtn(
              filled: true,
              builder: (icon, onTap) {
                return InkWell(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: fgColor,
                    foregroundColor: bgColor,
                    child: icon,
                  ),
                );
              },
            ),
            PreviousBtn(
              alwaysShow: true,
              builder: (icon, onTap) {
                return InkWell(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: fgColor,
                    foregroundColor: bgColor,
                    child: icon,
                  ),
                );
              },
            ),
            NextBtn(
              alwaysShow: true,
              builder: (icon, onTap) {
                return InkWell(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: fgColor,
                    foregroundColor: bgColor,
                    child: icon,
                  ),
                );
              },
            ),
            InkWell(
              onTap: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: context.colorScheme.outlineVariant,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return const NowPlayingView();
                  },
                );
              },
              child: CircleAvatar(
                backgroundColor: fgColor,
                foregroundColor: bgColor,
                child: const Icon(FluentIcons.reading_list_24_filled),
              ),
            ),
          ],
        ),
        SizedBox(
          height: context.screenHeight * .1,
        )
      ],
    );
  }
}

class DetailsText extends StatelessWidget {
  const DetailsText({
    super.key,
    this.text,
    this.style,
    this.onTap,
  });
  final String? text;
  final TextStyle? style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text ?? "Unknown",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: onTap == null
          ? label
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8.0),
              child: label,
            ),
    );
  }
}

class FavoriteBtn extends ConsumerWidget {
  const FavoriteBtn({
    super.key,
    this.song,
    this.fgColor,
    this.bgColor,
  });
  final Song? song;
  final Color? fgColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlaylist = ref.watch(favoritesPlaylistProvider);

    return asyncPlaylist.when(
      data: (data) {
        final songIsLiked = data.songs.contains(song);
        return LikeButton(
          size: 42,
          isLiked: songIsLiked,
          onTap: (isLiked) async {
            if (song == null) {
              return false;
            }

            print(songIsLiked);

            final liked = await ref
                .read(
                  favoritesPlaylistProvider.notifier,
                )
                .toggleFavorite(
                  song!,
                );

            // if (liked) {
            //   ref.invalidate(songsControllerProvider(
            //     query: favsPlaylistName,
            //     queryType: SongQueryType.songsForPlaylist,
            //   ));
            // }

            return liked;
          },
          likeBuilder: (bool isLiked) {
            return CircleAvatar(
              backgroundColor: fgColor,
              foregroundColor: bgColor,
              child: Icon(
                isLiked
                    ? FluentIcons.heart_24_filled
                    : FluentIcons.heart_24_regular,
              ),
            );
          },
        );
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
