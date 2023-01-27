import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/context_utils.dart';
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
  final Audio tune;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongInfoState();
}

class _SongInfoState extends ConsumerState<SongInfo> {
  Audio get tune => widget.tune;
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
              initialValue: tune.metas.title ?? tune.path,
              fieldName: 'title',
              onSave: (value) {},
              tune: tune,
            ),
            TagTextField(
              initialValue: tune.metas.artist ?? "Unknown",
              fieldName: 'artist',
              onSave: (value) {},
              tune: tune,
            ),
            TagTextField(
              initialValue: tune.metas.album ?? "Unknown",
              fieldName: 'album',
              onSave: (value) {},
              tune: tune,
            ),
            Text(
              'Path: ${tune.path}',
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class TagTextField extends HookConsumerWidget {
  const TagTextField({
    super.key,
    required this.tune,
    required this.fieldName,
    this.initialValue = "Unknown",
    required this.onSave,
  });
  final Audio tune;
  final String fieldName;
  final String? initialValue;
  final ValueChanged<bool?> onSave;

  String get _initialValue {
    final inVal = initialValue;
    if (inVal == null) {
      return "Unknown";
    }
    if (inVal.isEmpty) {
      return "Unknown";
    }
    return inVal;
  }

  // @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editSongInfo = ref.watch(editSongInfoProvider);
    final controller = useTextEditingController(text: _initialValue);
    final textFieldFocusNode = useFocusNode();
    final isFocused = useIsFocused(textFieldFocusNode);

    useEffect(() {
      if (isFocused) return;
      if (controller.text == _initialValue) {
        return;
      }
      Future<void> saveData() async {
        final result = await tagger.writeTag(
          path: tune.path,
          tagField: fieldName.toLowerCase().trim(),
          value: controller.text,
        );
        if (result != null) {
          if (result) {
            await ref.read(tunesRepositoryProvider).updateTune(tune.path);
            // ref.invalidate(songsProvider);
          }
        }
        onSave(result);
      }

      Future.microtask(saveData);
      return null;
    }, [isFocused]);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: editSongInfo,
        focusNode: textFieldFocusNode,
        // textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: false,
          labelText: fieldName.capitalize(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(
    () {
      void listener() {
        isFocused.value = node.hasFocus;
      }

      node.addListener(listener);
      return () => node.removeListener(listener);
    },
    [node],
  );

  return isFocused.value;
}
