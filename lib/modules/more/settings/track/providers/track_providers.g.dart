// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Tracks)
final tracksProvider = TracksFamily._();

final class TracksProvider extends $NotifierProvider<Tracks, TrackPreference?> {
  TracksProvider._({
    required TracksFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'tracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tracksHash();

  @override
  String toString() {
    return r'tracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Tracks create() => Tracks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackPreference? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackPreference?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tracksHash() => r'05f1531a3200b0ad9f1e4bf74cd9eb44301f9f21';

final class TracksFamily extends $Family
    with
        $ClassFamilyOverride<
          Tracks,
          TrackPreference?,
          TrackPreference?,
          TrackPreference?,
          int?
        > {
  TracksFamily._()
    : super(
        retry: null,
        name: r'tracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TracksProvider call({required int? syncId}) =>
      TracksProvider._(argument: syncId, from: this);

  @override
  String toString() => r'tracksProvider';
}

abstract class _$Tracks extends $Notifier<TrackPreference?> {
  late final _$args = ref.$arg as int?;
  int? get syncId => _$args;

  TrackPreference? build({required int? syncId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TrackPreference?, TrackPreference?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrackPreference?, TrackPreference?>,
              TrackPreference?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(syncId: _$args));
  }
}

@ProviderFor(UpdateProgressAfterReadingState)
final updateProgressAfterReadingStateProvider =
    UpdateProgressAfterReadingStateProvider._();

final class UpdateProgressAfterReadingStateProvider
    extends $NotifierProvider<UpdateProgressAfterReadingState, bool> {
  UpdateProgressAfterReadingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProgressAfterReadingStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProgressAfterReadingStateHash();

  @$internal
  @override
  UpdateProgressAfterReadingState create() => UpdateProgressAfterReadingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$updateProgressAfterReadingStateHash() =>
    r'ff62bff97327d9c6b2c694fb20ca8df98e5107a0';

abstract class _$UpdateProgressAfterReadingState extends $Notifier<bool> {
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
