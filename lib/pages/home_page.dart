import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';

import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

import 'package:tunes/components/options_view.dart';

import 'package:tunes/views/tabbed_view.dart';
import 'search_page.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tunes"),
        actions: [
          const IndexingView(),
          // IconButton(
          //   onPressed: () {
          //     ref.invalidate(indexingControllerProvider);
          //   },
          //   icon: const Icon(FluentIcons.arrow_reset_24_regular),
          // ),
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SearchPage(),
              );
            },
            icon: const Icon(
              FluentIcons.search_24_filled,
            ),
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                // backgroundColor: Colors.transparent,
                constraints: BoxConstraints(
                  minWidth: context.shortestSide,
                  maxWidth: context.shortestSide,
                  minHeight: 300.0,
                  maxHeight: 300.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  side: BorderSide(
                    color: context.colorScheme.outline.withOpacity(.3),
                  ),
                ),
                builder: (context) {
                  return const OptionsView();
                },
              );
            },
            icon: const Icon(
              FluentIcons.options_24_regular,
            ),
          ),
        ],
      ),
      body: const TabbedView(),
    );
  }
}

class IndexingView extends ConsumerWidget {
  const IndexingView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncIndexing = ref.watch(indexingControllerProvider);

    return asyncIndexing.when(
      data: (data) {
        return const Icon(FluentIcons.checkmark_starburst_24_filled);
      },
      error: (error, stackTrace) {
        return IconButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              backgroundColor: context.colorScheme.outlineVariant,
              builder: (context) {
                return AsyncErrorView(
                  error: error,
                  stackTrace: stackTrace,
                );
              },
            );
          },
          icon: const Icon(FluentIcons.warning_24_filled),
        );
      },
      loading: () {
        return const IndexingProgressView();
      },
    );
  }
}

class IndexingProgressView extends ConsumerWidget {
  const IndexingProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProgress = ref.watch(indexingProgressProvider);
    return asyncProgress.when(
      data: (data) {
        return Text(data.toString());
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
