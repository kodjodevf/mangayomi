// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Synching)
final synchingProvider = SynchingFamily._();

final class SynchingProvider
    extends $NotifierProvider<Synching, SyncPreference> {
  SynchingProvider._({
    required SynchingFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'synchingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$synchingHash();

  @override
  String toString() {
    return r'synchingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Synching create() => Synching();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncPreference value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncPreference>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SynchingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$synchingHash() => r'7690d8467161e57e1987901391bb62471b68607b';

final class SynchingFamily extends $Family
    with
        $ClassFamilyOverride<
          Synching,
          SyncPreference,
          SyncPreference,
          SyncPreference,
          int?
        > {
  SynchingFamily._()
    : super(
        retry: null,
        name: r'synchingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SynchingProvider call({required int? syncId}) =>
      SynchingProvider._(argument: syncId, from: this);

  @override
  String toString() => r'synchingProvider';
}

abstract class _$Synching extends $Notifier<SyncPreference> {
  late final _$args = ref.$arg as int?;
  int? get syncId => _$args;

  SyncPreference build({required int? syncId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncPreference, SyncPreference>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncPreference, SyncPreference>,
              SyncPreference,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(syncId: _$args));
  }
}

/// True while a restore (and its post-restore upload) is in progress.
/// main_screen.dart pauses the auto-sync timer while this is true, and
/// syncServerProvider itself checks it too, so a manual sync trigger or an
/// already-running periodic timer can't race with an in-progress restore.

@ProviderFor(RestoreSyncGuard)
final restoreSyncGuardProvider = RestoreSyncGuardProvider._();

/// True while a restore (and its post-restore upload) is in progress.
/// main_screen.dart pauses the auto-sync timer while this is true, and
/// syncServerProvider itself checks it too, so a manual sync trigger or an
/// already-running periodic timer can't race with an in-progress restore.
final class RestoreSyncGuardProvider
    extends $NotifierProvider<RestoreSyncGuard, bool> {
  /// True while a restore (and its post-restore upload) is in progress.
  /// main_screen.dart pauses the auto-sync timer while this is true, and
  /// syncServerProvider itself checks it too, so a manual sync trigger or an
  /// already-running periodic timer can't race with an in-progress restore.
  RestoreSyncGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restoreSyncGuardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restoreSyncGuardHash();

  @$internal
  @override
  RestoreSyncGuard create() => RestoreSyncGuard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$restoreSyncGuardHash() => r'e8509758528b2054d27ffe7e04b34e540e810359';

/// True while a restore (and its post-restore upload) is in progress.
/// main_screen.dart pauses the auto-sync timer while this is true, and
/// syncServerProvider itself checks it too, so a manual sync trigger or an
/// already-running periodic timer can't race with an in-progress restore.

abstract class _$RestoreSyncGuard extends $Notifier<bool> {
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
