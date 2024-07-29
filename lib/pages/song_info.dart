import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mpeg_codec/mpeg_codec.dart' hide formatDuration;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes/components/dialog_form.dart';
import 'package:tunes/components/song_artwork.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';

class SongInfo extends HookConsumerWidget {
  final SongModel song;
  const SongInfo({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen(metadataControllerProvider(song), (previous, next) {
    //   final nextValue = next.valueOrNull;

    //   if (next.hasError) {
    //     context.showErrorSnackBar(
    //       message: "Error updating metadata.",
    //     );
    //   }
    //   if (nextValue == null) {
    //     return;
    //   }

    //   if (nextValue) {
    //     context.showSnackBar(
    //       message: "Metadata Updated.",
    //     );
    //   } else {
    //     context.showErrorSnackBar(
    //       message: "Error updating metadata.",
    //     );
    //   }
    // });

    final supported = ['mp3', 'm4a'].contains(song.fileExtension);

    final fields = [
      (
        title: 'Title',
        name: 'title',
        value: song.title,
        editable: true && supported,
      ),
      (
        title: 'Artist',
        name: 'artist',
        value: song.artist,
        editable: true && supported,
      ),
      (
        title: 'Album',
        name: 'album',
        value: song.album,
        editable: true && supported,
      ),
      if (song.genre != null)
        (
          title: 'Genre',
          name: 'genre',
          value: song.genre,
          editable: false,
        ),
      if (song.track != null)
        (
          title: 'Track',
          name: 'track',
          value: song.track,
          editable: false,
        ),
      if (song.duration != null)
        (
          title: 'Duration',
          name: 'duration',
          value: formatDuration(Duration(milliseconds: song.duration ?? 0)),
          editable: false,
        ),
      (
        title: 'File Size',
        name: 'size',
        value: formatFileSize(song.size.toString()),
        editable: false,
      ),
      (
        title: 'File Path',
        name: 'path',
        value: song.data,
        editable: false,
      ),
      ...mp4Fields
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: SongArtwork(
                id: song.id,
                type: ArtworkType.AUDIO,
                width: context.shortestSide,
                height: 300,
                size: 300,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final item = fields.elementAt(index);
                return SongInfoTile(
                  song: song,
                  title: item.title,
                  name: item.name,
                  value: item.value?.toString() ?? "Unknown",
                  editable: item.editable,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<({bool editable, String name, String title, Object? value})>
      get mp4Fields {
    if (song.fileExtension != 'm4a') {
      return [];
    }

    try {
      final handler = MP4Handler(song.data);
      final metadata = handler.metadata;
      handler.close();
      return metadata
          .asMap()
          .entries
          .where((e) => e.key != 'cover')
          .map((entry) {
        return (
          title: camelToSentence(entry.key),
          name: entry.key,
          value: entry.value,
          editable: false,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

class SongInfoTile extends HookConsumerWidget {
  const SongInfoTile({
    super.key,
    required this.song,
    required this.title,
    required this.name,
    required this.value,
    this.editable = false,
  });

  final SongModel song;
  final String title;
  final String name;
  final String value;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMetaController = ref.watch(metadataControllerProvider(song));
    final focusNode = useFocusNode();

    return ListTile(
      onTap: editable
          ? () async {
              FocusScope.of(context).requestFocus(focusNode);
              final values = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) {
                  return DialogForm(
                    children: [
                      Text(
                        title,
                        style: (() {
                          final textTheme = context.textTheme.titleMedium;

                          if (textTheme == null) {
                            return textTheme;
                          }

                          return textTheme.copyWith(
                            color: textTheme.color?.withOpacity(.5),
                          );
                        })(),
                      ),
                      const Divider(),
                      (() {
                        switch (name) {
                          case 'album':
                            return FormBuilderTypeAhead(
                              name: name,
                              initialValue: value,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: false,
                                enabledBorder: InputBorder.none,
                              ),
                              itemBuilder: (context, country) {
                                return ListTile(title: Text(country));
                              },
                              suggestionsCallback: (query) async {
                                final allSongs = await ref
                                    .read(songsControllerProvider().future);
                                final allItems = allSongs
                                    .map((e) => e.album ?? "Unknown")
                                    .toSet()
                                    .toList();
                                if (query.isNotEmpty) {
                                  var lowercaseQuery = query.toLowerCase();

                                  return allItems.where((item) {
                                    return item
                                        .toLowerCase()
                                        .contains(lowercaseQuery);
                                  }).toList(growable: false)
                                    ..sort((a, b) => a
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)));
                                } else {
                                  return allItems;
                                }
                              },
                            );
                          case 'artist':
                            return FormBuilderTypeAhead(
                              name: name,
                              initialValue: value,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: false,
                                enabledBorder: InputBorder.none,
                              ),
                              itemBuilder: (context, country) {
                                return ListTile(title: Text(country));
                              },
                              suggestionsCallback: (query) async {
                                final allSongs = await ref
                                    .read(songsControllerProvider().future);
                                final allItems = allSongs
                                    .map((e) => e.artist ?? "Unknown")
                                    .toSet()
                                    .toList();
                                if (query.isNotEmpty) {
                                  var lowercaseQuery = query.toLowerCase();

                                  return allItems.where((item) {
                                    return item
                                        .toLowerCase()
                                        .contains(lowercaseQuery);
                                  }).toList(growable: false)
                                    ..sort((a, b) => a
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)));
                                } else {
                                  return allItems;
                                }
                              },
                            );
                          default:
                            return FormBuilderTextField(
                              name: name,
                              initialValue: value,
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: false,
                                enabledBorder: InputBorder.none,
                              ),
                              validator: FormBuilderValidators.compose(
                                [],
                              ),
                            );
                        }
                      })(),
                      const SizedBox(height: 12.0),
                    ],
                  );
                },
              );

              if (values == null) {
                return;
              }

              bool result;

              if (song.fileExtension == 'm4a') {
                result = await ref
                    .read(metadataControllerProvider(song).notifier)
                    .encodeMp4(values);
              } else {
                result = await ref
                    .read(metadataControllerProvider(song).notifier)
                    .encodeSongMetadata(values);
              }

              if (result) {
                if (context.mounted) {
                  context.showSnackBar(
                    message: 'Song ${song.title} has been updated',
                  );
                }
                return;
              }

              if (context.mounted) {
                context.showErrorSnackBar(
                  message: 'Failed to update ${song.title}.',
                );
              }
            }
          : null,
      title: Text(
        title,
        style: (() {
          final textTheme = context.textTheme.labelSmall;
          if (textTheme == null) {
            return textTheme;
          }
          return textTheme.copyWith(
            color: textTheme.color?.withOpacity(.5),
          );
        })(),
      ),
      subtitle: Text(value),
      trailing: asyncMetaController.when(
        data: (data) {
          return editable
              ? Icon(
                  FluentIcons.chevron_right_24_filled,
                  color: context.iconTheme.color?.withOpacity(.5),
                  size: context.textTheme.bodyMedium?.fontSize,
                )
              : null;
        },
        error: (error, stackTrace) {
          return null;
        },
        loading: () {
          return const CircularProgressIndicator(
            strokeWidth: 2.0,
          );
        },
      ),
    );
  }
}
