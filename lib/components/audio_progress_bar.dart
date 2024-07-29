import 'package:flutter/material.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';

enum DurationDisplay {
  top,
  bottom,
  sides,
  left,
  right,
  none,
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    this.progress = Duration.zero,
    this.total = Duration.zero,
    this.durationDisplay = DurationDisplay.bottom,
    required this.onSeek,
    this.progressTextStyle,
    this.totalTextStyle,
    this.enabledThumbRadius = 15.0,
    this.overlayRadius = 20.0,
    this.trackHeight = 2.0,
    this.builder,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.disabledThumbColor,
  });
  final Duration progress;
  final Duration total;
  final ValueChanged<Duration> onSeek;
  final DurationDisplay durationDisplay;
  final TextStyle? progressTextStyle;
  final TextStyle? totalTextStyle;
  final double enabledThumbRadius;
  final double overlayRadius;
  final double trackHeight;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final Color? disabledThumbColor;
  final Widget Function(Widget slider, String progress, String total)? builder;

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
        trackHeight: trackHeight, // This changes the track height
        activeTrackColor: activeTrackColor,
        inactiveTrackColor: inactiveTrackColor,
        thumbColor: thumbColor,
        disabledThumbColor: disabledThumbColor,
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: overlayRadius,
        ), // This changes the overlay shape
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: enabledThumbRadius,
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

    if (builder != null) {
      return builder!
          .call(slider, formatDuration(progress), formatDuration(total));
    }

    final progressText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        right: 16.0,
      ),
      child: Text(
        formatDuration(progress),
        style: context.textTheme.labelMedium?.merge(progressTextStyle),
      ),
    );

    final totalText = Padding(
      padding: const EdgeInsets.all(6.0).copyWith(
        left: 16.0,
      ),
      child: Text(
        formatDuration(total),
        style: context.textTheme.labelMedium?.merge(totalTextStyle),
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

      case DurationDisplay.left:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  progressText,
                  Text(
                    "/",
                    style: context.textTheme.labelMedium?.merge(totalTextStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0).copyWith(
                      left: 8.0,
                    ),
                    child: Text(
                      formatDuration(total),
                      style:
                          context.textTheme.labelMedium?.merge(totalTextStyle),
                    ),
                  ),
                ],
              ),
            )
          ],
        );

      default:
        return slider;
    }
  }
}


