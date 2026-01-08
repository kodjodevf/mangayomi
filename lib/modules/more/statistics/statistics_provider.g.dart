// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getStatistics)
final getStatisticsProvider = GetStatisticsFamily._();

final class GetStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StatisticsData>,
          StatisticsData,
          FutureOr<StatisticsData>
        >
    with $FutureModifier<StatisticsData>, $FutureProvider<StatisticsData> {
  GetStatisticsProvider._({
    required GetStatisticsFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'getStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getStatisticsHash();

  @override
  String toString() {
    return r'getStatisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StatisticsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StatisticsData> create(Ref ref) {
    final argument = this.argument as ItemType;
    return getStatistics(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetStatisticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getStatisticsHash() => r'f4a11dfa53b9560da765b1822fadc758a0a23cba';

final class GetStatisticsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StatisticsData>, ItemType> {
  GetStatisticsFamily._()
    : super(
        retry: null,
        name: r'getStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetStatisticsProvider call({required ItemType itemType}) =>
      GetStatisticsProvider._(argument: itemType, from: this);

  @override
  String toString() => r'getStatisticsProvider';
}
