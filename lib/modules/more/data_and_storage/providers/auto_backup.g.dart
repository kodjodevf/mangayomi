// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupFrequencyState)
final backupFrequencyStateProvider = BackupFrequencyStateProvider._();

final class BackupFrequencyStateProvider
    extends $NotifierProvider<BackupFrequencyState, int> {
  BackupFrequencyStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupFrequencyStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupFrequencyStateHash();

  @$internal
  @override
  BackupFrequencyState create() => BackupFrequencyState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$backupFrequencyStateHash() =>
    r'2e73e3fe54456978ff92f49cdc67e84f2af6de7c';

abstract class _$BackupFrequencyState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BackupFrequencyOptionsState)
final backupFrequencyOptionsStateProvider =
    BackupFrequencyOptionsStateProvider._();

final class BackupFrequencyOptionsStateProvider
    extends $NotifierProvider<BackupFrequencyOptionsState, List<int>> {
  BackupFrequencyOptionsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupFrequencyOptionsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupFrequencyOptionsStateHash();

  @$internal
  @override
  BackupFrequencyOptionsState create() => BackupFrequencyOptionsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<int>>(value),
    );
  }
}

String _$backupFrequencyOptionsStateHash() =>
    r'9aa31bef65e0e2f20b306ed17ff058df2f24a635';

abstract class _$BackupFrequencyOptionsState extends $Notifier<List<int>> {
  List<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<int>, List<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<int>, List<int>>,
              List<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AutoBackupLocationState)
final autoBackupLocationStateProvider = AutoBackupLocationStateProvider._();

final class AutoBackupLocationStateProvider
    extends $NotifierProvider<AutoBackupLocationState, (String, String)> {
  AutoBackupLocationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoBackupLocationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoBackupLocationStateHash();

  @$internal
  @override
  AutoBackupLocationState create() => AutoBackupLocationState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((String, String) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(String, String)>(value),
    );
  }
}

String _$autoBackupLocationStateHash() =>
    r'c189f31917e32ce25ff195641ee449d969326b9b';

abstract class _$AutoBackupLocationState extends $Notifier<(String, String)> {
  (String, String) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<(String, String), (String, String)>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(String, String), (String, String)>,
              (String, String),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(checkAndBackup)
final checkAndBackupProvider = CheckAndBackupProvider._();

final class CheckAndBackupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  CheckAndBackupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkAndBackupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkAndBackupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return checkAndBackup(ref);
  }
}

String _$checkAndBackupHash() => r'7b1aabd24ab2a523571751df931576608b7f0e89';
