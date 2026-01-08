// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_server.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncServer)
final syncServerProvider = SyncServerFamily._();

final class SyncServerProvider extends $NotifierProvider<SyncServer, void> {
  SyncServerProvider._({
    required SyncServerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'syncServerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$syncServerHash();

  @override
  String toString() {
    return r'syncServerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SyncServer create() => SyncServer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncServerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$syncServerHash() => r'088325d1503561d3ae74135e23308223f3c6bf43';

final class SyncServerFamily extends $Family
    with $ClassFamilyOverride<SyncServer, void, void, void, int> {
  SyncServerFamily._()
    : super(
        retry: null,
        name: r'syncServerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SyncServerProvider call({required int syncId}) =>
      SyncServerProvider._(argument: syncId, from: this);

  @override
  String toString() => r'syncServerProvider';
}

abstract class _$SyncServer extends $Notifier<void> {
  late final _$args = ref.$arg as int;
  int get syncId => _$args;

  void build({required int syncId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(syncId: _$args));
  }
}
