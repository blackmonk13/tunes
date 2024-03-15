import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tunes/utils/extensions.dart';
import 'package:tunes/utils/functions.dart';

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
        progressPercentage.compareTo(100) > 0 ||
        progressMilliseconds.compareTo(totalMilliseconds) > 0) {
      return const ProgressBar(
        value: 0,
      );
    }

    if (durationDisplay == DurationDisplay.none) {
      return ProgressBar(
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
