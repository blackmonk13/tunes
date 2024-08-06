import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';
// late SharedPreferences prefs;

const themeModePrefsKey = "themeMode";
const managerPathPrefsKey = "managerpath";
const managerEnabledPrefsKey = "management_enabled";
const mediaPathsPrefsKey = "mediapaths";
const eulaPrefsKey = "eula_accepted";
const skipShortTracksPrefsKey = "skip_short_tracks";
const skipSmallTracksPrefsKey = "skip_small_tracks";
const filterPathsPrefsKey = "filter_paths";
const searchHistoryPrefsKey = "search_history";
// ThemeMode get themeModePref {
//   final themeModeInt = prefs.getInt(themeModePrefsKey);

//   if (themeModeInt == null) {
//     return ThemeMode.system;
//   }

//   return ThemeMode.values.elementAtOrNull(themeModeInt) ?? ThemeMode.system;
// }

// Future<bool> setThemeModePref(ThemeMode themeMode) async {
//   return prefs.setInt(themeModePrefsKey, themeMode.index);
// }

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}
