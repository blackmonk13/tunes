import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/breath.dart';
import 'package:tunes/pages/media_folders.dart';
import 'package:tunes/providers/main.dart';

class ScanMusic extends ConsumerStatefulWidget {
  const ScanMusic({super.key});

  @override
  ConsumerState<ScanMusic> createState() => _ScanMusicState();
}

class _ScanMusicState extends ConsumerState<ScanMusic> {
  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Music"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value.isEmpty) {
                return;
              }
              switch (value) {
                case "/mediafolders":
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const MediaFolders();
                    },
                  );
                  break;
                default:
              }
              Navigator.of(context).pushNamed(value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "/mediafolders",
                  child: Text("Media Folders"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Breath(),
              const Spacer(),
              Column(
                children: [
                  Text(
                    songs.when(
                      data: (data) {
                        return "Scan Complete";
                      },
                      error: (error, stackTrace) {
                        return "Scan Error";
                      },
                      loading: () {
                        return "Scanning";
                      },
                    ),
                    style: context.textTheme.headlineSmall,
                  ),
                  Text(
                    "${songs.valueOrNull?.length ?? 0} songs found",
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(songsListProvider);
                },
                child: const Text(
                  "Scan again",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
