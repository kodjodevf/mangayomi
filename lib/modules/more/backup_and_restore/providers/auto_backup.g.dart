// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkAndBackupHash() => r'039aea77df04d1925a25ad8839177cf9ee96aa65';

/// See also [checkAndBackup].
@ProviderFor(checkAndBackup)
final checkAndBackupProvider = AutoDisposeProvider<void>.internal(
  checkAndBackup,
  name: r'checkAndBackupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkAndBackupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CheckAndBackupRef = AutoDisposeProviderRef<void>;
String _$backupFrequencyStateHash() =>
    r'2e73e3fe54456978ff92f49cdc67e84f2af6de7c';

/// See also [BackupFrequencyState].
@ProviderFor(BackupFrequencyState)
final backupFrequencyStateProvider =
    AutoDisposeNotifierProvider<BackupFrequencyState, int>.internal(
  BackupFrequencyState.new,
  name: r'backupFrequencyStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupFrequencyStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupFrequencyState = AutoDisposeNotifier<int>;
String _$backupFrequencyOptionsStateHash() =>
    r'98c9a7014b56b3a2ec243f82efa3c2b5aade03fc';

/// See also [BackupFrequencyOptionsState].
@ProviderFor(BackupFrequencyOptionsState)
final backupFrequencyOptionsStateProvider = AutoDisposeNotifierProvider<
    BackupFrequencyOptionsState, List<int>>.internal(
  BackupFrequencyOptionsState.new,
  name: r'backupFrequencyOptionsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupFrequencyOptionsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupFrequencyOptionsState = AutoDisposeNotifier<List<int>>;
String _$autoBackupLocationStateHash() =>
    r'0ec954361736e570e3bc6fa4e7895fc79070cb33';

/// See also [AutoBackupLocationState].
@ProviderFor(AutoBackupLocationState)
final autoBackupLocationStateProvider = AutoDisposeNotifierProvider<
    AutoBackupLocationState, (String, String)>.internal(
  AutoBackupLocationState.new,
  name: r'autoBackupLocationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoBackupLocationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoBackupLocationState = AutoDisposeNotifier<(String, String)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
