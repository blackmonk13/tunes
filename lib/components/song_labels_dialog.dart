import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/components/dialog_title.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

class SongLabelsDialog extends HookConsumerWidget {
  const SongLabelsDialog({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLabels = ref.watch(labelsProvider);
    final asyncCurrent = ref.watch(songLabelIdsProvider(song.id));
    // null until the user changes something, so the song's saved labels show.
    final edited = useState<Set<int>?>(null);
    final nameController = useTextEditingController();

    final selected = edited.value ?? asyncCurrent.valueOrNull ?? <int>{};

    Future<void> addLabel() async {
      final label = await ref
          .read(labelsControllerProvider.notifier)
          .create(nameController.text);
      if (label == null) return;

      nameController.clear();
      edited.value = {...selected, label.id};
    }

    Future<void> deleteLabel(Label label) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete "${label.name}"?'),
            content: const Text(
              'The label is removed from every song it is attached to.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;

      await ref.read(labelsControllerProvider.notifier).delete(label.id);
      edited.value = {...selected}..remove(label.id);
    }

    Future<void> save() async {
      await ref
          .read(labelsControllerProvider.notifier)
          .setSongLabels(song, selected);
      if (context.mounted) Navigator.of(context).maybePop();
    }

    return Dialog(
      backgroundColor: context.colorScheme.outlineVariant,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        side: BorderSide(
          color: context.colorScheme.outline.withOpacity(.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogTitle(title: "Labels"),
            const Divider(),
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => addLabel(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 24.0,
                ),
                filled: true,
                fillColor: context.colorScheme.outline.withOpacity(.5),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                hintText: "New label",
                suffixIcon: IconButton(
                  onPressed: addLabel,
                  icon: const Icon(FluentIcons.add_20_regular),
                ),
              ),
            ),
            const Divider(),
            asyncLabels.when(
              data: (labels) {
                if (labels.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No labels yet"),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: context.screenHeight * .4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: labels.length,
                    itemBuilder: (context, index) {
                      final label = labels[index];

                      return CheckboxListTile(
                        title: Text(
                          label.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        secondary: IconButton(
                          onPressed: () => deleteLabel(label),
                          icon: const Icon(FluentIcons.delete_20_regular),
                        ),
                        value: selected.contains(label.id),
                        onChanged: (checked) {
                          final next = {...selected};
                          if (checked == true) {
                            next.add(label.id);
                          } else {
                            next.remove(label.id);
                          }
                          edited.value = next;
                        },
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return AsyncErrorView(
                  error: error,
                  stackTrace: stackTrace,
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            const Divider(),
            MaterialButton(
              color: context.colorScheme.primary,
              textColor: context.colorScheme.onPrimary,
              minWidth: context.screenWidth,
              onPressed: save,
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
