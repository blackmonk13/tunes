// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appPermissionsHash() => r'a6f69442778552d8d07f3bff6dec028bb1a309ea';

/// See also [appPermissions].
@ProviderFor(appPermissions)
final appPermissionsProvider = AutoDisposeFutureProvider<bool>.internal(
  appPermissions,
  name: r'appPermissionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appPermissionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppPermissionsRef = AutoDisposeFutureProviderRef<bool>;
String _$databaseHash() => r'e8e0bb971c6302c6a3bd59848e2a1da948420730';

/// See also [database].
@ProviderFor(database)
final databaseProvider = Provider<TunesDatabase>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseRef = ProviderRef<TunesDatabase>;
String _$routerDelegateHash() => r'939ba9a322d89c0d6159890a5046b198a918e46e';

/// See also [routerDelegate].
@ProviderFor(routerDelegate)
final routerDelegateProvider = AutoDisposeProvider<BeamerDelegate>.internal(
  routerDelegate,
  name: r'routerDelegateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routerDelegateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouterDelegateRef = AutoDisposeProviderRef<BeamerDelegate>;
String _$managerPathHash() => r'bf6a866c2013beada46cc83e780d07c045a4f0fa';

/// See also [managerPath].
@ProviderFor(managerPath)
final managerPathProvider = Provider<String?>.internal(
  managerPath,
  name: r'managerPathProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$managerPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ManagerPathRef = ProviderRef<String?>;
String _$eulaAcceptedHash() => r'868ef218cd63943f016b8b03d2e52eeba74cdc04';

/// See also [eulaAccepted].
@ProviderFor(eulaAccepted)
final eulaAcceptedProvider = Provider<bool>.internal(
  eulaAccepted,
  name: r'eulaAcceptedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eulaAcceptedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EulaAcceptedRef = ProviderRef<bool>;
String _$audioPlayerHash() => r'e4f91141090d1af71fce0d59ec408943dfcd4929';

/// See also [audioPlayer].
@ProviderFor(audioPlayer)
final audioPlayerProvider = Provider<AudioPlayer>.internal(
  audioPlayer,
  name: r'audioPlayerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioPlayerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioPlayerRef = ProviderRef<AudioPlayer>;
String _$playerPositionHash() => r'd5ddd2757b43355fd5d113791b2f975c21b994ef';

/// See also [playerPosition].
@ProviderFor(playerPosition)
final playerPositionProvider = StreamProvider<Duration>.internal(
  playerPosition,
  name: r'playerPositionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerPositionRef = StreamProviderRef<Duration>;
String _$playerPlayingHash() => r'2cc799cfd775a5ae21eae5c3f2125e43f40a1c90';

/// See also [playerPlaying].
@ProviderFor(playerPlaying)
final playerPlayingProvider = StreamProvider<bool>.internal(
  playerPlaying,
  name: r'playerPlayingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerPlayingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerPlayingRef = StreamProviderRef<bool>;
String _$playlistSequenceHash() => r'ab321a0af73b38c716ee41767d2f94e7c002fd95';

/// See also [playlistSequence].
@ProviderFor(playlistSequence)
final playlistSequenceProvider =
    StreamProvider<List<IndexedAudioSource>?>.internal(
  playlistSequence,
  name: r'playlistSequenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistSequenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlaylistSequenceRef = StreamProviderRef<List<IndexedAudioSource>?>;
String _$playerCurrentIndexHash() =>
    r'c9d2ef2a891652564d650ea46ad6e939c3fd5c32';

/// See also [playerCurrentIndex].
@ProviderFor(playerCurrentIndex)
final playerCurrentIndexProvider = StreamProvider<int?>.internal(
  playerCurrentIndex,
  name: r'playerCurrentIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerCurrentIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerCurrentIndexRef = StreamProviderRef<int?>;
String _$playerStateHash() => r'fb020f2f32180bc9704025c624d1b8abaf6b0a03';

/// See also [playerState].
@ProviderFor(playerState)
final playerStateProvider = StreamProvider<PlayerState>.internal(
  playerState,
  name: r'playerStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playerStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerStateRef = StreamProviderRef<PlayerState>;
String _$playerNowPlayingHash() => r'5afb49c3a0eb62dc0ea413dc09fe6a9c06dfb930';

/// See also [playerNowPlaying].
@ProviderFor(playerNowPlaying)
final playerNowPlayingProvider = StreamProvider<AudioSource?>.internal(
  playerNowPlaying,
  name: r'playerNowPlayingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerNowPlayingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerNowPlayingRef = StreamProviderRef<AudioSource?>;
String _$tuneSongWithPathHash() => r'b0f5e265bee2d86261b2b41442ca48b4fe60bcc3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [tuneSongWithPath].
@ProviderFor(tuneSongWithPath)
const tuneSongWithPathProvider = TuneSongWithPathFamily();

/// See also [tuneSongWithPath].
class TuneSongWithPathFamily extends Family<AsyncValue<TuneSong?>> {
  /// See also [tuneSongWithPath].
  const TuneSongWithPathFamily();

  /// See also [tuneSongWithPath].
  TuneSongWithPathProvider call(
    String pathname,
  ) {
    return TuneSongWithPathProvider(
      pathname,
    );
  }

  @override
  TuneSongWithPathProvider getProviderOverride(
    covariant TuneSongWithPathProvider provider,
  ) {
    return call(
      provider.pathname,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tuneSongWithPathProvider';
}

/// See also [tuneSongWithPath].
class TuneSongWithPathProvider extends AutoDisposeFutureProvider<TuneSong?> {
  /// See also [tuneSongWithPath].
  TuneSongWithPathProvider(
    String pathname,
  ) : this._internal(
          (ref) => tuneSongWithPath(
            ref as TuneSongWithPathRef,
            pathname,
          ),
          from: tuneSongWithPathProvider,
          name: r'tuneSongWithPathProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tuneSongWithPathHash,
          dependencies: TuneSongWithPathFamily._dependencies,
          allTransitiveDependencies:
              TuneSongWithPathFamily._allTransitiveDependencies,
          pathname: pathname,
        );

  TuneSongWithPathProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pathname,
  }) : super.internal();

  final String pathname;

  @override
  Override overrideWith(
    FutureOr<TuneSong?> Function(TuneSongWithPathRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TuneSongWithPathProvider._internal(
        (ref) => create(ref as TuneSongWithPathRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pathname: pathname,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TuneSong?> createElement() {
    return _TuneSongWithPathProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TuneSongWithPathProvider && other.pathname == pathname;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pathname.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TuneSongWithPathRef on AutoDisposeFutureProviderRef<TuneSong?> {
  /// The parameter `pathname` of this provider.
  String get pathname;
}

class _TuneSongWithPathProviderElement
    extends AutoDisposeFutureProviderElement<TuneSong?>
    with TuneSongWithPathRef {
  _TuneSongWithPathProviderElement(super.provider);

  @override
  String get pathname => (origin as TuneSongWithPathProvider).pathname;
}

String _$pagedTuneAlbumsHash() => r'80ddea4704fca21fa2164e2b2e727e7ae911f7fe';

/// See also [PagedTuneAlbums].
@ProviderFor(PagedTuneAlbums)
final pagedTuneAlbumsProvider =
    AutoDisposeAsyncNotifierProvider<PagedTuneAlbums, List<TuneAlbum>>.internal(
  PagedTuneAlbums.new,
  name: r'pagedTuneAlbumsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pagedTuneAlbumsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PagedTuneAlbums = AutoDisposeAsyncNotifier<List<TuneAlbum>>;
String _$pagedTuneArtistsHash() => r'f68cad6c60bdea74f762b663d763304bd300b995';

/// See also [PagedTuneArtists].
@ProviderFor(PagedTuneArtists)
final pagedTuneArtistsProvider = AutoDisposeAsyncNotifierProvider<
    PagedTuneArtists, List<TuneArtist>>.internal(
  PagedTuneArtists.new,
  name: r'pagedTuneArtistsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pagedTuneArtistsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PagedTuneArtists = AutoDisposeAsyncNotifier<List<TuneArtist>>;
String _$themeControllerHash() => r'ed3704ac6ef32325f1fa9ef3a8e6f248fa0c7e21';

/// See also [ThemeController].
@ProviderFor(ThemeController)
final themeControllerProvider =
    AutoDisposeNotifierProvider<ThemeController, ThemeMode>.internal(
  ThemeController.new,
  name: r'themeControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeController = AutoDisposeNotifier<ThemeMode>;
String _$audioPathsHash() => r'dc0bd23557c1b97eef310ec730a520663976acdd';

/// See also [AudioPaths].
@ProviderFor(AudioPaths)
final audioPathsProvider =
    AutoDisposeAsyncNotifierProvider<AudioPaths, Set<String>>.internal(
  AudioPaths.new,
  name: r'audioPathsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioPathsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AudioPaths = AutoDisposeAsyncNotifier<Set<String>>;
String _$tabIndexHash() => r'723f05abb21a581a48afc7f0e43ef19f54219263';

/// See also [TabIndex].
@ProviderFor(TabIndex)
final tabIndexProvider = NotifierProvider<TabIndex, int>.internal(
  TabIndex.new,
  name: r'tabIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tabIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TabIndex = Notifier<int>;
String _$playlistControllerHash() =>
    r'0e035335d9dc12d8a1e51ce47d1743333ebadeb3';

/// See also [PlaylistController].
@ProviderFor(PlaylistController)
final playlistControllerProvider =
    NotifierProvider<PlaylistController, ConcatenatingAudioSource>.internal(
  PlaylistController.new,
  name: r'playlistControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaylistController = Notifier<ConcatenatingAudioSource>;
String _$audioFileControllerHash() =>
    r'b91b70cd1de7ad80145ab65470ea3eed20d1f42c';

abstract class _$AudioFileController
    extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final File file;

  FutureOr<int> build(
    File file,
  );
}

/// See also [AudioFileController].
@ProviderFor(AudioFileController)
const audioFileControllerProvider = AudioFileControllerFamily();

/// See also [AudioFileController].
class AudioFileControllerFamily extends Family<AsyncValue<int>> {
  /// See also [AudioFileController].
  const AudioFileControllerFamily();

  /// See also [AudioFileController].
  AudioFileControllerProvider call(
    File file,
  ) {
    return AudioFileControllerProvider(
      file,
    );
  }

  @override
  AudioFileControllerProvider getProviderOverride(
    covariant AudioFileControllerProvider provider,
  ) {
    return call(
      provider.file,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'audioFileControllerProvider';
}

/// See also [AudioFileController].
class AudioFileControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AudioFileController, int> {
  /// See also [AudioFileController].
  AudioFileControllerProvider(
    File file,
  ) : this._internal(
          () => AudioFileController()..file = file,
          from: audioFileControllerProvider,
          name: r'audioFileControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$audioFileControllerHash,
          dependencies: AudioFileControllerFamily._dependencies,
          allTransitiveDependencies:
              AudioFileControllerFamily._allTransitiveDependencies,
          file: file,
        );

  AudioFileControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.file,
  }) : super.internal();

  final File file;

  @override
  FutureOr<int> runNotifierBuild(
    covariant AudioFileController notifier,
  ) {
    return notifier.build(
      file,
    );
  }

  @override
  Override overrideWith(AudioFileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AudioFileControllerProvider._internal(
        () => create()..file = file,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        file: file,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AudioFileController, int>
      createElement() {
    return _AudioFileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AudioFileControllerProvider && other.file == file;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AudioFileControllerRef on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `file` of this provider.
  File get file;
}

class _AudioFileControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AudioFileController, int>
    with AudioFileControllerRef {
  _AudioFileControllerProviderElement(super.provider);

  @override
  File get file => (origin as AudioFileControllerProvider).file;
}

String _$audioPathsWatcherHash() => r'a7d8cab533a542afaf02e6d07a0669f507760f62';

/// See also [AudioPathsWatcher].
@ProviderFor(AudioPathsWatcher)
final audioPathsWatcherProvider =
    AutoDisposeAsyncNotifierProvider<AudioPathsWatcher, void>.internal(
  AudioPathsWatcher.new,
  name: r'audioPathsWatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioPathsWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AudioPathsWatcher = AutoDisposeAsyncNotifier<void>;
String _$scanControllerHash() => r'61629f6764b578833f044b0e4ce243ac7612e57e';

/// See also [ScanController].
@ProviderFor(ScanController)
final scanControllerProvider =
    AutoDisposeAsyncNotifierProvider<ScanController, List<int>>.internal(
  ScanController.new,
  name: r'scanControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScanController = AutoDisposeAsyncNotifier<List<int>>;
String _$tuneSongsHash() => r'26cd00273320b1271b1debd996b1a249e51950d9';

/// See also [TuneSongs].
@ProviderFor(TuneSongs)
final tuneSongsProvider =
    AutoDisposeStreamNotifierProvider<TuneSongs, List<TuneSong>>.internal(
  TuneSongs.new,
  name: r'tuneSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tuneSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TuneSongs = AutoDisposeStreamNotifier<List<TuneSong>>;
String _$pagedTuneSongsHash() => r'993abb108647878dce4026acc605861d7864827f';

/// See also [PagedTuneSongs].
@ProviderFor(PagedTuneSongs)
final pagedTuneSongsProvider =
    AutoDisposeAsyncNotifierProvider<PagedTuneSongs, List<TuneSong>>.internal(
  PagedTuneSongs.new,
  name: r'pagedTuneSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pagedTuneSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PagedTuneSongs = AutoDisposeAsyncNotifier<List<TuneSong>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
