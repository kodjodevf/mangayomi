// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_ui_scale_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [TvUiScale]); higher renders the UI larger, lower smaller.

@ProviderFor(TvUiScaleState)
final tvUiScaleStateProvider = TvUiScaleStateProvider._();

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [TvUiScale]); higher renders the UI larger, lower smaller.
final class TvUiScaleStateProvider
    extends $NotifierProvider<TvUiScaleState, double> {
  /// User fine-tune for the TV interface scale. 1.0 is the normalized reference
  /// (see [TvUiScale]); higher renders the UI larger, lower smaller.
  TvUiScaleStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvUiScaleStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvUiScaleStateHash();

  @$internal
  @override
  TvUiScaleState create() => TvUiScaleState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$tvUiScaleStateHash() => r'349b8b775f89f4e60199dce6b1e99ea88bf7322f';

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [TvUiScale]); higher renders the UI larger, lower smaller.

abstract class _$TvUiScaleState extends $Notifier<double> {
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
