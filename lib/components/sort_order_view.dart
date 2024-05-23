import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class SortOrderView extends ConsumerWidget {
  final String viewKey;
  const SortOrderView({
    super.key,
    required this.viewKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsSortOrder = ref.watch(songsSortOrderProvider(viewKey));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sort Order",
                style: context.textTheme.headlineSmall,
              ),
              DropdownButton<OrderType>(
                icon: const Icon(
                  FluentIcons.caret_down_right_24_filled,
                ),
                elevation: 0,
                borderRadius: BorderRadius.circular(10.0),
                underline: Container(),
                value: songsSortOrder.orderType,
                onChanged: (newValue) {
                  ref
                      .read(
                        songsSortOrderProvider(
                          viewKey,
                        ).notifier,
                      )
                      .sort(
                        orderType: newValue,
                      );
                },
                items: OrderType.values.map((orderType) {
                  return DropdownMenuItem<OrderType>(
                    value: orderType,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon((() {
                          switch (orderType) {
                            case OrderType.ASC_OR_SMALLER:
                              return FluentIcons.text_sort_ascending_24_regular;
                            case OrderType.DESC_OR_GREATER:
                              return FluentIcons
                                  .text_sort_descending_24_regular;

                            default:
                              return FluentIcons
                                  .text_sort_descending_24_regular;
                          }
                        })()),
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
                }).toList(),
              ),
            ],
          ),
        ),
        ...SongSortType.values
            .where((e) => e != SongSortType.DISPLAY_NAME)
            .map((sortType) {
          return RadioListTile<SongSortType>(
            // dense: true,
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(
              sortType
                  .toString()
                  .split('.')
                  .last
                  .split('_')
                  .join(' ')
                  .toLowerCase()
                  .toCamelCase,
            ),
            value: sortType,
            groupValue: songsSortOrder.sortType,
            onChanged: (value) {
              ref
                  .read(
                    songsSortOrderProvider(
                      viewKey,
                    ).notifier,
                  )
                  .sort(
                    sortType: value,
                  );
              Navigator.of(context).maybePop(); // Close the bottom sheet
            },
          );
        }),
      ],
    );
  }
}
