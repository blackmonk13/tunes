import 'package:beamer/beamer.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/providers/providers.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncScanControl = ref.watch(scanControllerProvider);
    
    return ScaffoldPage(
      padding: EdgeInsets.only(
        top: context.statusBarHeight,
      ),
      header: PageHeader(
        title: const Text('Scan'),
        leading: IconButton(
          icon: const Icon(
            FluentIcons.arrow_left_24_filled,
            size: 24.0,
          ),
          onPressed: () {
            context.beamToReplacementNamed('/');
          },
        ),
      ),
      content: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: SizedBox.square(
                  dimension: context.shortestSide * .3,
                  child: Acrylic(
                    luminosityAlpha: .3,
                    tint: FluentTheme.of(context).accentColor,
                    blurAmount: 10,
                    elevation: 30.0,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
          asyncScanControl.when(
            data: (data) {
              return const Text('Scan Complete');
            },
            error: (error, stackTrace) {
              return const Text('Error');
            },
            loading: () {
              return const ProgressRing();
            },
          ),
        ],
      ),
    );
  }
}

class ScanOptions extends HookConsumerWidget {
  const ScanOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class MusicManagement extends HookConsumerWidget {
  const MusicManagement({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class MediaFolders extends HookConsumerWidget {
  const MediaFolders({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
