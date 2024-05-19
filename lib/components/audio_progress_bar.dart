import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/utils/extensions.dart';

enum DurationDisplay {
  top,
  bottom,
  sides,
  none,
}

class AudioProgressBar extends HookConsumerWidget {
  const AudioProgressBar({
    super.key,
    this.progress = Duration.zero,
    this.total = Duration.zero,
    this.durationDisplay = DurationDisplay.bottom,
    required this.onSeek,
  });
  final Duration progress;
  final Duration total;
  final ValueChanged<Duration> onSeek;
  final DurationDisplay durationDisplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressMilliseconds = progress.inMilliseconds.toDouble();
    final totalMilliseconds = total.inMilliseconds.toDouble();
    final progressPercentage = progressMilliseconds / totalMilliseconds * 100;

    if (progressPercentage.compareTo(0) == -1 ||
        // progressPercentage.compareTo(100) > 0 ||
        progressMilliseconds.compareTo(totalMilliseconds) > 0) {
      return const LinearProgressIndicator(
        value: 0,
      );
    }

    if (durationDisplay == DurationDisplay.none) {
      return LinearProgressIndicator(
        value: progressPercentage,
      );
    }

    final slider = Slider(
      value: progressMilliseconds,
      max: totalMilliseconds,
      onChanged: (value) {
        onSeek(
          Duration(
            milliseconds: value.toInt(),
          ),
        );
      },
    );

    final progressText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        right: 16.0,
      ),
      child: Text(
        formatDuration(progress),
        style: context.textTheme.labelMedium,
      ),
    );

    final totalText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        left: 16.0,
      ),
      child: Text(
        formatDuration(total),
        style: context.textTheme.labelMedium,
      ),
    );

    switch (durationDisplay) {
      case DurationDisplay.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  progressText,
                  totalText,
                ],
              ),
            ),
            slider,
          ],
        );
      case DurationDisplay.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  progressText,
                  totalText,
                ],
              ),
            )
          ],
        );
      default:
        return Row(
          children: [
            progressText,
            Expanded(
              child: slider,
            ),
            totalText,
          ],
        );
    }
  }
}

String formatDuration(Duration duration, {int padding = 2}) {
  if (duration.inMinutes < 1) {
    return '00:${duration.inSeconds.toString().padLeft(padding, '0')}';
  } else if (duration.inMinutes < 60) {
    return '${duration.inMinutes.toString().padLeft(padding, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  } else {
    return '${duration.inHours.toString().padLeft(padding, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
