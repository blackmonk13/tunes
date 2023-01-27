part of controllers;

@Riverpod(keepAlive: true)
class TimerController extends _$TimerController {
  Timer? timer;
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> setTimer(Duration duration) async {
    await resetTimer();
    state = const AsyncLoading();

    timer = Timer(
      duration,
      () async {
        state = await AsyncValue.guard(
          () async {
            await player.pause();
            return;
          },
        );
      },
    );
  }

  Future<void> resetTimer() async {
    timer?.cancel();
    state = const AsyncData(null);
  }
}
