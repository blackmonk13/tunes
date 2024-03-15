import 'package:beamer/beamer.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' as material;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/utils/extensions.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      content: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SizedBox.square(
              dimension: context.shortestSide * .5,
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
