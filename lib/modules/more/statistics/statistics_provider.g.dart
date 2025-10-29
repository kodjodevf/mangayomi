// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatisticsState)
const statisticsStateProvider = StatisticsStateFamily._();

final class StatisticsStateProvider
    extends $NotifierProvider<StatisticsState, void> {
  const StatisticsStateProvider._({
    required StatisticsStateFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'statisticsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statisticsStateHash();

  @override
  String toString() {
    return r'statisticsStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StatisticsState create() => StatisticsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StatisticsStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statisticsStateHash() => r'81e1957e0e39a9863a8e7d0e1dc565c4eb0e6f9a';

final class StatisticsStateFamily extends $Family
    with $ClassFamilyOverride<StatisticsState, void, void, void, ItemType> {
  const StatisticsStateFamily._()
    : super(
        retry: null,
        name: r'statisticsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StatisticsStateProvider call(ItemType itemType) =>
      StatisticsStateProvider._(argument: itemType, from: this);

  @override
  String toString() => r'statisticsStateProvider';
}

abstract class _$StatisticsState extends $Notifier<void> {
  late final _$args = ref.$arg as ItemType;
  ItemType get itemType => _$args;

  void build(ItemType itemType);
  @$mustCallSuper
  @override
  void runBuild() {
    build(_$args);
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
