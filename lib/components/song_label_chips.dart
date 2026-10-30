import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/auto_scroll_row.dart';
import 'package:tunes/components/song_labels_sheet.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/media_query.dart';

/// The labels on [song], which scroll by themselves when they do not fit, and
/// a button next to them to add or change labels. Tapping a label calls
/// [onOpenLabel].
class SongLabelChips extends ConsumerWidget {
  const SongLabelChips({
    super.key,
    required this.song,
    required this.onOpenLabel,
    this.fgColor,
  });

  final Song song;
  final void Function(Label label) onOpenLabel;
  final Color? fgColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(songLabelsProvider(song.id)).valueOrNull ?? [];
    final outline = BorderSide(color: (fgColor ?? Colors.grey).withOpacity(.4));
    final labelStyle = TextStyle(color: fgColor, fontSize: 12.0);

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: AutoScrollRow(
              restartKey: labels.map((label) => label.id).join(','),
              padding: const EdgeInsets.only(left: 16.0),
              children: [
                if (labels.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: Text(
                        'No labels',
                        style: labelStyle.copyWith(
                          color: fgColor?.withOpacity(.7),
                        ),
                      ),
                    ),
                  ),
                for (final label in labels)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(label.name),
                      labelStyle: labelStyle,
                      side: outline,
                      backgroundColor: Colors.transparent,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      onPressed: () => onOpenLabel(label),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              tooltip: 'Add or change labels',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 28.0,
                height: 28.0,
              ),
              style: IconButton.styleFrom(
                side: outline,
                shape: const CircleBorder(),
              ),
              icon: Icon(
                FluentIcons.add_16_filled,
                size: 16.0,
                color: fgColor,
              ),
              onPressed: () => showSongLabelsSheet(context, song),
            ),
          ),
        ],
      ),
    );
  }
}
