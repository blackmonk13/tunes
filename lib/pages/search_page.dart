import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/views/tabbed_view.dart';

class SearchPage extends SearchDelegate<String> {
  SearchPage()
      : super(
          searchFieldLabel: "Search",
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0,
        ),
        filled: true,
        fillColor: context.colorScheme.outlineVariant,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0)),
        isDense: true,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final searchHistory = ref.watch(searchHistoryProvider);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search History",
                    style: context.textTheme.labelLarge,
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref.read(searchHistoryProvider.notifier).clear();
                    },
                    icon: const Icon(
                      FluentIcons.delete_24_regular,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: searchHistory.map((item) {
                      return ActionChip(
                        label: Text(item),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          query = item;
                          showResults(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        useEffect(() {
          if (query.isNotEmpty) {
            ref.read(searchHistoryProvider.notifier).add(query);
          }

          return null;
        }, [query]);

        return TabbedView(
          searchQuery: query,
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: const Icon(FluentIcons.dismiss_circle_24_filled),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }
}
