// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algorithm_weights_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlgorithmWeightsState)
final algorithmWeightsStateProvider = AlgorithmWeightsStateProvider._();

final class AlgorithmWeightsStateProvider
    extends $NotifierProvider<AlgorithmWeightsState, AlgorithmWeights> {
  AlgorithmWeightsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'algorithmWeightsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$algorithmWeightsStateHash();

  @$internal
  @override
  AlgorithmWeightsState create() => AlgorithmWeightsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlgorithmWeights value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlgorithmWeights>(value),
    );
  }
}

String _$algorithmWeightsStateHash() =>
    r'5c20cb9b195a73161b485e082ad024b138c3da9c';

abstract class _$AlgorithmWeightsState extends $Notifier<AlgorithmWeights> {
  AlgorithmWeights build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlgorithmWeights, AlgorithmWeights>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlgorithmWeights, AlgorithmWeights>,
              AlgorithmWeights,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
