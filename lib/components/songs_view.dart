import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/components/tunes_view.dart';
import 'package:tunes/providers/main.dart';

class SongsView extends ConsumerWidget {
  const SongsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSongs = ref.watch(songsProvider);
    return TunesView(
      asyncSongs: asyncSongs,
      restorationId: "songsview",
    );
  }
}
