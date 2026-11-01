// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sends what was read or watched to the trackers, on a Ref that lives as
/// long as the app. A tracker answers over the network, by when the reader or
/// player that asked may have closed: its Ref, which the answer used to be
/// written through, was gone by then (#1079).

@ProviderFor(TrackerSync)
final trackerSyncProvider = TrackerSyncProvider._();

/// Sends what was read or watched to the trackers, on a Ref that lives as
/// long as the app. A tracker answers over the network, by when the reader or
/// player that asked may have closed: its Ref, which the answer used to be
/// written through, was gone by then (#1079).
final class TrackerSyncProvider extends $NotifierProvider<TrackerSync, void> {
  /// Sends what was read or watched to the trackers, on a Ref that lives as
  /// long as the app. A tracker answers over the network, by when the reader or
  /// player that asked may have closed: its Ref, which the answer used to be
  /// written through, was gone by then (#1079).
  TrackerSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackerSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackerSyncHash();

  @$internal
  @override
  TrackerSync create() => TrackerSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$trackerSyncHash() => r'b81f3abc4ac9a85dd96fcd2cccb495504c5c5ae5';

/// Sends what was read or watched to the trackers, on a Ref that lives as
/// long as the app. A tracker answers over the network, by when the reader or
/// player that asked may have closed: its Ref, which the answer used to be
/// written through, was gone by then (#1079).

abstract class _$TrackerSync extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(TrackState)
final trackStateProvider = TrackStateFamily._();

final class TrackStateProvider extends $NotifierProvider<TrackState, Track> {
  TrackStateProvider._({
    required TrackStateFamily super.from,
    required ({Track? track, ItemType? itemType, dynamic widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'trackStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackStateHash();

  @override
  String toString() {
    return r'trackStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TrackState create() => TrackState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Track value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Track>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TrackStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackStateHash() => r'dc1855833de899f805d7df2537fe71a115c9bc25';

final class TrackStateFamily extends $Family
    with
        $ClassFamilyOverride<
          TrackState,
          Track,
          Track,
          Track,
          ({Track? track, ItemType? itemType, dynamic widgetRef})
        > {
  TrackStateFamily._()
    : super(
        retry: null,
        name: r'trackStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrackStateProvider call({
    Track? track,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) => TrackStateProvider._(
    argument: (track: track, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'trackStateProvider';
}

abstract class _$TrackState extends $Notifier<Track> {
  late final _$args =
      ref.$arg as ({Track? track, ItemType? itemType, dynamic widgetRef});
  Track? get track => _$args.track;
  ItemType? get itemType => _$args.itemType;
  dynamic get widgetRef => _$args.widgetRef;

  Track build({
    Track? track,
    required ItemType? itemType,
    required dynamic widgetRef,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Track, Track>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Track, Track>,
              Track,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(
        track: _$args.track,
        itemType: _$args.itemType,
        widgetRef: _$args.widgetRef,
      ),
    );
  }
}

@ProviderFor(LastTrackerLibraryLocationState)
final lastTrackerLibraryLocationStateProvider =
    LastTrackerLibraryLocationStateProvider._();

final class LastTrackerLibraryLocationStateProvider
    extends $NotifierProvider<LastTrackerLibraryLocationState, (int, bool)> {
  LastTrackerLibraryLocationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastTrackerLibraryLocationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastTrackerLibraryLocationStateHash();

  @$internal
  @override
  LastTrackerLibraryLocationState create() => LastTrackerLibraryLocationState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((int, bool) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(int, bool)>(value),
    );
  }
}

String _$lastTrackerLibraryLocationStateHash() =>
    r'2ebcc2fe2f546ac397403909e659b94bdc3d6a9a';

abstract class _$LastTrackerLibraryLocationState
    extends $Notifier<(int, bool)> {
  (int, bool) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<(int, bool), (int, bool)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(int, bool), (int, bool)>,
              (int, bool),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
