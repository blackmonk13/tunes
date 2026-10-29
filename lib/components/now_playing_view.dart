import 'dart:math' as math;

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/song_list_tile.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class NowPlayingBtn extends StatelessWidget {
  const NowPlayingBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      onPressed: () async {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: context.colorScheme.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            side: BorderSide(
              color: context.colorScheme.outline.withOpacity(.3),
            ),
          ),
          builder: (context) {
            return const NowPlayingView();
          },
        );
      },
      icon: const Icon(
        FluentIcons.reading_list_24_regular,
      ),
    );
  }
}

/// The height of one queue row. Rows have a fixed height so the offset of any
/// row is known without measuring it.
const _queueRowExtent = 80.0;

/// The scroll offset that puts the row at [position] in the middle of a
/// viewport of height [viewport], kept inside `0..maxScrollExtent`.
@visibleForTesting
double queueScrollOffset({
  required int position,
  required double rowExtent,
  required double viewport,
  required double maxScrollExtent,
}) {
  final centered = position * rowExtent - (viewport - rowExtent) / 2;
  return math.max(0.0, math.min(centered, maxScrollExtent));
}

/// The player's queue in playback order, with the song that is playing
/// highlighted, the songs already played dimmed, and the list kept scrolled to
/// the current song.
class NowPlayingView extends HookConsumerWidget {
  const NowPlayingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEntries = ref.watch(queueEntriesProvider);
    final currentIndex = ref.watch(playerCurrentIndexProvider).valueOrNull;
    final scrollController = useScrollController();
    final hasScrolledToCurrent = useRef(false);

    final entries = asyncEntries.valueOrNull ?? const <QueueEntry>[];
    final currentPosition = currentIndex == null
        ? -1
        : entries.indexWhere((entry) => entry.index == currentIndex);

    useEffect(() {
      if (currentPosition < 0) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;

        final position = scrollController.position;
        final offset = queueScrollOffset(
          position: currentPosition,
          rowExtent: _queueRowExtent,
          viewport: position.viewportDimension,
          maxScrollExtent: position.maxScrollExtent,
        );

        // Open already scrolled to the current song, then glide when it changes.
        if (hasScrolledToCurrent.value) {
          scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          scrollController.jumpTo(offset);
          hasScrolledToCurrent.value = true;
        }
      });
      return null;
    }, [currentPosition, entries.length]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Now Playing",
                style: context.textTheme.headlineSmall,
              ),
              const Spacer(),
              if (currentPosition >= 0)
                Text(
                  "${currentPosition + 1} of ${entries.length}",
                  style: context.textTheme.labelMedium,
                ),
            ],
          ),
          const Divider(
            height: 1.2,
          ),
          Expanded(
            child: asyncEntries.when(
              skipLoadingOnReload: true,
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(child: Text("The queue is empty"));
                }

                return ListView.builder(
                  controller: scrollController,
                  itemExtent: _queueRowExtent,
                  itemCount: entries.length,
                  itemBuilder: (context, position) {
                    final entry = entries[position];
                    final isCurrent = position == currentPosition;
                    final alreadyPlayed =
                        currentPosition >= 0 && position < currentPosition;

                    return Opacity(
                      opacity: alreadyPlayed ? .5 : 1.0,
                      child: SongListTile(
                        key: ValueKey(entry.index),
                        song: entry.song,
                        color: isCurrent
                            ? context.colorScheme.primaryContainer
                            : Colors.transparent,
                        onTap: (_) async {
                          await ref
                              .read(playbackControllerProvider.notifier)
                              .playQueueItem(entry.index);
                        },
                        trailing: IconButton(
                          onPressed: () async {
                            await ref
                                .read(playbackControllerProvider.notifier)
                                .removeFromQueue(entry.index);
                          },
                          icon: const Icon(
                            FluentIcons.dismiss_circle_24_filled,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return AsyncErrorView(
                  error: error,
                  stackTrace: stackTrace,
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    strokeCap: StrokeCap.round,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
