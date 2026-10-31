// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A tracker kept on this device only (#52): status, progress, score and
/// dates for a series, with no account and nothing sent anywhere.
///
/// It is turned on in the tracking settings, where the other trackers are
/// signed into, and then sits beside them in every series' tracking sheet.
/// Its entries point at the series itself rather than at a site's page.

@ProviderFor(LocalTracker)
final localTrackerProvider = LocalTrackerFamily._();

/// A tracker kept on this device only (#52): status, progress, score and
/// dates for a series, with no account and nothing sent anywhere.
///
/// It is turned on in the tracking settings, where the other trackers are
/// signed into, and then sits beside them in every series' tracking sheet.
/// Its entries point at the series itself rather than at a site's page.
final class LocalTrackerProvider extends $NotifierProvider<LocalTracker, void> {
  /// A tracker kept on this device only (#52): status, progress, score and
  /// dates for a series, with no account and nothing sent anywhere.
  ///
  /// It is turned on in the tracking settings, where the other trackers are
  /// signed into, and then sits beside them in every series' tracking sheet.
  /// Its entries point at the series itself rather than at a site's page.
  LocalTrackerProvider._({
    required LocalTrackerFamily super.from,
    required ({int syncId, ItemType? itemType, dynamic widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'localTrackerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$localTrackerHash();

  @override
  String toString() {
    return r'localTrackerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LocalTracker create() => LocalTracker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LocalTrackerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$localTrackerHash() => r'f5979c4dd36c4e8595d016ecdc4fd2d53ad03ce4';

/// A tracker kept on this device only (#52): status, progress, score and
/// dates for a series, with no account and nothing sent anywhere.
///
/// It is turned on in the tracking settings, where the other trackers are
/// signed into, and then sits beside them in every series' tracking sheet.
/// Its entries point at the series itself rather than at a site's page.

final class LocalTrackerFamily extends $Family
    with
        $ClassFamilyOverride<
          LocalTracker,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, dynamic widgetRef})
        > {
  LocalTrackerFamily._()
    : super(
        retry: null,
        name: r'localTrackerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A tracker kept on this device only (#52): status, progress, score and
  /// dates for a series, with no account and nothing sent anywhere.
  ///
  /// It is turned on in the tracking settings, where the other trackers are
  /// signed into, and then sits beside them in every series' tracking sheet.
  /// Its entries point at the series itself rather than at a site's page.

  LocalTrackerProvider call({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) => LocalTrackerProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'localTrackerProvider';
}

/// A tracker kept on this device only (#52): status, progress, score and
/// dates for a series, with no account and nothing sent anywhere.
///
/// It is turned on in the tracking settings, where the other trackers are
/// signed into, and then sits beside them in every series' tracking sheet.
/// Its entries point at the series itself rather than at a site's page.

abstract class _$LocalTracker extends $Notifier<void> {
  late final _$args =
      ref.$arg as ({int syncId, ItemType? itemType, dynamic widgetRef});
  int get syncId => _$args.syncId;
  ItemType? get itemType => _$args.itemType;
  dynamic get widgetRef => _$args.widgetRef;

  void build({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  });
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
    return element.handleCreate(
      ref,
      () => build(
        syncId: _$args.syncId,
        itemType: _$args.itemType,
        widgetRef: _$args.widgetRef,
      ),
    );
  }
}
