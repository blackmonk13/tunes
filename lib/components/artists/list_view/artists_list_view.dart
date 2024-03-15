import 'package:drift/drift.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:tunes/hooks/hooks.dart';
import 'package:tunes/models/sortcriteria.dart';
import 'package:tunes/models/tuneartist.dart';
import 'package:tunes/providers/providers.dart';

class ArtistsListView extends HookConsumerWidget {
  const ArtistsListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = usePagingController<int, TuneArtist>(
      firstPageKey: 0,
    );

    final sortCriteria = useState(
      SortCriteria(
        mode: OrderingMode.asc,
        key: 'name',
      ),
    );

    final fetchPage = useCallback(
      (int pageKey) async {
        const pageCount = 20;
        try {
          final newItems = await ref
              .read(
                pagedTuneArtistsProvider.notifier,
              )
              .fetchArtists(
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
      [pagingController],
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
          child: PagedListView<int, TuneArtist>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return ListTile(
                  title: Text(item.artist.name),
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
              trailing: IconButton(
                onPressed: () {
                  switch (sortCriteria.value.mode) {
                    case OrderingMode.asc:
                      sortCriteria.value = sortCriteria.value.copyWith(
                        mode: OrderingMode.desc,
                      );
                      break;
                    case OrderingMode.desc:
                      sortCriteria.value = sortCriteria.value.copyWith(
                        mode: OrderingMode.asc,
                      );
                      break;
                    default:
                  }
                  pagingController.refresh();
                },
                icon: Icon(
                  sortCriteria.value.mode == OrderingMode.desc
                      ? FluentIcons.text_sort_descending_24_regular
                      : FluentIcons.text_sort_ascending_24_regular,
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
