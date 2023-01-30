import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/providers/main.dart';

final nowOrPreviousProvider = StateProvider<Audio?>(
  (ref) {
    return;
  },
);

class PlayingNowOrPreviousBuilder extends ConsumerWidget {
  const PlayingNowOrPreviousBuilder({
    super.key,
    required this.builder,
  });
  final Widget Function(
    BuildContext context,
    Uint8List? artwork,
    String? title,
    String? album,
    String? artist,
  ) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(nowPlayingProvider, (previous, next) {
      if (next == null) {
        ref.read(nowOrPreviousProvider.notifier).state = previous;
      } else {
        ref.read(nowOrPreviousProvider.notifier).state = next;
      }
    });

    final current = ref.watch(nowOrPreviousProvider);
    final artWork = current?.metas.extra?['artWork'];
    final title = current?.metas.title;
    final album = current?.metas.album;
    final artist = current?.metas.artist;
    return builder(context, artWork, title, album, artist);
  }
}
