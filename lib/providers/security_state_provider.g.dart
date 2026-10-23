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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AppLockDelayState)
final appLockDelayStateProvider = AppLockDelayStateProvider._();

final class AppLockDelayStateProvider
    extends $NotifierProvider<AppLockDelayState, int> {
  AppLockDelayStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockDelayStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockDelayStateHash();

  @$internal
  @override
  AppLockDelayState create() => AppLockDelayState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$appLockDelayStateHash() => r'25599b7e0e2e3f81430c0f0db2b9d19de21793ea';

abstract class _$AppLockDelayState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SecureScreenState)
final secureScreenStateProvider = SecureScreenStateProvider._();

final class SecureScreenStateProvider
    extends $NotifierProvider<SecureScreenState, SecureScreenMode> {
  SecureScreenStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureScreenStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureScreenStateHash();

  @$internal
  @override
  SecureScreenState create() => SecureScreenState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureScreenMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureScreenMode>(value),
    );
  }
}

String _$secureScreenStateHash() => r'10409e3bf968b124117f2901b498d07664acd36a';

abstract class _$SecureScreenState extends $Notifier<SecureScreenMode> {
  SecureScreenMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SecureScreenMode, SecureScreenMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SecureScreenMode, SecureScreenMode>,
              SecureScreenMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the screen is secure right now: see [isScreenSecure].

@ProviderFor(secureScreenOn)
final secureScreenOnProvider = SecureScreenOnProvider._();

/// Whether the screen is secure right now: see [isScreenSecure].

final class SecureScreenOnProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the screen is secure right now: see [isScreenSecure].
  SecureScreenOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureScreenOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureScreenOnHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return secureScreenOn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$secureScreenOnHash() => r'761acf2f28c9ce206f19d797927905028d254d5e';
