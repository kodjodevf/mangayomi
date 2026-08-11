// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomColorFilterState)
final customColorFilterStateProvider = CustomColorFilterStateProvider._();

final class CustomColorFilterStateProvider
    extends $NotifierProvider<CustomColorFilterState, CustomColorFilter?> {
  CustomColorFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customColorFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customColorFilterStateHash();

  @$internal
  @override
  CustomColorFilterState create() => CustomColorFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomColorFilter? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomColorFilter?>(value),
    );
  }
}

String _$customColorFilterStateHash() =>
    r'e83ed3712f2f69c6ad15b2b3b10ff17cf8bb2898';

abstract class _$CustomColorFilterState extends $Notifier<CustomColorFilter?> {
  CustomColorFilter? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CustomColorFilter?, CustomColorFilter?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CustomColorFilter?, CustomColorFilter?>,
              CustomColorFilter?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EnableCustomColorFilterState)
final enableCustomColorFilterStateProvider =
    EnableCustomColorFilterStateProvider._();

final class EnableCustomColorFilterStateProvider
    extends $NotifierProvider<EnableCustomColorFilterState, bool> {
  EnableCustomColorFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enableCustomColorFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enableCustomColorFilterStateHash();

  @$internal
  @override
  EnableCustomColorFilterState create() => EnableCustomColorFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$enableCustomColorFilterStateHash() =>
    r'20579f0101c7f64051d63ea85813aeb068fdb3c9';

abstract class _$EnableCustomColorFilterState extends $Notifier<bool> {
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

@ProviderFor(ColorFilterBlendModeState)
final colorFilterBlendModeStateProvider = ColorFilterBlendModeStateProvider._();

final class ColorFilterBlendModeStateProvider
    extends $NotifierProvider<ColorFilterBlendModeState, ColorFilterBlendMode> {
  ColorFilterBlendModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorFilterBlendModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorFilterBlendModeStateHash();

  @$internal
  @override
  ColorFilterBlendModeState create() => ColorFilterBlendModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorFilterBlendMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorFilterBlendMode>(value),
    );
  }
}

String _$colorFilterBlendModeStateHash() =>
    r'92e84b352b519dd32d1c418d7477a10a8921bc19';

abstract class _$ColorFilterBlendModeState
    extends $Notifier<ColorFilterBlendMode> {
  ColorFilterBlendMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ColorFilterBlendMode, ColorFilterBlendMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ColorFilterBlendMode, ColorFilterBlendMode>,
              ColorFilterBlendMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
