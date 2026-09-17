// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_you_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MaterialYouState)
final materialYouStateProvider = MaterialYouStateProvider._();

final class MaterialYouStateProvider
    extends $NotifierProvider<MaterialYouState, bool> {
  MaterialYouStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'materialYouStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$materialYouStateHash();

  @$internal
  @override
  MaterialYouState create() => MaterialYouState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$materialYouStateHash() => r'80740ecd1db0ecbd7d8ba2292dcc96b5a142a839';

abstract class _$MaterialYouState extends $Notifier<bool> {
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
