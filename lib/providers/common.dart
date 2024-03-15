part of providers;

@riverpod
FutureOr<bool> appPermissions(Ref ref) async {
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

@riverpod
class AudioPaths extends _$AudioPaths {
  @override
  FutureOr<Set<String>> build() {
    return getMediaPaths.toSet();
  }

  Future<void> pickMediaPath() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final currentState = state.valueOrNull;

        if (currentState == null) {
          return {};
        }

        final selectedPath = await FilePicker.platform.getDirectoryPath();

        if (selectedPath == null) {
          return {};
        }

        currentState.add(selectedPath);

        await setMediaPaths(selectedPath);

        return currentState;
      },
    );
  }
}

@Riverpod(keepAlive: true)
TunesDatabase database(DatabaseRef ref) {
  return TunesDatabase();
}

@riverpod
BeamerDelegate routerDelegate(Ref ref) {
  return BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        HomeLocation(),
        // EulaLocation(),
        // PrivacyPolicyLocation(),
        // UserAgreementLocation(),
        ScanMusicLocation(),
        ScanOptionsLocation(),
        MusicManagementLocation(),
        MusicPathsLocation(),
        // SettingsLocation(),
        // TunesLocation(),
        // ArtistTunesLocation(),
        // AlbumTunesLocation(),
        // SearchLocation(),
        // PlaylistsLocation(),
      ],
    ),
    guards: [
      BeamGuard(
        pathPatterns: [
          ...ScanMusicLocation().pathPatterns,
        ],
        check: (context, location) {
          final mediaPths = getMediaPaths;
          return mediaPths.isNotEmpty;
        },
        beamToNamed: (_, __) => MusicPathsLocation().pathPatterns.first,
      ),
    ],
  );
}

@Riverpod(keepAlive: true)
String? managerPath(ManagerPathRef ref) {
  return getManagerPath;
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