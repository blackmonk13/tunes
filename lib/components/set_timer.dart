import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tunes/components/context_utils.dart';
import 'package:tunes/controllers/main.dart';

part 'set_timer.g.dart';

final _timeUnitProvider = StateProvider<int>(
  (ref) {
    return 0;
  },
);

final _timerValueProvider = StateProvider<int>((ref) {
  return 1;
});

@riverpod
Duration _timerDuration(Ref ref) {
  final tu = ref.watch(_timeUnitProvider);
  final tv = ref.watch(_timerValueProvider);
  switch (tu) {
    case 1:
      return Duration(
        minutes: tv,
      );
    case 2:
      return Duration(
        hours: tv,
      );
    default:
      return Duration(
        seconds: tv,
      );
  }
}

class SetTimer extends HookConsumerWidget {
  const SetTimer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_timerDurationProvider, (previous, next) {
      if (next == previous) {
        return;
      }
      ref.read(timerControllerProvider.notifier).setTimer(next);
    });
    final border = Border.all(
      color: context.colorScheme.outline.withOpacity(.5),
      width: .5,
    );
    return Container(
      height: context.screenHeight * .3,
      padding: const EdgeInsets.only(
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            primary: false,
            title: const Text(
              "Set Timer",
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await ref.read(timerControllerProvider.notifier).resetTimer();
                },
                icon: const HeroIcon(
                  HeroIcons.arrowUturnLeft,
                  size: 18.0,
                ),
                label: const Text("Reset"),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Center(
              child: SizedBox(
                // height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tvPicker(border),
                    SizedBox(
                      width: context.screenWidth * .03,
                    ),
                    _tuPicker(border),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _tvPicker(Border border) {
    final avTimes = List.generate(3600, (index) => index).sublist(1);
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(_timerValueProvider);
        const width = 100.0;
        return SizedBox(
          width: width,
          child: ListWheelScrollView(
            restorationId: "timer_time",
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: .8,
            squeeze: 1.1,
            clipBehavior: Clip.antiAlias,
            overAndUnderCenterOpacity: 0.5,
            onSelectedItemChanged: (value) {
              ref.read(_timerValueProvider.notifier).state =
                  avTimes.elementAt(value);
            },
            children: avTimes.map(
              (index) {
                return Container(
                  width: width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(1.0),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    index.toString(),
                    style: context.textTheme.displaySmall,
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  Widget _tuPicker(Border border) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(_timeUnitProvider);
        final width = context.screenWidth * .4;
        final dsmSize = context.textTheme.displaySmall?.fontSize;
        return SizedBox(
          width: width,
          child: ListWheelScrollView(
            restorationId: "timer_unit",
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            scrollBehavior: const CupertinoScrollBehavior(),
            diameterRatio: .85,
            squeeze: 1.1,
            overAndUnderCenterOpacity: 0.5,
            onSelectedItemChanged: (value) {
              ref.read(_timeUnitProvider.notifier).state = value;
            },
            children: ["Seconds", "Minutes", "Hours"].map(
              (tunit) {
                return Container(
                  width: width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(1.0),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    tunit,
                    style: context.textTheme.displaySmall?.copyWith(
                      fontSize: dsmSize == null ? null : dsmSize * .6,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
