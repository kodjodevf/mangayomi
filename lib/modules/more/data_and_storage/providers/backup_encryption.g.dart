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
    r'71cd564b1446c685162b67898e8dbaca5960de3f';

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
