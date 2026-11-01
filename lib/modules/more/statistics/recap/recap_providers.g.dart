// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recap_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statusWindow)
final statusWindowProvider = StatusWindowFamily._();

final class StatusWindowProvider
    extends
        $FunctionalProvider<
          AsyncValue<StatusWindowData>,
          StatusWindowData,
          FutureOr<StatusWindowData>
        >
    with $FutureModifier<StatusWindowData>, $FutureProvider<StatusWindowData> {
  StatusWindowProvider._({
    required StatusWindowFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'statusWindowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statusWindowHash();

  @override
  String toString() {
    return r'statusWindowProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StatusWindowData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StatusWindowData> create(Ref ref) {
    final argument = this.argument as ItemType;
    return statusWindow(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StatusWindowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statusWindowHash() => r'c51a6d9d47ae5a012354a15cc426ae6cedb04d56';

final class StatusWindowFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StatusWindowData>, ItemType> {
  StatusWindowFamily._()
    : super(
        retry: null,
        name: r'statusWindowProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StatusWindowProvider call({required ItemType itemType}) =>
      StatusWindowProvider._(argument: itemType, from: this);

  @override
  String toString() => r'statusWindowProvider';
}

@ProviderFor(episodeList)
final episodeListProvider = EpisodeListFamily._();

final class EpisodeListProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            ({List<EpisodeSummary> months, StatusWindowData prologue})
          >,
          ({List<EpisodeSummary> months, StatusWindowData prologue}),
          FutureOr<({List<EpisodeSummary> months, StatusWindowData prologue})>
        >
    with
        $FutureModifier<
          ({List<EpisodeSummary> months, StatusWindowData prologue})
        >,
        $FutureProvider<
          ({List<EpisodeSummary> months, StatusWindowData prologue})
        > {
  EpisodeListProvider._({
    required EpisodeListFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'episodeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeListHash();

  @override
  String toString() {
    return r'episodeListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<
    ({List<EpisodeSummary> months, StatusWindowData prologue})
  >
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<({List<EpisodeSummary> months, StatusWindowData prologue})> create(
    Ref ref,
  ) {
    final argument = this.argument as ItemType;
    return episodeList(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeListHash() => r'a832eb158cc2494ff1e91eefd61f7971e233e46c';

final class EpisodeListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({List<EpisodeSummary> months, StatusWindowData prologue})>,
          ItemType
        > {
  EpisodeListFamily._()
    : super(
        retry: null,
        name: r'episodeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EpisodeListProvider call({required ItemType itemType}) =>
      EpisodeListProvider._(argument: itemType, from: this);

  @override
  String toString() => r'episodeListProvider';
}

@ProviderFor(episode)
final episodeProvider = EpisodeFamily._();

final class EpisodeProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthStats>,
          MonthStats,
          FutureOr<MonthStats>
        >
    with $FutureModifier<MonthStats>, $FutureProvider<MonthStats> {
  EpisodeProvider._({
    required EpisodeFamily super.from,
    required ({ItemType itemType, int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'episodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeHash();

  @override
  String toString() {
    return r'episodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MonthStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MonthStats> create(Ref ref) {
    final argument =
        this.argument as ({ItemType itemType, int year, int month});
    return episode(
      ref,
      itemType: argument.itemType,
      year: argument.year,
      month: argument.month,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeHash() => r'eef7dc8e5dcf4fd703ee300e9634c3a3ddf0551c';

final class EpisodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MonthStats>,
          ({ItemType itemType, int year, int month})
        > {
  EpisodeFamily._()
    : super(
        retry: null,
        name: r'episodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EpisodeProvider call({
    required ItemType itemType,
    required int year,
    required int month,
  }) => EpisodeProvider._(
    argument: (itemType: itemType, year: year, month: month),
    from: this,
  );

  @override
  String toString() => r'episodeProvider';
}
