// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appPermissionsHash() => r'dbb9998574e1d1c23023e36faeb68436079893ee';

/// See also [appPermissions].
@ProviderFor(appPermissions)
final appPermissionsProvider = FutureProvider<bool>.internal(
  appPermissions,
  name: r'appPermissionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appPermissionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppPermissionsRef = FutureProviderRef<bool>;
String _$eulaAcceptedHash() => r'cbe415528e220918bae4605cdbfc7141810bca4b';

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
String _$appStartupHash() => r'2ba814598e79496e4beb6fc00f19f18022730f77';

/// See also [appStartup].
@ProviderFor(appStartup)
final appStartupProvider = FutureProvider<void>.internal(
  appStartup,
  name: r'appStartupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStartupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppStartupRef = FutureProviderRef<void>;
String _$sortedArtistsHash() => r'a15fa9d6c2074d57ad85d5ea495ffdb470731868';

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

/// See also [sortedArtists].
@ProviderFor(sortedArtists)
const sortedArtistsProvider = SortedArtistsFamily();

/// See also [sortedArtists].
class SortedArtistsFamily extends Family<AsyncValue<List<Artist>>> {
  /// See also [sortedArtists].
  const SortedArtistsFamily();

  /// See also [sortedArtists].
  SortedArtistsProvider call({
    String? searchQuery,
  }) {
    return SortedArtistsProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  SortedArtistsProvider getProviderOverride(
    covariant SortedArtistsProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
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
  String? get name => r'sortedArtistsProvider';
}

/// See also [sortedArtists].
class SortedArtistsProvider extends AutoDisposeFutureProvider<List<Artist>> {
  /// See also [sortedArtists].
  SortedArtistsProvider({
    String? searchQuery,
  }) : this._internal(
          (ref) => sortedArtists(
            ref as SortedArtistsRef,
            searchQuery: searchQuery,
          ),
          from: sortedArtistsProvider,
          name: r'sortedArtistsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedArtistsHash,
          dependencies: SortedArtistsFamily._dependencies,
          allTransitiveDependencies:
              SortedArtistsFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SortedArtistsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<Artist>> Function(SortedArtistsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedArtistsProvider._internal(
        (ref) => create(ref as SortedArtistsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Artist>> createElement() {
    return _SortedArtistsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedArtistsProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SortedArtistsRef on AutoDisposeFutureProviderRef<List<Artist>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _SortedArtistsProviderElement
    extends AutoDisposeFutureProviderElement<List<Artist>>
    with SortedArtistsRef {
  _SortedArtistsProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as SortedArtistsProvider).searchQuery;
}

String _$sortedAlbumsHash() => r'6ad7f962229f153c96a038f5a2559e1a464ae775';

/// See also [sortedAlbums].
@ProviderFor(sortedAlbums)
const sortedAlbumsProvider = SortedAlbumsFamily();

/// See also [sortedAlbums].
class SortedAlbumsFamily extends Family<AsyncValue<List<Album>>> {
  /// See also [sortedAlbums].
  const SortedAlbumsFamily();

  /// See also [sortedAlbums].
  SortedAlbumsProvider call({
    String? searchQuery,
  }) {
    return SortedAlbumsProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  SortedAlbumsProvider getProviderOverride(
    covariant SortedAlbumsProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
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
  String? get name => r'sortedAlbumsProvider';
}

/// See also [sortedAlbums].
class SortedAlbumsProvider extends AutoDisposeFutureProvider<List<Album>> {
  /// See also [sortedAlbums].
  SortedAlbumsProvider({
    String? searchQuery,
  }) : this._internal(
          (ref) => sortedAlbums(
            ref as SortedAlbumsRef,
            searchQuery: searchQuery,
          ),
          from: sortedAlbumsProvider,
          name: r'sortedAlbumsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedAlbumsHash,
          dependencies: SortedAlbumsFamily._dependencies,
          allTransitiveDependencies:
              SortedAlbumsFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SortedAlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<Album>> Function(SortedAlbumsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedAlbumsProvider._internal(
        (ref) => create(ref as SortedAlbumsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Album>> createElement() {
    return _SortedAlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedAlbumsProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SortedAlbumsRef on AutoDisposeFutureProviderRef<List<Album>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _SortedAlbumsProviderElement
    extends AutoDisposeFutureProviderElement<List<Album>> with SortedAlbumsRef {
  _SortedAlbumsProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as SortedAlbumsProvider).searchQuery;
}

String _$sortedGenresHash() => r'6c9951e77ff9016985af1a0b2c5069ad6d43cc04';

/// See also [sortedGenres].
@ProviderFor(sortedGenres)
const sortedGenresProvider = SortedGenresFamily();

/// See also [sortedGenres].
class SortedGenresFamily extends Family<AsyncValue<List<Genre>>> {
  /// See also [sortedGenres].
  const SortedGenresFamily();

  /// See also [sortedGenres].
  SortedGenresProvider call({
    String? searchQuery,
  }) {
    return SortedGenresProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  SortedGenresProvider getProviderOverride(
    covariant SortedGenresProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
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
  String? get name => r'sortedGenresProvider';
}

/// See also [sortedGenres].
class SortedGenresProvider extends AutoDisposeFutureProvider<List<Genre>> {
  /// See also [sortedGenres].
  SortedGenresProvider({
    String? searchQuery,
  }) : this._internal(
          (ref) => sortedGenres(
            ref as SortedGenresRef,
            searchQuery: searchQuery,
          ),
          from: sortedGenresProvider,
          name: r'sortedGenresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortedGenresHash,
          dependencies: SortedGenresFamily._dependencies,
          allTransitiveDependencies:
              SortedGenresFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SortedGenresProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<Genre>> Function(SortedGenresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedGenresProvider._internal(
        (ref) => create(ref as SortedGenresRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Genre>> createElement() {
    return _SortedGenresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedGenresProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SortedGenresRef on AutoDisposeFutureProviderRef<List<Genre>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _SortedGenresProviderElement
    extends AutoDisposeFutureProviderElement<List<Genre>> with SortedGenresRef {
  _SortedGenresProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as SortedGenresProvider).searchQuery;
}

String _$labelsWatcherHash() => r'0e9f9cf887ecbf815d49818bf20461e9c70e6dfe';

/// See also [labelsWatcher].
@ProviderFor(labelsWatcher)
final labelsWatcherProvider = AutoDisposeStreamProvider<void>.internal(
  labelsWatcher,
  name: r'labelsWatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$labelsWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LabelsWatcherRef = AutoDisposeStreamProviderRef<void>;
String _$labelsHash() => r'30d7ed12db2f29b60156921b20cc6aa178d3315d';

/// See also [labels].
@ProviderFor(labels)
final labelsProvider = AutoDisposeFutureProvider<List<Label>>.internal(
  labels,
  name: r'labelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$labelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LabelsRef = AutoDisposeFutureProviderRef<List<Label>>;
String _$songLabelIdsHash() => r'314ec0bee1f1d325495a776ae6488ed89fbabc5d';

/// The ids of the labels attached to the song with [songId].
///
/// Copied from [songLabelIds].
@ProviderFor(songLabelIds)
const songLabelIdsProvider = SongLabelIdsFamily();

/// The ids of the labels attached to the song with [songId].
///
/// Copied from [songLabelIds].
class SongLabelIdsFamily extends Family<AsyncValue<Set<int>>> {
  /// The ids of the labels attached to the song with [songId].
  ///
  /// Copied from [songLabelIds].
  const SongLabelIdsFamily();

  /// The ids of the labels attached to the song with [songId].
  ///
  /// Copied from [songLabelIds].
  SongLabelIdsProvider call(
    int songId,
  ) {
    return SongLabelIdsProvider(
      songId,
    );
  }

  @override
  SongLabelIdsProvider getProviderOverride(
    covariant SongLabelIdsProvider provider,
  ) {
    return call(
      provider.songId,
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
  String? get name => r'songLabelIdsProvider';
}

/// The ids of the labels attached to the song with [songId].
///
/// Copied from [songLabelIds].
class SongLabelIdsProvider extends AutoDisposeFutureProvider<Set<int>> {
  /// The ids of the labels attached to the song with [songId].
  ///
  /// Copied from [songLabelIds].
  SongLabelIdsProvider(
    int songId,
  ) : this._internal(
          (ref) => songLabelIds(
            ref as SongLabelIdsRef,
            songId,
          ),
          from: songLabelIdsProvider,
          name: r'songLabelIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songLabelIdsHash,
          dependencies: SongLabelIdsFamily._dependencies,
          allTransitiveDependencies:
              SongLabelIdsFamily._allTransitiveDependencies,
          songId: songId,
        );

  SongLabelIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songId,
  }) : super.internal();

  final int songId;

  @override
  Override overrideWith(
    FutureOr<Set<int>> Function(SongLabelIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongLabelIdsProvider._internal(
        (ref) => create(ref as SongLabelIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songId: songId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Set<int>> createElement() {
    return _SongLabelIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongLabelIdsProvider && other.songId == songId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongLabelIdsRef on AutoDisposeFutureProviderRef<Set<int>> {
  /// The parameter `songId` of this provider.
  int get songId;
}

class _SongLabelIdsProviderElement
    extends AutoDisposeFutureProviderElement<Set<int>> with SongLabelIdsRef {
  _SongLabelIdsProviderElement(super.provider);

  @override
  int get songId => (origin as SongLabelIdsProvider).songId;
}

String _$songLabelsHash() => r'ae9412ec85bfb2e995b498d09560ddf157a139bd';

/// The labels attached to the song with [songId], sorted by name.
///
/// Copied from [songLabels].
@ProviderFor(songLabels)
const songLabelsProvider = SongLabelsFamily();

/// The labels attached to the song with [songId], sorted by name.
///
/// Copied from [songLabels].
class SongLabelsFamily extends Family<AsyncValue<List<Label>>> {
  /// The labels attached to the song with [songId], sorted by name.
  ///
  /// Copied from [songLabels].
  const SongLabelsFamily();

  /// The labels attached to the song with [songId], sorted by name.
  ///
  /// Copied from [songLabels].
  SongLabelsProvider call(
    int songId,
  ) {
    return SongLabelsProvider(
      songId,
    );
  }

  @override
  SongLabelsProvider getProviderOverride(
    covariant SongLabelsProvider provider,
  ) {
    return call(
      provider.songId,
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
  String? get name => r'songLabelsProvider';
}

/// The labels attached to the song with [songId], sorted by name.
///
/// Copied from [songLabels].
class SongLabelsProvider extends AutoDisposeFutureProvider<List<Label>> {
  /// The labels attached to the song with [songId], sorted by name.
  ///
  /// Copied from [songLabels].
  SongLabelsProvider(
    int songId,
  ) : this._internal(
          (ref) => songLabels(
            ref as SongLabelsRef,
            songId,
          ),
          from: songLabelsProvider,
          name: r'songLabelsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songLabelsHash,
          dependencies: SongLabelsFamily._dependencies,
          allTransitiveDependencies:
              SongLabelsFamily._allTransitiveDependencies,
          songId: songId,
        );

  SongLabelsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.songId,
  }) : super.internal();

  final int songId;

  @override
  Override overrideWith(
    FutureOr<List<Label>> Function(SongLabelsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongLabelsProvider._internal(
        (ref) => create(ref as SongLabelsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        songId: songId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Label>> createElement() {
    return _SongLabelsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongLabelsProvider && other.songId == songId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, songId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongLabelsRef on AutoDisposeFutureProviderRef<List<Label>> {
  /// The parameter `songId` of this provider.
  int get songId;
}

class _SongLabelsProviderElement
    extends AutoDisposeFutureProviderElement<List<Label>> with SongLabelsRef {
  _SongLabelsProviderElement(super.provider);

  @override
  int get songId => (origin as SongLabelsProvider).songId;
}

String _$audioPlayerHash() => r'98f6e2d720cf9b635687e9ef8797288f103dcd48';

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
String _$playerPositionHash() => r'40b0da81266f5646e83242918de401f8b358e11f';

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
String _$playerDurationHash() => r'd41387e73c96f9bcd3d495f7e66a5a7998424a4f';

/// See also [playerDuration].
@ProviderFor(playerDuration)
final playerDurationProvider = StreamProvider<Duration?>.internal(
  playerDuration,
  name: r'playerDurationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerDurationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerDurationRef = StreamProviderRef<Duration?>;
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
String _$playlistSequenceHash() => r'52c714961990c6c470632db2c5fee1b08b007179';

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
    r'320f28f7539f7f3340e0651e7a8f948ffc9045cc';

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
String _$playerStateHash() => r'8d7aedca6df3881f65f6eb7fce2f8edc14ed80d2';

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
String _$playerLoopModeHash() => r'3c057fe077d1007357d714b026a38197cddcd120';

/// See also [playerLoopMode].
@ProviderFor(playerLoopMode)
final playerLoopModeProvider = StreamProvider<LoopMode>.internal(
  playerLoopMode,
  name: r'playerLoopModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerLoopModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerLoopModeRef = StreamProviderRef<LoopMode>;
String _$playerShuffleModeEnabledHash() =>
    r'c1ee3d9b0b41afa0ff0622f58c5fda4f73835249';

/// See also [playerShuffleModeEnabled].
@ProviderFor(playerShuffleModeEnabled)
final playerShuffleModeEnabledProvider = StreamProvider<bool>.internal(
  playerShuffleModeEnabled,
  name: r'playerShuffleModeEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerShuffleModeEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerShuffleModeEnabledRef = StreamProviderRef<bool>;
String _$playerShuffleIndicesHash() =>
    r'b193edaefb5a890fd7cc167027fef31ad3369e7c';

/// See also [playerShuffleIndices].
@ProviderFor(playerShuffleIndices)
final playerShuffleIndicesProvider = StreamProvider<List<int>>.internal(
  playerShuffleIndices,
  name: r'playerShuffleIndicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playerShuffleIndicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlayerShuffleIndicesRef = StreamProviderRef<List<int>>;
String _$nowPlayingSongsHash() => r'00ae20c2331992cb77e0aa5e67353bd21bacf97e';

/// The songs currently in the player queue, in playlist order.
///
/// Copied from [nowPlayingSongs].
@ProviderFor(nowPlayingSongs)
final nowPlayingSongsProvider = FutureProvider<List<Song>>.internal(
  nowPlayingSongs,
  name: r'nowPlayingSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nowPlayingSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NowPlayingSongsRef = FutureProviderRef<List<Song>>;
String _$queueEntriesHash() => r'2c4ec17e5860b536c35f5cddbbdf352935fa9847';

/// The queue in playback order: the shuffle order when shuffle is on.
///
/// Copied from [queueEntries].
@ProviderFor(queueEntries)
final queueEntriesProvider = FutureProvider<List<QueueEntry>>.internal(
  queueEntries,
  name: r'queueEntriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$queueEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QueueEntriesRef = FutureProviderRef<List<QueueEntry>>;
String _$playbackSessionHash() => r'80cf8e5649e8665b1f4e615b81db2c59c54b0fe0';

/// Restores the last queue into the player (paused), then keeps saving it.
///
/// Must be awaited at startup after Isar and shared preferences are ready.
///
/// Copied from [playbackSession].
@ProviderFor(playbackSession)
final playbackSessionProvider = FutureProvider<void>.internal(
  playbackSession,
  name: r'playbackSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playbackSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlaybackSessionRef = FutureProviderRef<void>;
String _$playlistsWatcherHash() => r'a4ba3f613a00f4aecb2deaf69010b228aad81184';

/// See also [playlistsWatcher].
@ProviderFor(playlistsWatcher)
final playlistsWatcherProvider = AutoDisposeStreamProvider<void>.internal(
  playlistsWatcher,
  name: r'playlistsWatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistsWatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlaylistsWatcherRef = AutoDisposeStreamProviderRef<void>;
String _$songWithIdHash() => r'910afa630ad84fe729d944bf8884f3e9052d9c4c';

/// See also [songWithId].
@ProviderFor(songWithId)
const songWithIdProvider = SongWithIdFamily();

/// See also [songWithId].
class SongWithIdFamily extends Family<AsyncValue<Song?>> {
  /// See also [songWithId].
  const SongWithIdFamily();

  /// See also [songWithId].
  SongWithIdProvider call(
    String id,
  ) {
    return SongWithIdProvider(
      id,
    );
  }

  @override
  SongWithIdProvider getProviderOverride(
    covariant SongWithIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'songWithIdProvider';
}

/// See also [songWithId].
class SongWithIdProvider extends AutoDisposeFutureProvider<Song?> {
  /// See also [songWithId].
  SongWithIdProvider(
    String id,
  ) : this._internal(
          (ref) => songWithId(
            ref as SongWithIdRef,
            id,
          ),
          from: songWithIdProvider,
          name: r'songWithIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songWithIdHash,
          dependencies: SongWithIdFamily._dependencies,
          allTransitiveDependencies:
              SongWithIdFamily._allTransitiveDependencies,
          id: id,
        );

  SongWithIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Song?> Function(SongWithIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SongWithIdProvider._internal(
        (ref) => create(ref as SongWithIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Song?> createElement() {
    return _SongWithIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongWithIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongWithIdRef on AutoDisposeFutureProviderRef<Song?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SongWithIdProviderElement extends AutoDisposeFutureProviderElement<Song?>
    with SongWithIdRef {
  _SongWithIdProviderElement(super.provider);

  @override
  String get id => (origin as SongWithIdProvider).id;
}

String _$currentSongInfoHash() => r'be0017f4020b8668d14136c9127c523e5793827a';

/// See also [currentSongInfo].
@ProviderFor(currentSongInfo)
final currentSongInfoProvider = AutoDisposeFutureProvider<Song?>.internal(
  currentSongInfo,
  name: r'currentSongInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSongInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSongInfoRef = AutoDisposeFutureProviderRef<Song?>;
String _$thumbnailDataHash() => r'767cdd4e3ea2039b97d36598a066abc9e17c4de6';

/// See also [thumbnailData].
@ProviderFor(thumbnailData)
const thumbnailDataProvider = ThumbnailDataFamily();

/// See also [thumbnailData].
class ThumbnailDataFamily
    extends Family<AsyncValue<({FileImage image, PaletteGenerator palette})?>> {
  /// See also [thumbnailData].
  const ThumbnailDataFamily();

  /// See also [thumbnailData].
  ThumbnailDataProvider call(
    String? thumbnail,
  ) {
    return ThumbnailDataProvider(
      thumbnail,
    );
  }

  @override
  ThumbnailDataProvider getProviderOverride(
    covariant ThumbnailDataProvider provider,
  ) {
    return call(
      provider.thumbnail,
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
  String? get name => r'thumbnailDataProvider';
}

/// See also [thumbnailData].
class ThumbnailDataProvider
    extends FutureProvider<({FileImage image, PaletteGenerator palette})?> {
  /// See also [thumbnailData].
  ThumbnailDataProvider(
    String? thumbnail,
  ) : this._internal(
          (ref) => thumbnailData(
            ref as ThumbnailDataRef,
            thumbnail,
          ),
          from: thumbnailDataProvider,
          name: r'thumbnailDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$thumbnailDataHash,
          dependencies: ThumbnailDataFamily._dependencies,
          allTransitiveDependencies:
              ThumbnailDataFamily._allTransitiveDependencies,
          thumbnail: thumbnail,
        );

  ThumbnailDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.thumbnail,
  }) : super.internal();

  final String? thumbnail;

  @override
  Override overrideWith(
    FutureOr<({FileImage image, PaletteGenerator palette})?> Function(
            ThumbnailDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThumbnailDataProvider._internal(
        (ref) => create(ref as ThumbnailDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        thumbnail: thumbnail,
      ),
    );
  }

  @override
  FutureProviderElement<({FileImage image, PaletteGenerator palette})?>
      createElement() {
    return _ThumbnailDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThumbnailDataProvider && other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, thumbnail.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThumbnailDataRef
    on FutureProviderRef<({FileImage image, PaletteGenerator palette})?> {
  /// The parameter `thumbnail` of this provider.
  String? get thumbnail;
}

class _ThumbnailDataProviderElement extends FutureProviderElement<
    ({FileImage image, PaletteGenerator palette})?> with ThumbnailDataRef {
  _ThumbnailDataProviderElement(super.provider);

  @override
  String? get thumbnail => (origin as ThumbnailDataProvider).thumbnail;
}

String _$mp4HandlerHash() => r'b4b2f38c055d7a80ce4eaa19d9588d55bc644d89';

/// See also [mp4Handler].
@ProviderFor(mp4Handler)
const mp4HandlerProvider = Mp4HandlerFamily();

/// See also [mp4Handler].
class Mp4HandlerFamily extends Family<MP4Handler> {
  /// See also [mp4Handler].
  const Mp4HandlerFamily();

  /// See also [mp4Handler].
  Mp4HandlerProvider call(
    String filePath,
  ) {
    return Mp4HandlerProvider(
      filePath,
    );
  }

  @override
  Mp4HandlerProvider getProviderOverride(
    covariant Mp4HandlerProvider provider,
  ) {
    return call(
      provider.filePath,
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
  String? get name => r'mp4HandlerProvider';
}

/// See also [mp4Handler].
class Mp4HandlerProvider extends AutoDisposeProvider<MP4Handler> {
  /// See also [mp4Handler].
  Mp4HandlerProvider(
    String filePath,
  ) : this._internal(
          (ref) => mp4Handler(
            ref as Mp4HandlerRef,
            filePath,
          ),
          from: mp4HandlerProvider,
          name: r'mp4HandlerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mp4HandlerHash,
          dependencies: Mp4HandlerFamily._dependencies,
          allTransitiveDependencies:
              Mp4HandlerFamily._allTransitiveDependencies,
          filePath: filePath,
        );

  Mp4HandlerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filePath,
  }) : super.internal();

  final String filePath;

  @override
  Override overrideWith(
    MP4Handler Function(Mp4HandlerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Mp4HandlerProvider._internal(
        (ref) => create(ref as Mp4HandlerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filePath: filePath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<MP4Handler> createElement() {
    return _Mp4HandlerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Mp4HandlerProvider && other.filePath == filePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin Mp4HandlerRef on AutoDisposeProviderRef<MP4Handler> {
  /// The parameter `filePath` of this provider.
  String get filePath;
}

class _Mp4HandlerProviderElement extends AutoDisposeProviderElement<MP4Handler>
    with Mp4HandlerRef {
  _Mp4HandlerProviderElement(super.provider);

  @override
  String get filePath => (origin as Mp4HandlerProvider).filePath;
}

String _$themeControllerHash() => r'ffd9c2285caba34adfb4ad6a3a677282b0a28858';

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
String _$searchHistoryHash() => r'ed7f8b579eda31557a578834c5d290782f80fe55';

/// See also [SearchHistory].
@ProviderFor(SearchHistory)
final searchHistoryProvider =
    AutoDisposeNotifierProvider<SearchHistory, List<String>>.internal(
  SearchHistory.new,
  name: r'searchHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchHistory = AutoDisposeNotifier<List<String>>;
String _$groupSortOrderHash() => r'8cdc6d230b6e5da19f9f5c60e507ba8f6f4fd6b2';

abstract class _$GroupSortOrder
    extends BuildlessNotifier<({GroupSortType sortType, Sort orderType})> {
  late final GroupKind kind;

  ({GroupSortType sortType, Sort orderType}) build(
    GroupKind kind,
  );
}

/// The sort order of the artists, albums or genres list, remembered between
/// launches.
///
/// Copied from [GroupSortOrder].
@ProviderFor(GroupSortOrder)
const groupSortOrderProvider = GroupSortOrderFamily();

/// The sort order of the artists, albums or genres list, remembered between
/// launches.
///
/// Copied from [GroupSortOrder].
class GroupSortOrderFamily
    extends Family<({GroupSortType sortType, Sort orderType})> {
  /// The sort order of the artists, albums or genres list, remembered between
  /// launches.
  ///
  /// Copied from [GroupSortOrder].
  const GroupSortOrderFamily();

  /// The sort order of the artists, albums or genres list, remembered between
  /// launches.
  ///
  /// Copied from [GroupSortOrder].
  GroupSortOrderProvider call(
    GroupKind kind,
  ) {
    return GroupSortOrderProvider(
      kind,
    );
  }

  @override
  GroupSortOrderProvider getProviderOverride(
    covariant GroupSortOrderProvider provider,
  ) {
    return call(
      provider.kind,
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
  String? get name => r'groupSortOrderProvider';
}

/// The sort order of the artists, albums or genres list, remembered between
/// launches.
///
/// Copied from [GroupSortOrder].
class GroupSortOrderProvider extends NotifierProviderImpl<GroupSortOrder,
    ({GroupSortType sortType, Sort orderType})> {
  /// The sort order of the artists, albums or genres list, remembered between
  /// launches.
  ///
  /// Copied from [GroupSortOrder].
  GroupSortOrderProvider(
    GroupKind kind,
  ) : this._internal(
          () => GroupSortOrder()..kind = kind,
          from: groupSortOrderProvider,
          name: r'groupSortOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupSortOrderHash,
          dependencies: GroupSortOrderFamily._dependencies,
          allTransitiveDependencies:
              GroupSortOrderFamily._allTransitiveDependencies,
          kind: kind,
        );

  GroupSortOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kind,
  }) : super.internal();

  final GroupKind kind;

  @override
  ({GroupSortType sortType, Sort orderType}) runNotifierBuild(
    covariant GroupSortOrder notifier,
  ) {
    return notifier.build(
      kind,
    );
  }

  @override
  Override overrideWith(GroupSortOrder Function() create) {
    return ProviderOverride(
      origin: this,
      override: GroupSortOrderProvider._internal(
        () => create()..kind = kind,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kind: kind,
      ),
    );
  }

  @override
  NotifierProviderElement<GroupSortOrder,
      ({GroupSortType sortType, Sort orderType})> createElement() {
    return _GroupSortOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupSortOrderProvider && other.kind == kind;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kind.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GroupSortOrderRef
    on NotifierProviderRef<({GroupSortType sortType, Sort orderType})> {
  /// The parameter `kind` of this provider.
  GroupKind get kind;
}

class _GroupSortOrderProviderElement extends NotifierProviderElement<
    GroupSortOrder,
    ({GroupSortType sortType, Sort orderType})> with GroupSortOrderRef {
  _GroupSortOrderProviderElement(super.provider);

  @override
  GroupKind get kind => (origin as GroupSortOrderProvider).kind;
}

String _$labelsControllerHash() => r'ffabc679ec15817cdf1c288acd5a30aec03db5aa';

/// See also [LabelsController].
@ProviderFor(LabelsController)
final labelsControllerProvider =
    AutoDisposeNotifierProvider<LabelsController, void>.internal(
  LabelsController.new,
  name: r'labelsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$labelsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LabelsController = AutoDisposeNotifier<void>;
String _$playbackControllerHash() =>
    r'27f018116487c8dc80693ac55d14f7e4c216c31b';

/// See also [PlaybackController].
@ProviderFor(PlaybackController)
final playbackControllerProvider =
    AsyncNotifierProvider<PlaybackController, List<int>>.internal(
  PlaybackController.new,
  name: r'playbackControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playbackControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaybackController = AsyncNotifier<List<int>>;
String _$playlistsControllerHash() =>
    r'f7cf635c39a9160100263a725da6dbb85998573b';

/// See also [PlaylistsController].
@ProviderFor(PlaylistsController)
final playlistsControllerProvider = AutoDisposeAsyncNotifierProvider<
    PlaylistsController, List<Playlist>>.internal(
  PlaylistsController.new,
  name: r'playlistsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaylistsController = AutoDisposeAsyncNotifier<List<Playlist>>;
String _$favoritesPlaylistHash() => r'e20e247d953ba7c22c99288cb516aa4731516dbc';

/// See also [FavoritesPlaylist].
@ProviderFor(FavoritesPlaylist)
final favoritesPlaylistProvider =
    AutoDisposeAsyncNotifierProvider<FavoritesPlaylist, Playlist>.internal(
  FavoritesPlaylist.new,
  name: r'favoritesPlaylistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesPlaylistHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoritesPlaylist = AutoDisposeAsyncNotifier<Playlist>;
String _$songsSortOrderHash() => r'4301a44cc2f04ab2a143635a14ddd78fd29b3d15';

abstract class _$SongsSortOrder extends BuildlessAutoDisposeNotifier<
    ({SongsSortType sortType, Sort orderType})> {
  late final SongQueryType queryType;

  ({SongsSortType sortType, Sort orderType}) build(
    SongQueryType queryType,
  );
}

/// See also [SongsSortOrder].
@ProviderFor(SongsSortOrder)
const songsSortOrderProvider = SongsSortOrderFamily();

/// See also [SongsSortOrder].
class SongsSortOrderFamily
    extends Family<({SongsSortType sortType, Sort orderType})> {
  /// See also [SongsSortOrder].
  const SongsSortOrderFamily();

  /// See also [SongsSortOrder].
  SongsSortOrderProvider call(
    SongQueryType queryType,
  ) {
    return SongsSortOrderProvider(
      queryType,
    );
  }

  @override
  SongsSortOrderProvider getProviderOverride(
    covariant SongsSortOrderProvider provider,
  ) {
    return call(
      provider.queryType,
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
  String? get name => r'songsSortOrderProvider';
}

/// See also [SongsSortOrder].
class SongsSortOrderProvider extends AutoDisposeNotifierProviderImpl<
    SongsSortOrder, ({SongsSortType sortType, Sort orderType})> {
  /// See also [SongsSortOrder].
  SongsSortOrderProvider(
    SongQueryType queryType,
  ) : this._internal(
          () => SongsSortOrder()..queryType = queryType,
          from: songsSortOrderProvider,
          name: r'songsSortOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$songsSortOrderHash,
          dependencies: SongsSortOrderFamily._dependencies,
          allTransitiveDependencies:
              SongsSortOrderFamily._allTransitiveDependencies,
          queryType: queryType,
        );

  SongsSortOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queryType,
  }) : super.internal();

  final SongQueryType queryType;

  @override
  ({SongsSortType sortType, Sort orderType}) runNotifierBuild(
    covariant SongsSortOrder notifier,
  ) {
    return notifier.build(
      queryType,
    );
  }

  @override
  Override overrideWith(SongsSortOrder Function() create) {
    return ProviderOverride(
      origin: this,
      override: SongsSortOrderProvider._internal(
        () => create()..queryType = queryType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queryType: queryType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SongsSortOrder,
      ({SongsSortType sortType, Sort orderType})> createElement() {
    return _SongsSortOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SongsSortOrderProvider && other.queryType == queryType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queryType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SongsSortOrderRef on AutoDisposeNotifierProviderRef<
    ({SongsSortType sortType, Sort orderType})> {
  /// The parameter `queryType` of this provider.
  SongQueryType get queryType;
}

class _SongsSortOrderProviderElement extends AutoDisposeNotifierProviderElement<
    SongsSortOrder,
    ({SongsSortType sortType, Sort orderType})> with SongsSortOrderRef {
  _SongsSortOrderProviderElement(super.provider);

  @override
  SongQueryType get queryType => (origin as SongsSortOrderProvider).queryType;
}

String _$songsFilterConfigsHash() =>
    r'51c1b21d585b861883fb1599fed12c0570402122';

/// See also [SongsFilterConfigs].
@ProviderFor(SongsFilterConfigs)
final songsFilterConfigsProvider = NotifierProvider<SongsFilterConfigs,
    ({Set<PathFilter> filterPaths})>.internal(
  SongsFilterConfigs.new,
  name: r'songsFilterConfigsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$songsFilterConfigsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SongsFilterConfigs = Notifier<({Set<PathFilter> filterPaths})>;
String _$metadataControllerHash() =>
    r'3ecd382fe4d9a760c146e75556543baad0df5753';

abstract class _$MetadataController
    extends BuildlessAutoDisposeAsyncNotifier<bool?> {
  late final Song song;

  FutureOr<bool?> build(
    Song song,
  );
}

/// See also [MetadataController].
@ProviderFor(MetadataController)
const metadataControllerProvider = MetadataControllerFamily();

/// See also [MetadataController].
class MetadataControllerFamily extends Family<AsyncValue<bool?>> {
  /// See also [MetadataController].
  const MetadataControllerFamily();

  /// See also [MetadataController].
  MetadataControllerProvider call(
    Song song,
  ) {
    return MetadataControllerProvider(
      song,
    );
  }

  @override
  MetadataControllerProvider getProviderOverride(
    covariant MetadataControllerProvider provider,
  ) {
    return call(
      provider.song,
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
  String? get name => r'metadataControllerProvider';
}

/// See also [MetadataController].
class MetadataControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MetadataController, bool?> {
  /// See also [MetadataController].
  MetadataControllerProvider(
    Song song,
  ) : this._internal(
          () => MetadataController()..song = song,
          from: metadataControllerProvider,
          name: r'metadataControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$metadataControllerHash,
          dependencies: MetadataControllerFamily._dependencies,
          allTransitiveDependencies:
              MetadataControllerFamily._allTransitiveDependencies,
          song: song,
        );

  MetadataControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.song,
  }) : super.internal();

  final Song song;

  @override
  FutureOr<bool?> runNotifierBuild(
    covariant MetadataController notifier,
  ) {
    return notifier.build(
      song,
    );
  }

  @override
  Override overrideWith(MetadataController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MetadataControllerProvider._internal(
        () => create()..song = song,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        song: song,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MetadataController, bool?>
      createElement() {
    return _MetadataControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MetadataControllerProvider && other.song == song;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, song.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MetadataControllerRef on AutoDisposeAsyncNotifierProviderRef<bool?> {
  /// The parameter `song` of this provider.
  Song get song;
}

class _MetadataControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MetadataController, bool?>
    with MetadataControllerRef {
  _MetadataControllerProviderElement(super.provider);

  @override
  Song get song => (origin as MetadataControllerProvider).song;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
