// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blend_level_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlendLevelState)
final blendLevelStateProvider = BlendLevelStateProvider._();

final class BlendLevelStateProvider
    extends $NotifierProvider<BlendLevelState, double> {
  BlendLevelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blendLevelStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blendLevelStateHash();

  @$internal
  @override
  BlendLevelState create() => BlendLevelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$blendLevelStateHash() => r'f8658ae5f99624fde46d76e26575f04861f46bca';

abstract class _$BlendLevelState extends $Notifier<double> {
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
