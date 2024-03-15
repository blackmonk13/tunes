import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/providers/providers.dart';

class NextBtn extends HookConsumerWidget {
  const NextBtn({
    super.key,
    this.size = 24.0,
    this.alwaysShow = false,
  });
  final double size;
  final bool alwaysShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);

    if (!player.hasNext && !alwaysShow) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () async {
        await player.seekToNext();
      },
      icon: Icon(
        FluentIcons.next_24_filled,
        size: size,
      ),
    );
  }
}

class PreviousBtn extends HookConsumerWidget {
  const PreviousBtn({
    super.key,
    this.size = 24.0,
    this.alwaysShow = false,
  });
  final double size;
  final bool alwaysShow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);

    if (!player.hasPrevious && !alwaysShow) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () async {
        await player.seekToPrevious();
      },
      icon: Icon(
        FluentIcons.previous_24_filled,
        size: size,
      ),
    );
  }
}
