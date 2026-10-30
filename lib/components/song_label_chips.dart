import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/song_labels_sheet.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/media_query.dart';

/// A scrolling row with a chip for each label on [song], and a chip to edit
/// them. Tapping a label calls [onOpenLabel].
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          for (final label in labels)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                label: Text(label.name),
                labelStyle: labelStyle,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                side: outline,
                backgroundColor: Colors.transparent,
                onPressed: () => onOpenLabel(label),
              ),
            ),
          ActionChip(
            avatar: Icon(
              FluentIcons.tag_24_regular,
              size: 14.0,
              color: fgColor,
            ),
            label: Text(labels.isEmpty ? 'Add label' : 'Edit'),
            labelStyle: labelStyle,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            side: outline,
            backgroundColor: Colors.transparent,
            onPressed: () => showSongLabelsSheet(context, song),
          ),
        ],
      ),
    );
  }
}
