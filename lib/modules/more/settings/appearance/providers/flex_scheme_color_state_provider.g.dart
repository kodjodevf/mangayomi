// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_scheme_color_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FlexSchemeColorState)
final flexSchemeColorStateProvider = FlexSchemeColorStateProvider._();

final class FlexSchemeColorStateProvider
    extends $NotifierProvider<FlexSchemeColorState, FlexSchemeColor> {
  FlexSchemeColorStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flexSchemeColorStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flexSchemeColorStateHash();

  @$internal
  @override
  FlexSchemeColorState create() => FlexSchemeColorState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlexSchemeColor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlexSchemeColor>(value),
    );
  }
}

String _$flexSchemeColorStateHash() =>
    r'0b484f5c16d099fd94e2150bf4a32d9e8338feb3';

abstract class _$FlexSchemeColorState extends $Notifier<FlexSchemeColor> {
  FlexSchemeColor build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FlexSchemeColor, FlexSchemeColor>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FlexSchemeColor, FlexSchemeColor>,
              FlexSchemeColor,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
