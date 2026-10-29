import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/components/common/error_view.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/media_query.dart';

/// The covers embedded in a song's file, as a carousel to swipe through, with
/// buttons to add a cover from the device and to remove the one on show.
class CoverCarousel extends HookConsumerWidget {
  const CoverCarousel({
    super.key,
    required this.song,
    this.height = 320,
  });

  final Song song;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCovers = ref.watch(songCoversProvider(song.filePath));
    final controller = usePageController(viewportFraction: .8);
    final page = useState(0);
    final busy = useState(false);

    Future<void> run(Future<void> Function() action, String failure) async {
      busy.value = true;
      try {
        await action();
      } catch (_) {
        if (context.mounted) context.showErrorSnackBar(message: failure);
      } finally {
        busy.value = false;
      }
    }

    Future<void> addCover() async {
      final file = await FilePicker.pickFile(type: FileType.image);
      if (file == null) return;

      await run(() async {
        final bytes = await file.readAsBytes();
        await ref
            .read(coversControllerProvider.notifier)
            .add(song.filePath, bytes);
        if (context.mounted) context.showSnackBar(message: 'Cover added');
      }, 'Could not add the cover');
    }

    Future<void> removeCover(int index) async {
      await run(() async {
        await ref
            .read(coversControllerProvider.notifier)
            .remove(song.filePath, index);
        if (context.mounted) context.showSnackBar(message: 'Cover removed');
      }, 'Could not remove the cover');
    }

    return asyncCovers.when(
      skipLoadingOnReload: true,
      data: (covers) {
        // Removing the last page leaves the stored page index past the end.
        final current =
            covers.isEmpty ? 0 : page.value.clamp(0, covers.length - 1);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height,
              child: covers.isEmpty
                  ? Center(
                      child: Text(
                        'No cover',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    )
                  : PageView.builder(
                      controller: controller,
                      itemCount: covers.length,
                      onPageChanged: (index) => page.value = index,
                      itemBuilder: (context, index) {
                        final cover = covers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.memory(
                              cover.bytes,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    FluentIcons.image_off_24_regular,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (covers.isNotEmpty)
              Text(
                '${covers[current].label}  ·  ${current + 1} of ${covers.length}',
                style: context.textTheme.labelMedium,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: busy.value ? null : addCover,
                    icon: const Icon(FluentIcons.add_20_regular),
                    label: const Text('Add cover'),
                  ),
                  if (covers.isNotEmpty) ...[
                    const SizedBox(width: 12.0),
                    OutlinedButton.icon(
                      onPressed: busy.value ? null : () => removeCover(current),
                      icon: const Icon(FluentIcons.delete_20_regular),
                      label: const Text('Remove'),
                    ),
                  ],
                ],
              ),
            ),
            if (busy.value) const LinearProgressIndicator(),
          ],
        );
      },
      error: (error, stackTrace) {
        return SizedBox(
          height: height,
          child: AsyncErrorView(error: error, stackTrace: stackTrace),
        );
      },
      loading: () {
        return SizedBox(
          height: height,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      },
    );
  }
}
