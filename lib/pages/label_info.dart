import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/with_player.dart';
import 'package:tunes/utils/media_query.dart';
import 'package:tunes/views/songs_list_view.dart';

/// Every song that has [label].
class LabelInfoPage extends ConsumerWidget {
  const LabelInfoPage({
    super.key,
    required this.label,
  });

  final Label label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label.name),
      ),
      body: WithPlayer(
        child: SongsView(
          queryType: SongQueryType.label,
          query: label.name,
        ),
      ),
    );
  }
}
