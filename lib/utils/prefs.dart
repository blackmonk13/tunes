import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

const themeModePrefsKey = "themeMode";
const managerPathPrefsKey = "managerpath";
const managerEnabledPrefsKey = "management_enabled";
const mediaPathsPrefsKey = "mediapaths";
const eulaPrefsKey = "eula_accepted";
const skipShortTracksPrefsKey = "skip_short_tracks";
const skipSmallTracksPrefsKey = "skip_small_tracks";

ThemeMode get themeModePref {
  final themeModeInt = prefs.getInt(themeModePrefsKey);

  if (themeModeInt == null) {
    return ThemeMode.system;
  }

  return ThemeMode.values.elementAtOrNull(themeModeInt) ?? ThemeMode.system;
}

Future<bool> setThemeModePref(ThemeMode themeMode) async {
  return prefs.setInt(themeModePrefsKey, themeMode.index);
}

String? get getManagerPath {
  final managerPath = prefs.getString(managerPathPrefsKey);
  return managerPath;
}

bool get getManagerEnabled {
  final managerEnabled = prefs.getBool(managerEnabledPrefsKey);
  return managerEnabled ?? false;
}

Future<bool> setManagerEnabled(bool? enabled) async {
  if (enabled == null) {
    return prefs.remove(managerEnabledPrefsKey);
  }

  return prefs.setBool(
    managerEnabledPrefsKey,
    enabled,
  );
}

Future<bool> setManagerPath(String? newPath) async {
  if (newPath == null) {
    return prefs.remove(managerPathPrefsKey);
  }

  if (newPath.isEmpty) {
    return false;
  }

  return prefs.setString(
    managerPathPrefsKey,
    newPath,
  );
}

List<String> get getMediaPaths {
  final mediaPaths = prefs.getStringList(mediaPathsPrefsKey);
  return mediaPaths ?? [];
}

Future<bool> setMediaPaths(String? newPath) async {
  if (newPath == null) {
    return false;
  }

  if (newPath.isEmpty) {
    return false;
  }

  final existingPaths = getMediaPaths;
  return prefs.setStringList(
    mediaPathsPrefsKey,
    [
      ...existingPaths,
      newPath,
    ],
  );
}

Future<bool> deleteMediaPath(String pathToDelete) async {
  final existingPaths = getMediaPaths;

  // Check if the path exists in the list
  if (!existingPaths.contains(pathToDelete)) {
    return false;
  }

  // Remove the path from the list
  existingPaths.remove(pathToDelete);

  return prefs.setStringList(
    mediaPathsPrefsKey,
    existingPaths,
  );
}
