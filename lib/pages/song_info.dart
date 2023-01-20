import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tunes/models/tune.dart';
import 'package:tunes/providers/main.dart';
import 'package:tunes/utils/constants.dart';
import 'package:tunes/utils/extensions.dart';

final editSongInfoProvider = StateProvider.autoDispose<bool>(
  (ref) {
    return false;
  },
);

class SongInfo extends ConsumerStatefulWidget {
  const SongInfo({
    super.key,
    required this.tune,
  });
  final Tune tune;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongInfoState();
}

class _SongInfoState extends ConsumerState<SongInfo> {
  Tune get tune => widget.tune;
  @override
  Widget build(BuildContext context) {
    final editSongInfo = ref.watch(editSongInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song info"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(editSongInfoProvider.notifier).state = !editSongInfo;
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            TagTextField(
              initialValue: getTitle(tune),
              fieldName: 'title',
              onSave: (value) {},
              tune: tune,
            ),
            TagTextField(
              initialValue: tune.tag?.artist,
              fieldName: 'artist',
              onSave: (value) {},
              tune: tune,
            ),
            TagTextField(
              initialValue: getAlbum(tune),
              fieldName: 'album',
              onSave: (value) {},
              tune: tune,
            ),
          ],
        ),
      ),
    );
  }
}

class TagTextField extends ConsumerStatefulWidget {
  const TagTextField({
    super.key,
    required this.tune,
    required this.fieldName,
    this.initialValue = "Unknown",
    required this.onSave,
  });
  final Tune tune;
  final String fieldName;
  final String? initialValue;
  final ValueChanged<bool?> onSave;

  @override
  ConsumerState<TagTextField> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends ConsumerState<TagTextField> {
  late TextEditingController controller;

  String get _initialValue {
    final inVal = widget.initialValue;
    if (inVal == null) {
      return "Unknown";
    }
    if (inVal.isEmpty) {
      return "Unknown";
    }
    return inVal;
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: _initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final editSongInfo = ref.watch(editSongInfoProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: editSongInfo,
        onEditingComplete: () async {
          final result = await tagger.writeTag(
            path: widget.tune.filePath,
            tagField: widget.fieldName.toLowerCase().trim(),
            value: controller.text,
          );
          if (result != null) {
            if (result) {
              ref.invalidate(songsListProvider);
            }
          }
          widget.onSave(result);
        },
        decoration: InputDecoration(
          labelText: widget.fieldName.capitalize(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
    ;
  }
}
