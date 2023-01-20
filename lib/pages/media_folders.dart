
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';

class MediaFolders extends ConsumerWidget {
  const MediaFolders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaPths = ref.watch(mediaPathsProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text("Music Folders"),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              mediaPths.when(
                data: (data) {
                  if (data.isEmpty) {
                    return [
                      const Center(child: Text("Nothing Here")),
                    ];
                  }
                  return data.map(
                    (dirpath) {
                      final cdir = basename(dirpath);
                      return ListTile(
                        title: Text(cdir),
                        subtitle: Text(dirpath),
                      );
                    },
                  ).toList();
                },
                error: (error, stackTrace) {
                  return [
                    Text("We encountered an unknown Error"),
                  ];
                },
                loading: () {
                  return [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ];
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final fpath = await pickMediaPath();

          if (fpath == null) {
            return;
          }

          final isSaved = await setMediaPaths(fpath);

          if (isSaved) {
            ref.invalidate(mediaPathsProvider);
          }
        },
        label: const Text("Add Folder"),
      ),
    );
  }
}
