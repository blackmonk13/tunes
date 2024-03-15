import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/providers/providers.dart';

class RepeatBtn extends HookConsumerWidget {
  const RepeatBtn({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    return IconButton(
      icon: const Icon(
        FluentIcons.arrow_repeat_all_24_regular,
        size: 24.0,
      ),
      onPressed: () {
        player.shuffle();
      },
    );
  }
}
