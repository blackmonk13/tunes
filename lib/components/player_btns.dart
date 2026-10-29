import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tunes/providers/providers.dart';
import 'package:tunes/utils/extensions.dart';

class PlayPauseBtn extends HookConsumerWidget {
  const PlayPauseBtn({
    super.key,
    this.size = 42.0,
    this.playIcon = FluentIcons.play_circle_28_filled,
    this.pauseIcon = FluentIcons.pause_circle_24_filled,
    this.loadingWidget = const CircularProgressIndicator(
      strokeWidth: 2.0,
    ),
    this.color,
  });
  final double size;
  final IconData playIcon;
  final IconData pauseIcon;
  final Widget loadingWidget;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);
    final asyncPlayerState = ref.watch(playerStateProvider);

    return asyncPlayerState.when(
      data: (state) {
        IconData iconData;
        VoidCallback? onPressed;

        switch (state.processingState) {
          case ProcessingState.idle:
            if (player.currentIndex == null) {
              iconData = playIcon;
              onPressed = null;
            } else {
              iconData = playIcon;
              onPressed = () {
                player.seek(
                  Duration.zero,
                  index: 0,
                );
                player.play();
              };
            }
            break;
          case ProcessingState.loading:
          case ProcessingState.buffering:
            iconData = playIcon;
            onPressed = null;
            break;
          case ProcessingState.ready:
            iconData = state.playing ? pauseIcon : playIcon;
            onPressed = () => state.playing ? player.pause() : player.play();
            break;
          case ProcessingState.completed:
            iconData = playIcon;
            onPressed = () {
              player.seek(
                Duration.zero,
                index: 0,
              );
              player.play();
            };
            break;
          default:
            iconData = playIcon;
            onPressed = null;
        }

        return IconButton(
          color: color,
          disabledColor: context.colorScheme.outline.withOpacity(.5),
          icon: Icon(
            iconData,
            size: size,
          ),
          onPressed: onPressed,
        );
      },
      error: (error, stackTrace) {
        return disabledBtn(context);
      },
      loading: () {
        return disabledBtn(context);
      },
    );
  }

  IconButton disabledBtn(BuildContext context) {
    return IconButton(
      onPressed: null,
      color: color,
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      icon: Icon(
        playIcon,
        size: size,
      ),
    );
  }
}

class NextBtn extends HookConsumerWidget {
  const NextBtn({
    super.key,
    this.size = 24.0,
    this.alwaysShow = false,
    this.color,
    this.builder,
  });
  final double size;
  final bool alwaysShow;
  final Color? color;
  final Widget Function(Widget icon, VoidCallback? onTap)? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);

    if (!alwaysShow) {
      return const SizedBox.shrink();
    }

    final icon = Icon(
      FluentIcons.next_24_filled,
      size: size,
    );

    final onPressed = player.hasNext
        ? () async {
            await player.seekToNext();
          }
        : null;

    if (builder != null) {
      return builder!(icon, onPressed);
    }

    return IconButton(
      color: color,
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class PreviousBtn extends HookConsumerWidget {
  const PreviousBtn({
    super.key,
    this.size = 24.0,
    this.alwaysShow = false,
    this.color,
    this.builder,
  });
  final double size;
  final bool alwaysShow;
  final Color? color;
  final Widget Function(Widget icon, VoidCallback? onTap)? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerPositionProvider);
    final player = ref.watch(audioPlayerProvider);

    if (!alwaysShow) {
      return const SizedBox.shrink();
    }
    final icon = Icon(
      FluentIcons.previous_24_filled,
      size: size,
    );

    final onPressed = player.hasPrevious
        ? () async {
            await player.seekToPrevious();
          }
        : null;

    if (builder != null) {
      return builder!(icon, onPressed);
    }

    return IconButton(
      color: color,
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class RepeatBtn extends ConsumerWidget {
  final double size;
  final bool filled;
  final Color? color;
  final Widget Function(Widget icon, VoidCallback onTap)? builder;
  const RepeatBtn({
    super.key,
    this.size = 24.0,
    this.filled = false,
    this.color,
    this.builder,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncLoopMode = ref.watch(playerLoopModeProvider);

    return asyncLoopMode.when(
      data: (data) {
        final icon = Icon(
          (() {
            switch (data) {
              case LoopMode.all:
                return filled
                    ? FluentIcons.arrow_repeat_all_24_filled
                    : FluentIcons.arrow_repeat_all_24_regular;
              case LoopMode.one:
                return filled
                    ? FluentIcons.arrow_repeat_1_24_filled
                    : FluentIcons.arrow_repeat_1_24_regular;
              case LoopMode.off:
                return filled
                    ? FluentIcons.arrow_repeat_all_off_24_filled
                    : FluentIcons.arrow_repeat_all_off_24_regular;
              default:
            }
          })(),
          size: size,
        );

        onPressed() {
          switch (data) {
            case LoopMode.all:
              player.setLoopMode(LoopMode.off);
              break;
            case LoopMode.off:
              player.setLoopMode(LoopMode.one);
              break;
            case LoopMode.one:
              player.setLoopMode(LoopMode.all);
              break;
            default:
              player.setLoopMode(LoopMode.off);
              break;
          }
        }

        if (builder != null) {
          return builder!(icon, onPressed);
        }

        if (filled) {
          return IconButton.filled(
            icon: icon,
            color: color,
            onPressed: onPressed,
          );
        }

        return IconButton(
          icon: icon,
          color: color,
          onPressed: onPressed,
        );
      },
      error: (error, stackTrace) {
        return disabledBtn(context);
      },
      loading: () {
        return disabledBtn(context);
      },
    );
  }

  IconButton disabledBtn(BuildContext context) {
    return IconButton(
      onPressed: null,
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      icon: Icon(
        FluentIcons.arrow_repeat_all_24_regular,
        size: size,
      ),
    );
  }
}

class ShuffleBtn extends ConsumerWidget {
  final double size;
  final bool filled;
  final Color? color;
  final Widget Function(Widget icon, VoidCallback onTap)? builder;
  const ShuffleBtn({
    super.key,
    this.size = 24.0,
    this.filled = false,
    this.color,
    this.builder,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final asyncShuffleModeEnabled = ref.watch(playerShuffleModeEnabledProvider);

    return asyncShuffleModeEnabled.when(
      data: (data) {
        final onIcon = filled
            ? FluentIcons.arrow_shuffle_24_filled
            : FluentIcons.arrow_shuffle_24_regular;
        final offIcon = filled
            ? FluentIcons.arrow_shuffle_off_24_filled
            : FluentIcons.arrow_shuffle_off_24_regular;
        final icon = Icon(
          data ? onIcon : offIcon,
          size: size,
        );

        onPressed() async {
          await player.setShuffleModeEnabled(!data);
          await player.shuffle();
        }

        if (builder != null) {
          return builder!(icon, onPressed);
        }

        if (filled) {
          return IconButton.filled(
            icon: icon,
            color: color,
            onPressed: onPressed,
          );
        }

        return IconButton(
          icon: icon,
          color: color,
          onPressed: onPressed,
        );
      },
      error: (error, stackTrace) {
        return disabledBtn(context);
      },
      loading: () {
        return disabledBtn(context);
      },
    );
  }

  IconButton disabledBtn(BuildContext context) {
    return IconButton(
      onPressed: null,
      disabledColor: context.colorScheme.outline.withOpacity(.5),
      icon: Icon(
        FluentIcons.arrow_shuffle_24_regular,
        size: size,
      ),
    );
  }
}
