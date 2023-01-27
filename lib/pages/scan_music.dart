import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/components/breath.dart';
import 'package:tunes/controllers/main.dart';
import 'package:tunes/pages/media_folders.dart';
import 'package:tunes/providers/main.dart';

class ScanMusic extends ConsumerStatefulWidget {
  const ScanMusic({super.key});

  @override
  ConsumerState<ScanMusic> createState() => _ScanMusicState();
}

class _ScanMusicState extends ConsumerState<ScanMusic> {
  bool get noSongs {
    final songs = ref.read(songsProvider).valueOrNull;
    if (songs == null) {
      return true;
    }

    if (songs.isEmpty) {
      return true;
    }

    return false;
  }

  bool get atleastOneSong {
    final itemCountStream = ref.read(scannedItemsProvider);
    final itemCount = itemCountStream.valueOrNull;
    if (itemCount == null) {
      return false;
    }
    if (itemCount < 1) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsProvider);
    final scanControl = ref.watch(scanControllerProvider);
    final itemCountStream = ref.watch(scannedItemsProvider);
    final itemCount = itemCountStream.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Music"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(databaseProvider).resetTunes();
            },
            icon: const HeroIcon(HeroIcons.arrowPathRoundedSquare),
          ),
          if (kDebugMode)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DriftDbViewer(ref.read(databaseProvider)),
                  ),
                );
              },
              icon: const HeroIcon(
                HeroIcons.circleStack,
              ),
            ),
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
              // Navigator.of(context).pushNamed(value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "/mediafolders",
                  child: Text("Media Folders"),
                ),
                const PopupMenuItem(
                  value: "/settings",
                  child: Text("Settings"),
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
              scanControl.when(
                data: (data) => const Breath(
                  multiplier: 1,
                ),
                error: (error, stackTrace) => const Breath(
                  multiplier: .7,
                ),
                loading: () => const Breath(
                  multiplier: .25,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    scanControl.when(
                      data: (data) {
                        if (!atleastOneSong) {
                          return "";
                        }
                        return "Scan Complete";
                      },
                      error: (error, stackTrace) {
                        if (!atleastOneSong) return "";
                        return "Scan Error:$error";
                      },
                      loading: () {
                        return "Scanning";
                      },
                    ),
                    style: context.textTheme.headlineSmall,
                  ),
                  if (atleastOneSong)
                    Text(
                      "${itemCount} songs found",
                      style: context.textTheme.bodySmall,
                    ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: scanControl.when(
                  data: (data) => () async {
                    await ref
                        .read(scanControllerProvider.notifier)
                        .scanAndPopulateDb();
                  },
                  error: (e, s) => () async {
                    await ref
                        .read(scanControllerProvider.notifier)
                        .scanAndPopulateDb();
                  },
                  loading: () {
                    return null;
                  },
                ),
                style: noSongs
                    ? ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.onPrimary,
                      )
                    : null,
                child: Text(
                  ["Scan", if (!noSongs) "again"].join(" "),
                ),
              ),
              if (noSongs) const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
