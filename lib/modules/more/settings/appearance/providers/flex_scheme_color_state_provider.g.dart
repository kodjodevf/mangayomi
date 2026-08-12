// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_scheme_color_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides both the selected theme index and the resolved FlexSchemeColor.
///
/// Returns a tuple `(color, index)`:
/// - `color` -> the resolved FlexSchemeColor (light or dark variant),
///              depending on the current theme mode
/// - `index` -> the selected FlexSchemeColor index stored in Isar

@ProviderFor(FlexSchemeColorState)
final flexSchemeColorStateProvider = FlexSchemeColorStateProvider._();

/// Provides both the selected theme index and the resolved FlexSchemeColor.
///
/// Returns a tuple `(color, index)`:
/// - `color` -> the resolved FlexSchemeColor (light or dark variant),
///              depending on the current theme mode
/// - `index` -> the selected FlexSchemeColor index stored in Isar
final class FlexSchemeColorStateProvider
    extends $NotifierProvider<FlexSchemeColorState, (FlexSchemeColor, int)> {
  /// Provides both the selected theme index and the resolved FlexSchemeColor.
  ///
  /// Returns a tuple `(color, index)`:
  /// - `color` -> the resolved FlexSchemeColor (light or dark variant),
  ///              depending on the current theme mode
  /// - `index` -> the selected FlexSchemeColor index stored in Isar
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
  Override overrideWithValue((FlexSchemeColor, int) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(FlexSchemeColor, int)>(value),
    );
  }
}

String _$flexSchemeColorStateHash() =>
    r'dff2511f13a308b2f2a79cfbff3be471c8644c71';

/// Provides both the selected theme index and the resolved FlexSchemeColor.
///
/// Returns a tuple `(color, index)`:
/// - `color` -> the resolved FlexSchemeColor (light or dark variant),
///              depending on the current theme mode
/// - `index` -> the selected FlexSchemeColor index stored in Isar

abstract class _$FlexSchemeColorState
    extends $Notifier<(FlexSchemeColor, int)> {
  (FlexSchemeColor, int) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<(FlexSchemeColor, int), (FlexSchemeColor, int)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(FlexSchemeColor, int), (FlexSchemeColor, int)>,
              (FlexSchemeColor, int),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
