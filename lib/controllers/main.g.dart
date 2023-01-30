// GENERATED CODE - DO NOT MODIFY BY HAND

part of controllers;

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

String _$TimerControllerHash() => r'ac80978fa27d7760d4dd060db6dab5f4cbd57968';

/// See also [TimerController].
final timerControllerProvider = AsyncNotifierProvider<TimerController, void>(
  TimerController.new,
  name: r'timerControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$TimerControllerHash,
);
typedef TimerControllerRef = AsyncNotifierProviderRef<void>;

abstract class _$TimerController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build();
}

String _$ScanControllerHash() => r'2ec07ff669a5eaa63aa830686091caf5502517ae';

/// See also [ScanController].
final scanControllerProvider =
    AutoDisposeAsyncNotifierProvider<ScanController, void>(
  ScanController.new,
  name: r'scanControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ScanControllerHash,
);
typedef ScanControllerRef = AutoDisposeAsyncNotifierProviderRef<void>;

abstract class _$ScanController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build();
}
