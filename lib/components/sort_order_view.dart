import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

class SortOrderView extends ConsumerWidget {
  final SongQueryType queryType;
  const SortOrderView({
    super.key,
    required this.queryType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsSortOrder = ref.watch(
      songsSortOrderProvider(queryType),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
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
                value: songsSortOrder.orderType,
                onChanged: (newValue) {
                  ref
                      .read(
                        songsSortOrderProvider(
                          queryType,
                        ).notifier,
                      )
                      .sort(
                        orderType: newValue,
                      );
                },
                items: Sort.values.map(
                  (orderType) {
                    return DropdownMenuItem<Sort>(
                      value: orderType,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            (() {
                              switch (orderType) {
                                case Sort.asc:
                                  return FluentIcons
                                      .text_sort_ascending_24_regular;
                                case Sort.desc:
                                  return FluentIcons
                                      .text_sort_descending_24_regular;

                                default:
                                  return FluentIcons
                                      .text_sort_descending_24_regular;
                              }
                            })(),
                            size: 16.0,
                          ),
                          const VerticalDivider(
                            color: Colors.transparent,
                          ),
                          Text(
                            orderType
                                .toString()
                                .split('.')
                                .last
                                .split('_')
                                .first
                                .toLowerCase()
                                .toCamelCase,
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        ...SongsSortType.values
            .where((e) => ![
                  SongsSortType.artist,
                  SongsSortType.album,
                  SongsSortType.genre,
                ].contains(e))
            .map(
          (sortType) {
            return RadioListTile<SongsSortType>(
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text(
                switch (sortType) {
                  SongsSortType.recentlyPlayed => 'Recently played',
                  SongsSortType.playCount => 'Play count',
                  _ => sortType.name.toCamelCase,
                },
              ),
              value: sortType,
              groupValue: songsSortOrder.sortType,
              onChanged: (value) {
                ref
                    .read(
                      songsSortOrderProvider(
                        queryType,
                      ).notifier,
                    )
                    .sort(
                      sortType: value,
                    );
                Navigator.of(context).maybePop(); // Close the bottom sheet
              },
            );
          },
        ),
      ],
    );
  }
}
