part of 'providers.dart';

@riverpod
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
    return themeModePref;
  }

  Future<bool> setTheme(ThemeMode themeMode) async {
    return setThemeModePref(themeMode);
  }
}

@Riverpod(keepAlive: true)
bool eulaAccepted(EulaAcceptedRef ref) {
  return prefs.getBool(eulaPrefsKey) ?? false;
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