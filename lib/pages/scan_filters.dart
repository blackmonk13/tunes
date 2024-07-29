import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tunes/models/filters/filters.dart';

import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class ScanFilters extends ConsumerWidget {
  const ScanFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterConfigs = ref.watch(songsFilterConfigsProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            title: Text("Filters"),
          ),
          const SliverAppBar(
            automaticallyImplyLeading: false,
            primary: false,
            pinned: true,
            title: Text("Path Filters"),
          ),
          SliverList.separated(
            itemCount: filterConfigs.filterPaths.length,
            itemBuilder: (context, index) {
              final filterPath = filterConfigs.filterPaths.elementAt(index);

              return Dismissible(
                key: ValueKey(filterPath),
                onDismissed: (direction) async{
                  // TODO: Dismiss Direction and Disable Direction
                  await ref
                      .read(songsFilterConfigsProvider.notifier)
                      .removePath(filterPath);
                },
                child: ListTile(
                  enabled: filterPath.enabled,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(basename(filterPath.path)),
                      if (!filterPath.include)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            'exclude',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(filterPath.path),
                  trailing: IconButton(
                    onPressed: () async {
                      await showFilterView(
                        context,
                        initialFilter: filterPath,
                      );
                    },
                    icon: const Icon(FluentIcons.edit_24_regular),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: context.colorScheme.onSurface,
        foregroundColor: context.colorScheme.surface,
        onPressed: () async {
          await showFilterView(context);
        },
        child: const Icon(FluentIcons.add_24_filled),
      ),
    );
  }

  Future<void> showFilterView(
    BuildContext context, {
    PathFilter? initialFilter,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        side: BorderSide(
          color: context.colorScheme.outline.withOpacity(.3),
        ),
      ),
      builder: (context) {
        return FilterView(
          initialFilter: initialFilter,
        );
      },
    );
  }
}

enum SongFilterType {
  filePath,
  fileSize,
  duration,
}

class FilterView extends HookConsumerWidget {
  final PathFilter? initialFilter;
  const FilterView({
    super.key,
    this.initialFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    return Container(
      width: context.shortestSide,
      height: 300.0 + context.viewInsets.bottom,
      padding: EdgeInsets.only(
        bottom: context.viewInsets.bottom,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: context.colorScheme.surface.withOpacity(0.5),
              ),
            ),
          ),
          Positioned.fill(
            child: FormBuilder(
              key: formKey,
              initialValue:
                  initialFilter?.toJson() ?? const <String, dynamic>{},
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    actions: [
                      IconButton(
                        onPressed: () async {
                          if (!context.mounted) {
                            return;
                          }
                          // Validate and save the form values
                          final validated =
                              formKey.currentState?.saveAndValidate();
                          if (validated != true) {
                            return;
                          }

                          final filterMap = formKey.currentState?.value;

                          if (filterMap == null) {
                            return;
                          }

                          final pathFilter = PathFilter.fromJson(filterMap);

                          final bool added;
                          if (initialFilter != null) {
                            added = await ref
                                .read(songsFilterConfigsProvider.notifier)
                                .updatePath(initialFilter!, pathFilter);
                          } else {
                            added = await ref
                                .read(songsFilterConfigsProvider.notifier)
                                .addPath(pathFilter);
                          }

                          if (added) {
                            Navigator.of(context).maybePop();
                            context.showSnackBar(
                              message:
                                  "Filter ${initialFilter == null ? "added" : "updated"} successfully",
                              icon: FluentIcons.checkmark_circle_24_filled,
                            );
                            return;
                          }

                          return context.showSnackBar(
                            message: "Filter already exists",
                          );
                        },
                        icon: const Icon(
                          FluentIcons.checkmark_24_filled,
                        ),
                      ),
                    ],
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(5),
                      child: Divider(),
                    ),
                  ),
                  SliverList.list(
                    children: [
                      FormBuilderTextField(
                        name: 'path',
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            (value) {
                              if (value == null) {
                                return "Must be a valid path";
                              }

                              if (!Directory(value).existsSync()) {
                                return "Path not found";
                              }

                              return null;
                            }
                          ],
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          label: const Text("Path"),
                          suffix: GestureDetector(
                            onTap: () async {
                              String? selectedDirectory =
                                  await FilePicker.platform.getDirectoryPath();

                              if (selectedDirectory == null) {
                                // User canceled the picker
                                return;
                              }

                              formKey.currentState?.fields['path']
                                  ?.didChange(selectedDirectory);
                            },
                            child: const Icon(
                              FluentIcons.folder_open_24_filled,
                            ),
                          ),
                        ),
                      ),
                      FormBuilderSwitch(
                        name: 'include',
                        title: const Text("Include"),
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                      FormBuilderSwitch(
                        name: 'enabled',
                        title: const Text("Enable"),
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
