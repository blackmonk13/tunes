import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';

enum DurationDisplay {
  top,
  bottom,
  sides,
  none,
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    this.progress = Duration.zero,
    this.total = Duration.zero,
    this.durationDisplay = DurationDisplay.bottom,
    required this.onSeek,
    this.textStyle,
  });
  final Duration progress;
  final Duration total;
  final ValueChanged<Duration> onSeek;
  final DurationDisplay durationDisplay;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    int progressMilliseconds = progress.inMilliseconds;
    int totalMilliseconds = total.inMilliseconds;

    if (progressMilliseconds < 0) {
      progressMilliseconds = 0;
    }

    if (progressMilliseconds > totalMilliseconds && totalMilliseconds > 0) {
      progressMilliseconds = totalMilliseconds;
    }

    if (progressMilliseconds > totalMilliseconds && totalMilliseconds <= 0) {
      totalMilliseconds = progressMilliseconds;
    }

    final slider = SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2, // This changes the track height
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 20.0,
        ), // This changes the overlay shape
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 15.0,
        ), // This changes the thumb shape
      ),
      child: Slider(
        value: progressMilliseconds.toDouble(),
        max: totalMilliseconds.toDouble(),
        onChanged: (value) {
          onSeek(
            Duration(
              milliseconds: value.toInt(),
            ),
          );
        },
      ),
    );

    final progressText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        right: 16.0,
      ),
      child: Text(
        formatDuration(progress),
        style: context.textTheme.labelMedium?.merge(textStyle),
      ),
    );

    final totalText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        left: 16.0,
      ),
      child: Text(
        formatDuration(total),
        style: context.textTheme.labelMedium?.merge(textStyle),
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
      case DurationDisplay.sides:
        return Row(
          children: [
            progressText,
            Expanded(
              child: slider,
            ),
            totalText,
          ],
        );

      default:
        return slider;
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
