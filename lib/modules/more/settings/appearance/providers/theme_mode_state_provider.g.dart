// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeModeState)
final themeModeStateProvider = ThemeModeStateProvider._();

final class ThemeModeStateProvider
    extends $NotifierProvider<ThemeModeState, bool> {
  ThemeModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeStateHash();

  @$internal
  @override
  ThemeModeState create() => ThemeModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$themeModeStateHash() => r'59776d1214831acd50931ccd2758afdd784d7dce';

abstract class _$ThemeModeState extends $Notifier<bool> {
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

@ProviderFor(FollowSystemThemeState)
final followSystemThemeStateProvider = FollowSystemThemeStateProvider._();

final class FollowSystemThemeStateProvider
    extends $NotifierProvider<FollowSystemThemeState, bool> {
  FollowSystemThemeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followSystemThemeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$followSystemThemeStateHash();

  @$internal
  @override
  FollowSystemThemeState create() => FollowSystemThemeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$followSystemThemeStateHash() =>
    r'64420ad3a07a0f4d0a54e6a5502b8db62ff355c9';

abstract class _$FollowSystemThemeState extends $Notifier<bool> {
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
