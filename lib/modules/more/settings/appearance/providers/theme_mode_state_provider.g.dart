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

String _$themeModeStateHash() => r'af2bd9815f5cc942eb453d81b5fa15ba9e76cb4f';

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
    r'cecd00f39162ef45b3c658c325cbf726bb70986c';

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
