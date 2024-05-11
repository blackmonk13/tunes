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
String _$songsControllerHash() => r'8e1967e7b6f70398727062aa0b58dd0886439b36';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
