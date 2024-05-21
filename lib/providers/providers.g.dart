// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appPermissionsHash() => r'28b5c4871f6cc4c12f5235804b988b387181ece5';

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
String _$onAudioQueryHash() => r'f04116dc2e891977a5b8d187631655ff99fdcd95';

/// See also [onAudioQuery].
@ProviderFor(onAudioQuery)
final onAudioQueryProvider = Provider<OnAudioQuery>.internal(
  onAudioQuery,
  name: r'onAudioQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$onAudioQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OnAudioQueryRef = ProviderRef<OnAudioQuery>;
String _$audioPlayerHash() => r'e54ce7e5ba2cd12db0f50d7caaf550952480c971';

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
String _$mappedSongsHash() => r'9b1f304849883da9b96bef7d83438f9783e7d42f';

/// See also [mappedSongs].
@ProviderFor(mappedSongs)
final mappedSongsProvider =
    AutoDisposeFutureProvider<Map<int, SongModel>>.internal(
  mappedSongs,
  name: r'mappedSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mappedSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MappedSongsRef = AutoDisposeFutureProviderRef<Map<int, SongModel>>;
String _$songWithIdHash() => r'b062616051875ec5327830db0ad16c13a138ac0f';

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

/// See also [songWithId].
@ProviderFor(songWithId)
const songWithIdProvider = SongWithIdFamily();

/// See also [songWithId].
class SongWithIdFamily extends Family<AsyncValue<SongModel?>> {
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
class SongWithIdProvider extends AutoDisposeFutureProvider<SongModel?> {
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
    FutureOr<SongModel?> Function(SongWithIdRef provider) create,
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
  AutoDisposeFutureProviderElement<SongModel?> createElement() {
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

mixin SongWithIdRef on AutoDisposeFutureProviderRef<SongModel?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SongWithIdProviderElement
    extends AutoDisposeFutureProviderElement<SongModel?> with SongWithIdRef {
  _SongWithIdProviderElement(super.provider);

  @override
  String get id => (origin as SongWithIdProvider).id;
}

String _$currentSongInfoHash() => r'd6530f7304b14fee5988a286fad31216f67be727';

/// See also [currentSongInfo].
@ProviderFor(currentSongInfo)
final currentSongInfoProvider = AutoDisposeFutureProvider<SongModel?>.internal(
  currentSongInfo,
  name: r'currentSongInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSongInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSongInfoRef = AutoDisposeFutureProviderRef<SongModel?>;
String _$albumsControllerHash() => r'bcc768364faca97d0bef1975ae9159370e76eeac';

/// See also [AlbumsController].
@ProviderFor(AlbumsController)
final albumsControllerProvider = AutoDisposeAsyncNotifierProvider<
    AlbumsController, List<AlbumModel>>.internal(
  AlbumsController.new,
  name: r'albumsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$albumsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AlbumsController = AutoDisposeAsyncNotifier<List<AlbumModel>>;
String _$albumSongsHash() => r'a4f62f160d0af292df825cc6e979f8643bfda327';

abstract class _$AlbumSongs
    extends BuildlessAutoDisposeAsyncNotifier<List<SongModel>> {
  late final AlbumModel album;

  FutureOr<List<SongModel>> build(
    AlbumModel album,
  );
}

/// See also [AlbumSongs].
@ProviderFor(AlbumSongs)
const albumSongsProvider = AlbumSongsFamily();

/// See also [AlbumSongs].
class AlbumSongsFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [AlbumSongs].
  const AlbumSongsFamily();

  /// See also [AlbumSongs].
  AlbumSongsProvider call(
    AlbumModel album,
  ) {
    return AlbumSongsProvider(
      album,
    );
  }

  @override
  AlbumSongsProvider getProviderOverride(
    covariant AlbumSongsProvider provider,
  ) {
    return call(
      provider.album,
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
  String? get name => r'albumSongsProvider';
}

/// See also [AlbumSongs].
class AlbumSongsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AlbumSongs, List<SongModel>> {
  /// See also [AlbumSongs].
  AlbumSongsProvider(
    AlbumModel album,
  ) : this._internal(
          () => AlbumSongs()..album = album,
          from: albumSongsProvider,
          name: r'albumSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$albumSongsHash,
          dependencies: AlbumSongsFamily._dependencies,
          allTransitiveDependencies:
              AlbumSongsFamily._allTransitiveDependencies,
          album: album,
        );

  AlbumSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.album,
  }) : super.internal();

  final AlbumModel album;

  @override
  FutureOr<List<SongModel>> runNotifierBuild(
    covariant AlbumSongs notifier,
  ) {
    return notifier.build(
      album,
    );
  }

  @override
  Override overrideWith(AlbumSongs Function() create) {
    return ProviderOverride(
      origin: this,
      override: AlbumSongsProvider._internal(
        () => create()..album = album,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        album: album,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AlbumSongs, List<SongModel>>
      createElement() {
    return _AlbumSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumSongsProvider && other.album == album;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, album.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AlbumSongsRef on AutoDisposeAsyncNotifierProviderRef<List<SongModel>> {
  /// The parameter `album` of this provider.
  AlbumModel get album;
}

class _AlbumSongsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AlbumSongs, List<SongModel>>
    with AlbumSongsRef {
  _AlbumSongsProviderElement(super.provider);

  @override
  AlbumModel get album => (origin as AlbumSongsProvider).album;
}

String _$artistsControllerHash() => r'af37debb21b9732ec98d7be4473cbc777f2178e0';

/// See also [ArtistsController].
@ProviderFor(ArtistsController)
final artistsControllerProvider = AutoDisposeAsyncNotifierProvider<
    ArtistsController, List<ArtistModel>>.internal(
  ArtistsController.new,
  name: r'artistsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$artistsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArtistsController = AutoDisposeAsyncNotifier<List<ArtistModel>>;
String _$artistSongsHash() => r'65858739195cbec6efafb13b41fe406c37c3d090';

abstract class _$ArtistSongs
    extends BuildlessAutoDisposeAsyncNotifier<List<SongModel>> {
  late final ArtistModel artist;

  FutureOr<List<SongModel>> build(
    ArtistModel artist,
  );
}

/// See also [ArtistSongs].
@ProviderFor(ArtistSongs)
const artistSongsProvider = ArtistSongsFamily();

/// See also [ArtistSongs].
class ArtistSongsFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [ArtistSongs].
  const ArtistSongsFamily();

  /// See also [ArtistSongs].
  ArtistSongsProvider call(
    ArtistModel artist,
  ) {
    return ArtistSongsProvider(
      artist,
    );
  }

  @override
  ArtistSongsProvider getProviderOverride(
    covariant ArtistSongsProvider provider,
  ) {
    return call(
      provider.artist,
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
  String? get name => r'artistSongsProvider';
}

/// See also [ArtistSongs].
class ArtistSongsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ArtistSongs, List<SongModel>> {
  /// See also [ArtistSongs].
  ArtistSongsProvider(
    ArtistModel artist,
  ) : this._internal(
          () => ArtistSongs()..artist = artist,
          from: artistSongsProvider,
          name: r'artistSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$artistSongsHash,
          dependencies: ArtistSongsFamily._dependencies,
          allTransitiveDependencies:
              ArtistSongsFamily._allTransitiveDependencies,
          artist: artist,
        );

  ArtistSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artist,
  }) : super.internal();

  final ArtistModel artist;

  @override
  FutureOr<List<SongModel>> runNotifierBuild(
    covariant ArtistSongs notifier,
  ) {
    return notifier.build(
      artist,
    );
  }

  @override
  Override overrideWith(ArtistSongs Function() create) {
    return ProviderOverride(
      origin: this,
      override: ArtistSongsProvider._internal(
        () => create()..artist = artist,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artist: artist,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ArtistSongs, List<SongModel>>
      createElement() {
    return _ArtistSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistSongsProvider && other.artist == artist;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artist.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ArtistSongsRef on AutoDisposeAsyncNotifierProviderRef<List<SongModel>> {
  /// The parameter `artist` of this provider.
  ArtistModel get artist;
}

class _ArtistSongsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ArtistSongs,
        List<SongModel>> with ArtistSongsRef {
  _ArtistSongsProviderElement(super.provider);

  @override
  ArtistModel get artist => (origin as ArtistSongsProvider).artist;
}

String _$artistAlbumsHash() => r'278343a0220329c62696703d806cd635a29e2bc8';

abstract class _$ArtistAlbums
    extends BuildlessAutoDisposeAsyncNotifier<List<AlbumModel>> {
  late final ArtistModel artist;

  FutureOr<List<AlbumModel>> build(
    ArtistModel artist,
  );
}

/// See also [ArtistAlbums].
@ProviderFor(ArtistAlbums)
const artistAlbumsProvider = ArtistAlbumsFamily();

/// See also [ArtistAlbums].
class ArtistAlbumsFamily extends Family<AsyncValue<List<AlbumModel>>> {
  /// See also [ArtistAlbums].
  const ArtistAlbumsFamily();

  /// See also [ArtistAlbums].
  ArtistAlbumsProvider call(
    ArtistModel artist,
  ) {
    return ArtistAlbumsProvider(
      artist,
    );
  }

  @override
  ArtistAlbumsProvider getProviderOverride(
    covariant ArtistAlbumsProvider provider,
  ) {
    return call(
      provider.artist,
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
  String? get name => r'artistAlbumsProvider';
}

/// See also [ArtistAlbums].
class ArtistAlbumsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ArtistAlbums, List<AlbumModel>> {
  /// See also [ArtistAlbums].
  ArtistAlbumsProvider(
    ArtistModel artist,
  ) : this._internal(
          () => ArtistAlbums()..artist = artist,
          from: artistAlbumsProvider,
          name: r'artistAlbumsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$artistAlbumsHash,
          dependencies: ArtistAlbumsFamily._dependencies,
          allTransitiveDependencies:
              ArtistAlbumsFamily._allTransitiveDependencies,
          artist: artist,
        );

  ArtistAlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artist,
  }) : super.internal();

  final ArtistModel artist;

  @override
  FutureOr<List<AlbumModel>> runNotifierBuild(
    covariant ArtistAlbums notifier,
  ) {
    return notifier.build(
      artist,
    );
  }

  @override
  Override overrideWith(ArtistAlbums Function() create) {
    return ProviderOverride(
      origin: this,
      override: ArtistAlbumsProvider._internal(
        () => create()..artist = artist,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artist: artist,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ArtistAlbums, List<AlbumModel>>
      createElement() {
    return _ArtistAlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistAlbumsProvider && other.artist == artist;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artist.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ArtistAlbumsRef on AutoDisposeAsyncNotifierProviderRef<List<AlbumModel>> {
  /// The parameter `artist` of this provider.
  ArtistModel get artist;
}

class _ArtistAlbumsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ArtistAlbums,
        List<AlbumModel>> with ArtistAlbumsRef {
  _ArtistAlbumsProviderElement(super.provider);

  @override
  ArtistModel get artist => (origin as ArtistAlbumsProvider).artist;
}

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
String _$genresControllerHash() => r'60933916d0a498d194a169d5231886910c0b618c';

/// See also [GenresController].
@ProviderFor(GenresController)
final genresControllerProvider = AutoDisposeAsyncNotifierProvider<
    GenresController, List<GenreModel>>.internal(
  GenresController.new,
  name: r'genresControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$genresControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GenresController = AutoDisposeAsyncNotifier<List<GenreModel>>;
String _$genreSongsHash() => r'e895691d1bfd9385f39581b4499dd5f2baa5f67a';

abstract class _$GenreSongs
    extends BuildlessAutoDisposeAsyncNotifier<List<SongModel>> {
  late final GenreModel genre;

  FutureOr<List<SongModel>> build(
    GenreModel genre,
  );
}

/// See also [GenreSongs].
@ProviderFor(GenreSongs)
const genreSongsProvider = GenreSongsFamily();

/// See also [GenreSongs].
class GenreSongsFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [GenreSongs].
  const GenreSongsFamily();

  /// See also [GenreSongs].
  GenreSongsProvider call(
    GenreModel genre,
  ) {
    return GenreSongsProvider(
      genre,
    );
  }

  @override
  GenreSongsProvider getProviderOverride(
    covariant GenreSongsProvider provider,
  ) {
    return call(
      provider.genre,
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
  String? get name => r'genreSongsProvider';
}

/// See also [GenreSongs].
class GenreSongsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GenreSongs, List<SongModel>> {
  /// See also [GenreSongs].
  GenreSongsProvider(
    GenreModel genre,
  ) : this._internal(
          () => GenreSongs()..genre = genre,
          from: genreSongsProvider,
          name: r'genreSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genreSongsHash,
          dependencies: GenreSongsFamily._dependencies,
          allTransitiveDependencies:
              GenreSongsFamily._allTransitiveDependencies,
          genre: genre,
        );

  GenreSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genre,
  }) : super.internal();

  final GenreModel genre;

  @override
  FutureOr<List<SongModel>> runNotifierBuild(
    covariant GenreSongs notifier,
  ) {
    return notifier.build(
      genre,
    );
  }

  @override
  Override overrideWith(GenreSongs Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenreSongsProvider._internal(
        () => create()..genre = genre,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genre: genre,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GenreSongs, List<SongModel>>
      createElement() {
    return _GenreSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenreSongsProvider && other.genre == genre;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genre.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenreSongsRef on AutoDisposeAsyncNotifierProviderRef<List<SongModel>> {
  /// The parameter `genre` of this provider.
  GenreModel get genre;
}

class _GenreSongsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GenreSongs, List<SongModel>>
    with GenreSongsRef {
  _GenreSongsProviderElement(super.provider);

  @override
  GenreModel get genre => (origin as GenreSongsProvider).genre;
}

String _$playlistsControllerHash() =>
    r'4736e13fba599b7f62b1d6e312790c6067b6dbc7';

/// See also [PlaylistsController].
@ProviderFor(PlaylistsController)
final playlistsControllerProvider = AutoDisposeAsyncNotifierProvider<
    PlaylistsController, List<PlaylistModel>>.internal(
  PlaylistsController.new,
  name: r'playlistsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playlistsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlaylistsController = AutoDisposeAsyncNotifier<List<PlaylistModel>>;
String _$playlistSongsHash() => r'7a6743d90f0b3986a1c4d28fea953ddd2173ab44';

abstract class _$PlaylistSongs
    extends BuildlessAutoDisposeAsyncNotifier<List<SongModel>> {
  late final PlaylistModel playlist;

  FutureOr<List<SongModel>> build(
    PlaylistModel playlist,
  );
}

/// See also [PlaylistSongs].
@ProviderFor(PlaylistSongs)
const playlistSongsProvider = PlaylistSongsFamily();

/// See also [PlaylistSongs].
class PlaylistSongsFamily extends Family<AsyncValue<List<SongModel>>> {
  /// See also [PlaylistSongs].
  const PlaylistSongsFamily();

  /// See also [PlaylistSongs].
  PlaylistSongsProvider call(
    PlaylistModel playlist,
  ) {
    return PlaylistSongsProvider(
      playlist,
    );
  }

  @override
  PlaylistSongsProvider getProviderOverride(
    covariant PlaylistSongsProvider provider,
  ) {
    return call(
      provider.playlist,
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
  String? get name => r'playlistSongsProvider';
}

/// See also [PlaylistSongs].
class PlaylistSongsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PlaylistSongs, List<SongModel>> {
  /// See also [PlaylistSongs].
  PlaylistSongsProvider(
    PlaylistModel playlist,
  ) : this._internal(
          () => PlaylistSongs()..playlist = playlist,
          from: playlistSongsProvider,
          name: r'playlistSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playlistSongsHash,
          dependencies: PlaylistSongsFamily._dependencies,
          allTransitiveDependencies:
              PlaylistSongsFamily._allTransitiveDependencies,
          playlist: playlist,
        );

  PlaylistSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playlist,
  }) : super.internal();

  final PlaylistModel playlist;

  @override
  FutureOr<List<SongModel>> runNotifierBuild(
    covariant PlaylistSongs notifier,
  ) {
    return notifier.build(
      playlist,
    );
  }

  @override
  Override overrideWith(PlaylistSongs Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlaylistSongsProvider._internal(
        () => create()..playlist = playlist,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playlist: playlist,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PlaylistSongs, List<SongModel>>
      createElement() {
    return _PlaylistSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistSongsProvider && other.playlist == playlist;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playlist.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlaylistSongsRef on AutoDisposeAsyncNotifierProviderRef<List<SongModel>> {
  /// The parameter `playlist` of this provider.
  PlaylistModel get playlist;
}

class _PlaylistSongsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PlaylistSongs,
        List<SongModel>> with PlaylistSongsRef {
  _PlaylistSongsProviderElement(super.provider);

  @override
  PlaylistModel get playlist => (origin as PlaylistSongsProvider).playlist;
}

String _$songsControllerHash() => r'c7756e231494604cce19850615d0ebd985e66852';

/// See also [SongsController].
@ProviderFor(SongsController)
final songsControllerProvider =
    AutoDisposeAsyncNotifierProvider<SongsController, List<SongModel>>.internal(
  SongsController.new,
  name: r'songsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$songsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SongsController = AutoDisposeAsyncNotifier<List<SongModel>>;
String _$metadataControllerHash() =>
    r'be52aec82f3b88165b3185ac5722bba4af2e5efc';

abstract class _$MetadataController
    extends BuildlessAutoDisposeAsyncNotifier<bool?> {
  late final SongModel song;

  FutureOr<bool?> build(
    SongModel song,
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
    SongModel song,
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
    SongModel song,
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

  final SongModel song;

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
  SongModel get song;
}

class _MetadataControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MetadataController, bool?>
    with MetadataControllerRef {
  _MetadataControllerProviderElement(super.provider);

  @override
  SongModel get song => (origin as MetadataControllerProvider).song;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
