// GENERATED CODE - DO NOT MODIFY BY HAND

part of providers;

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String _$mediaPathsHash() => r'e751a1efdc46dd8824ab47d9437475d197a97631';

/// See also [mediaPaths].
final mediaPathsProvider = AutoDisposeFutureProvider<List<String>>(
  mediaPaths,
  name: r'mediaPathsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mediaPathsHash,
);
typedef MediaPathsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$databaseHash() => r'3f207bbb0517a1881372e496989bb987a1b5f69a';

/// See also [database].
final databaseProvider = Provider<TunesDb>(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
);
typedef DatabaseRef = ProviderRef<TunesDb>;
String _$tunesRepositoryHash() => r'078b2c1c344f6427545a0f36a411d45dbdabb0a6';

/// See also [tunesRepository].
final tunesRepositoryProvider = Provider<TunesRepository>(
  tunesRepository,
  name: r'tunesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tunesRepositoryHash,
);
typedef TunesRepositoryRef = ProviderRef<TunesRepository>;
String _$NowPlayingPlaylistHash() =>
    r'25ccafdfcae470ee67172bd80b68dc85388e46c8';

/// See also [NowPlayingPlaylist].
final nowPlayingPlaylistProvider =
    AutoDisposeNotifierProvider<NowPlayingPlaylist, Playlist>(
  NowPlayingPlaylist.new,
  name: r'nowPlayingPlaylistProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$NowPlayingPlaylistHash,
);
typedef NowPlayingPlaylistRef = AutoDisposeNotifierProviderRef<Playlist>;

abstract class _$NowPlayingPlaylist extends AutoDisposeNotifier<Playlist> {
  @override
  Playlist build();
}

String _$SelectedSongsHash() => r'c2c14c9aecb87920dd893cb9f5ccde98c886ac06';

/// See also [SelectedSongs].
final selectedSongsProvider =
    AutoDisposeNotifierProvider<SelectedSongs, List<Audio>>(
  SelectedSongs.new,
  name: r'selectedSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$SelectedSongsHash,
);
typedef SelectedSongsRef = AutoDisposeNotifierProviderRef<List<Audio>>;

abstract class _$SelectedSongs extends AutoDisposeNotifier<List<Audio>> {
  @override
  List<Audio> build();
}

String _$tuneAudioHash() => r'7bb501229ca349b3092d13d88df43e89e8e3b89d';

/// See also [tuneAudio].
class TuneAudioProvider extends AutoDisposeFutureProvider<Audio> {
  TuneAudioProvider({
    required this.tune,
  }) : super(
          (ref) => tuneAudio(
            ref,
            tune: tune,
          ),
          from: tuneAudioProvider,
          name: r'tuneAudioProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tuneAudioHash,
        );

  final dynamic tune;

  @override
  bool operator ==(Object other) {
    return other is TuneAudioProvider && other.tune == tune;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tune.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef TuneAudioRef = AutoDisposeFutureProviderRef<Audio>;

/// See also [tuneAudio].
final tuneAudioProvider = TuneAudioFamily();

class TuneAudioFamily extends Family<AsyncValue<Audio>> {
  TuneAudioFamily();

  TuneAudioProvider call({
    required dynamic tune,
  }) {
    return TuneAudioProvider(
      tune: tune,
    );
  }

  @override
  AutoDisposeFutureProvider<Audio> getProviderOverride(
    covariant TuneAudioProvider provider,
  ) {
    return call(
      tune: provider.tune,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'tuneAudioProvider';
}
