// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_connection_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncConnectionState)
final syncConnectionStateProvider = SyncConnectionStateFamily._();

final class SyncConnectionStateProvider
    extends $NotifierProvider<SyncConnectionState, SyncConnectionStatus> {
  SyncConnectionStateProvider._({
    required SyncConnectionStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'syncConnectionStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$syncConnectionStateHash();

  @override
  String toString() {
    return r'syncConnectionStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SyncConnectionState create() => SyncConnectionState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncConnectionStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncConnectionStatus>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncConnectionStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$syncConnectionStateHash() =>
    r'b4ad27b30466087f303df1a8bb111a4000dd765f';

final class SyncConnectionStateFamily extends $Family
    with
        $ClassFamilyOverride<
          SyncConnectionState,
          SyncConnectionStatus,
          SyncConnectionStatus,
          SyncConnectionStatus,
          int
        > {
  SyncConnectionStateFamily._()
    : super(
        retry: null,
        name: r'syncConnectionStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SyncConnectionStateProvider call({required int syncId}) =>
      SyncConnectionStateProvider._(argument: syncId, from: this);

  @override
  String toString() => r'syncConnectionStateProvider';
}

abstract class _$SyncConnectionState extends $Notifier<SyncConnectionStatus> {
  late final _$args = ref.$arg as int;
  int get syncId => _$args;

  SyncConnectionStatus build({required int syncId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncConnectionStatus, SyncConnectionStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncConnectionStatus, SyncConnectionStatus>,
              SyncConnectionStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(syncId: _$args));
  }
}
