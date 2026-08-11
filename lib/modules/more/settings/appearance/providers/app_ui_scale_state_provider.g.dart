// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_ui_scale_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [AppUiScale]); higher renders the UI larger, lower smaller.

@ProviderFor(AppUiScaleState)
final appUiScaleStateProvider = AppUiScaleStateProvider._();

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [AppUiScale]); higher renders the UI larger, lower smaller.
final class AppUiScaleStateProvider
    extends $NotifierProvider<AppUiScaleState, double> {
  /// User fine-tune for the TV interface scale. 1.0 is the normalized reference
  /// (see [AppUiScale]); higher renders the UI larger, lower smaller.
  AppUiScaleStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUiScaleStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUiScaleStateHash();

  @$internal
  @override
  AppUiScaleState create() => AppUiScaleState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$appUiScaleStateHash() => r'e8cc7e2266975c7a9b08974167a5b1f5cd8415b9';

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [AppUiScale]); higher renders the UI larger, lower smaller.

abstract class _$AppUiScaleState extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
