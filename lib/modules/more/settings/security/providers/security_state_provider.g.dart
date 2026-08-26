// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppLockEnabledState)
final appLockEnabledStateProvider = AppLockEnabledStateProvider._();

final class AppLockEnabledStateProvider
    extends $NotifierProvider<AppLockEnabledState, bool> {
  AppLockEnabledStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockEnabledStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockEnabledStateHash();

  @$internal
  @override
  AppLockEnabledState create() => AppLockEnabledState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appLockEnabledStateHash() =>
    r'bd5057b8e5d36c35c13e61c69d6b5f4b1bbd6af3';

abstract class _$AppLockEnabledState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Tracks whether the app is currently unlocked.
/// Resets to false when app goes to background (if lock is enabled).

@ProviderFor(AppUnlockedState)
final appUnlockedStateProvider = AppUnlockedStateProvider._();

/// Tracks whether the app is currently unlocked.
/// Resets to false when app goes to background (if lock is enabled).
final class AppUnlockedStateProvider
    extends $NotifierProvider<AppUnlockedState, bool> {
  /// Tracks whether the app is currently unlocked.
  /// Resets to false when app goes to background (if lock is enabled).
  AppUnlockedStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUnlockedStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUnlockedStateHash();

  @$internal
  @override
  AppUnlockedState create() => AppUnlockedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$appUnlockedStateHash() => r'2499c5d44ffbb889517ac8a87e6aa42a129edaa1';

/// Tracks whether the app is currently unlocked.
/// Resets to false when app goes to background (if lock is enabled).

abstract class _$AppUnlockedState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
