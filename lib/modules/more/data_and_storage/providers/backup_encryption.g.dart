// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_encryption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupEncryptionEnabled)
final backupEncryptionEnabledProvider = BackupEncryptionEnabledProvider._();

final class BackupEncryptionEnabledProvider
    extends $NotifierProvider<BackupEncryptionEnabled, bool> {
  BackupEncryptionEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupEncryptionEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupEncryptionEnabledHash();

  @$internal
  @override
  BackupEncryptionEnabled create() => BackupEncryptionEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$backupEncryptionEnabledHash() =>
    r'eefefd0a13e6a12ae74ccddc7f161b9898f2d764';

abstract class _$BackupEncryptionEnabled extends $Notifier<bool> {
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
