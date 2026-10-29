part of 'providers.dart';

@Riverpod(keepAlive: true)
FutureOr<bool> appPermissions(AppPermissionsRef ref) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.audio,
    Permission.videos,
    Permission.manageExternalStorage,
  ].request();

  return statuses.entries.every(
    (element) {
      return element.value.isGranted;
    },
  );
}

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    final sharedPrefs = ref.watch(sharedPreferencesProvider).requireValue;
    final themeModeInt = sharedPrefs.getInt(themeModePrefsKey);

    if (themeModeInt == null) {
      return ThemeMode.system;
    }

    return ThemeMode.values.elementAtOrNull(themeModeInt) ?? ThemeMode.system;
  }

  Future<bool> setTheme(ThemeMode themeMode) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;
    return sharedPrefs.setInt(themeModePrefsKey, themeMode.index);
  }
}

@Riverpod(keepAlive: true)
bool eulaAccepted(EulaAcceptedRef ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider).requireValue;
  return sharedPrefs.getBool(eulaPrefsKey) ?? false;
}

@Riverpod(keepAlive: true)
class TabIndex extends _$TabIndex {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int index) {
    state = index;
  }
}

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(appPermissionsProvider);
    ref.invalidate(sharedPreferencesProvider);
    ref.invalidate(mediaQueryProvider);
    ref.invalidate(indexingControllerProvider);
    ref.invalidate(isarProvider);
    ref.invalidate(thumbnailDirectoryProvider);
  });
  // all asynchronous app initialization code should belong here:
  await ref.watch(sharedPreferencesProvider.future);
  await ref.watch(appPermissionsProvider.future);
  await ref.watch(isarProvider.future);
  await ref.watch(thumbnailDirectoryProvider.future);
  await ref.watch(playbackSessionProvider.future);
  ref.watch(indexingControllerProvider.future);
}

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    final sharedPrefs = ref.watch(sharedPreferencesProvider).requireValue;
    final searchHist = sharedPrefs.getStringList(searchHistoryPrefsKey);
    return searchHist?.toSet().toList() ?? [];
  }

  Future<bool> add(String item) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;
    final added = await sharedPrefs.setStringList(
      searchHistoryPrefsKey,
      {...state, item}.toList(),
    );

    if (added) {
      ref.invalidateSelf();
    }

    return added;
  }

  Future<bool> clear() async {
    final sharedPrefs = ref.read(sharedPreferencesProvider).requireValue;
    final cleared = await sharedPrefs.setStringList(
      searchHistoryPrefsKey,
      [],
    );

    if (cleared) {
      ref.invalidateSelf();
    }

    return cleared;
  }
}
