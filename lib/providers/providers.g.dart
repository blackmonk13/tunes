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
String _$songsControllerHash() => r'd8f8adc336f5f196b471631f7e9567495ad12260';

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
String _$metadataControllerHash() =>
    r'74ddd2da3521b20b63a49edc7f461b4a8f5b66c0';

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
