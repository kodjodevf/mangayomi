// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncProgress)
final syncProgressProvider = SyncProgressFamily._();

final class SyncProgressProvider
    extends $NotifierProvider<SyncProgress, SyncProgressState> {
  SyncProgressProvider._({
    required SyncProgressFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'syncProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$syncProgressHash();

  @override
  String toString() {
    return r'syncProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SyncProgress create() => SyncProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncProgressState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncProgressState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SyncProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$syncProgressHash() => r'0a33fd920b236acccdf0d9e1175faccf7e53a702';

final class SyncProgressFamily extends $Family
    with
        $ClassFamilyOverride<
          SyncProgress,
          SyncProgressState,
          SyncProgressState,
          SyncProgressState,
          int
        > {
  SyncProgressFamily._()
    : super(
        retry: null,
        name: r'syncProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SyncProgressProvider call({required int syncId}) =>
      SyncProgressProvider._(argument: syncId, from: this);

  @override
  String toString() => r'syncProgressProvider';
}

abstract class _$SyncProgress extends $Notifier<SyncProgressState> {
  late final _$args = ref.$arg as int;
  int get syncId => _$args;

  SyncProgressState build({required int syncId});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncProgressState, SyncProgressState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncProgressState, SyncProgressState>,
              SyncProgressState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(syncId: _$args));
  }
}
