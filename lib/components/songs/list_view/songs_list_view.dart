import 'package:drift/drift.dart' hide Column;
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tunes/hooks/hooks.dart';
import 'package:tunes/models/sortcriteria.dart';
import 'package:tunes/models/tunesong.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

import 'song_tile.dart';

class SongsListView extends HookConsumerWidget {
  const SongsListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = usePagingController<int, TuneSong>(
      firstPageKey: 0,
    );

    final sortCriteria = useState(
      SortCriteria(
        mode: OrderingMode.desc,
        key: 'modified',
      ),
    );

    final fetchPage = useCallback(
      (int pageKey) async {
        const pageCount = 20;
        try {
          final newItems = await ref
              .read(
                pagedTuneSongsProvider.notifier,
              )
              .fetchSongs(
                sortCriteria: sortCriteria.value,
                offset: pageKey,
                limit: pageCount,
              );
          final isLastPage = newItems.length < pageCount;

          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + newItems.length;
            pagingController.appendPage(newItems, nextPageKey);
          }
        } catch (error) {
          pagingController.error = error;
        }
      },
      [pagingController, sortCriteria],
    );

    useEffect(
      () {
        void pageChanged(pageKey) {
          fetchPage(pageKey);
        }

        pagingController.addPageRequestListener(pageChanged);

        return () => pagingController.removePageRequestListener(pageChanged);
      },
      [pagingController],
    );

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: PagedListView<int, TuneSong>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return SongTile(
                  tuneSong: item,
                );
              },
            ),
          ),
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: (() {
                  final solidBgFillAlt = FluentTheme.of(context)
                      .resources
                      .solidBackgroundFillColorBaseAlt;

                  return [
                    solidBgFillAlt,
                    solidBgFillAlt.withOpacity(.8),
                    solidBgFillAlt.withOpacity(.1),
                  ];
                }).call(),
              ),
            ),
            child: ListTile(
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 14),
                    child: Icon(
                      FluentIcons.play_circle_24_filled,
                      size: 24.0,
                    ),
                  ),
                  Text("Play All")
                ],
              ),
              trailing: IconButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return ContentDialog(
                        constraints: BoxConstraints(
                          minWidth: context.shortestSide * .6,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sort",
                              style: context.textTheme.headlineSmall,
                            ),
                            ComboBox<OrderingMode>(
                              value: OrderingMode.desc,
                              onChanged: (value) {
                                if (value != null) {
                                  sortCriteria.value =
                                      sortCriteria.value.copyWith(
                                    mode: value,
                                  );
                                }
                              },
                              items: [
                                {
                                  'label': 'Ascending',
                                  'value': OrderingMode.asc,
                                },
                                {
                                  'label': 'Descending',
                                  'value': OrderingMode.desc,
                                }
                              ]
                                  .map(
                                    (e) => ComboBoxItem(
                                      value: e['value'] as OrderingMode,
                                      child: Text(
                                        e['label'].toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            'title',
                            'artist',
                            'album',
                            'modified',
                            'play_count',
                            'liked',
                          ]
                              .map(
                                (e) {
                                  return ListTile.selectable(
                                  title: Text(e.split('_').join(' ').camelCase),
                                  selected: sortCriteria.value.key == e,
                                  selectionMode: ListTileSelectionMode.single,
                                  onSelectionChange: (value) {
                                    if (value) {
                                      sortCriteria.value =
                                          sortCriteria.value.copyWith(key: e);
                                    }
                                  },
                                  onPressed: () {
                                    sortCriteria.value =
                                          sortCriteria.value.copyWith(key: e);
                                  },
                                );
                                },
                              )
                              .toList(),
                        ),
                        actions: [
                          Button(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).maybePop();
                            },
                          ),
                          FilledButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              pagingController.refresh();
                              Navigator.of(context).maybePop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  FluentIcons.arrow_sort_down_lines_24_regular,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
