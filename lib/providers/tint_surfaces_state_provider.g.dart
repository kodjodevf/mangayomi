// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tint_surfaces_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the palette colours the surfaces too, or only the accent.

@ProviderFor(TintSurfacesState)
final tintSurfacesStateProvider = TintSurfacesStateProvider._();

/// Whether the palette colours the surfaces too, or only the accent.
final class TintSurfacesStateProvider
    extends $NotifierProvider<TintSurfacesState, bool> {
  /// Whether the palette colours the surfaces too, or only the accent.
  TintSurfacesStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tintSurfacesStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tintSurfacesStateHash();

  @$internal
  @override
  TintSurfacesState create() => TintSurfacesState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$tintSurfacesStateHash() => r'af660d336f626052ad7fbe7d09e167219461ffb1';

/// Whether the palette colours the surfaces too, or only the accent.

abstract class _$TintSurfacesState extends $Notifier<bool> {
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
