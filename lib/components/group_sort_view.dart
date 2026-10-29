import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart' show Sort;
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/group_sort.dart';

/// The count of items in an artists, albums or genres list, with a button that
/// opens its sort sheet.
class GroupSortHeader extends ConsumerWidget {
  const GroupSortHeader({
    super.key,
    required this.kind,
    required this.count,
  });

  final GroupKind kind;
  final int? count;

  String get _noun {
    final singular = switch (kind) {
      GroupKind.artists => 'artist',
      GroupKind.albums => 'album',
      GroupKind.genres => 'genre',
    };
    return count == 1 ? singular : '${singular}s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(groupSortOrderProvider(kind));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${count ?? 0} $_noun",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: (() {
              final textTheme = context.textTheme.labelSmall;
              return textTheme?.copyWith(
                color: textTheme.color?.withOpacity(.7),
              );
            })(),
          ),
          TextButton.icon(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                backgroundColor: context.colorScheme.outlineVariant,
                showDragHandle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                ),
                builder: (context) => GroupSortView(kind: kind),
              );
            },
            icon: Icon(
              sort.orderType == Sort.asc
                  ? FluentIcons.text_sort_ascending_24_regular
                  : FluentIcons.text_sort_descending_24_regular,
              size: 18.0,
              color: context.iconTheme.color,
            ),
            label: Text(
              "Sort",
              style: context.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// The sort sheet for the artists, albums or genres list.
class GroupSortView extends ConsumerWidget {
  const GroupSortView({
    super.key,
    required this.kind,
  });

  final GroupKind kind;

  /// Only albums have an artist to sort by.
  List<GroupSortType> get _sortTypes => [
        GroupSortType.name,
        if (kind == GroupKind.albums) GroupSortType.artist,
        GroupSortType.songCount,
      ];

  String _label(GroupSortType sortType) {
    switch (sortType) {
      case GroupSortType.name:
        return kind == GroupKind.albums ? 'Title' : 'Name';
      case GroupSortType.artist:
        return 'Artist';
      case GroupSortType.songCount:
        return 'Number of songs';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(groupSortOrderProvider(kind));
    final notifier = ref.read(groupSortOrderProvider(kind).notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sort",
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<Sort>(
                icon: const Icon(
                  FluentIcons.caret_down_right_24_filled,
                  size: 16.0,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(10.0),
                underline: Container(),
                value: sort.orderType,
                onChanged: (newValue) => notifier.sort(orderType: newValue),
                items: [
                  for (final order in Sort.values)
                    DropdownMenuItem<Sort>(
                      value: order,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            order == Sort.asc
                                ? FluentIcons.text_sort_ascending_24_regular
                                : FluentIcons.text_sort_descending_24_regular,
                            size: 16.0,
                          ),
                          const VerticalDivider(color: Colors.transparent),
                          Text(order == Sort.asc ? 'Ascending' : 'Descending'),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        for (final sortType in _sortTypes)
          RadioListTile<GroupSortType>(
            dense: true,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(_label(sortType)),
            value: sortType,
            groupValue: sort.sortType,
            onChanged: (value) {
              notifier.sort(sortType: value);
              Navigator.of(context).maybePop(); // Close the bottom sheet
            },
          ),
      ],
    );
  }
}
