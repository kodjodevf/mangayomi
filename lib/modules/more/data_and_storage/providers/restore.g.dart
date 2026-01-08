// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doRestore)
final doRestoreProvider = DoRestoreFamily._();

final class DoRestoreProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  DoRestoreProvider._({
    required DoRestoreFamily super.from,
    required ({String path, BuildContext context}) super.argument,
  }) : super(
         retry: null,
         name: r'doRestoreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$doRestoreHash();

  @override
  String toString() {
    return r'doRestoreProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as ({String path, BuildContext context});
    return doRestore(ref, path: argument.path, context: argument.context);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DoRestoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$doRestoreHash() => r'4e556ae822d1f48ef3519fd65393c178de14b73d';

final class DoRestoreFamily extends $Family
    with
        $FunctionalFamilyOverride<void, ({String path, BuildContext context})> {
  DoRestoreFamily._()
    : super(
        retry: null,
        name: r'doRestoreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DoRestoreProvider call({
    required String path,
    required BuildContext context,
  }) =>
      DoRestoreProvider._(argument: (path: path, context: context), from: this);

  @override
  String toString() => r'doRestoreProvider';
}

@ProviderFor(restoreBackup)
final restoreBackupProvider = RestoreBackupFamily._();

final class RestoreBackupProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  RestoreBackupProvider._({
    required RestoreBackupFamily super.from,
    required (Map<String, dynamic>, {bool full}) super.argument,
  }) : super(
         retry: null,
         name: r'restoreBackupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$restoreBackupHash();

  @override
  String toString() {
    return r'restoreBackupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as (Map<String, dynamic>, {bool full});
    return restoreBackup(ref, argument.$1, full: argument.full);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreBackupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$restoreBackupHash() => r'adc705e1e65dedcc919a525d7bd14f6451620c43';

final class RestoreBackupFamily extends $Family
    with $FunctionalFamilyOverride<void, (Map<String, dynamic>, {bool full})> {
  RestoreBackupFamily._()
    : super(
        retry: null,
        name: r'restoreBackupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RestoreBackupProvider call(Map<String, dynamic> backup, {bool full = true}) =>
      RestoreBackupProvider._(argument: (backup, full: full), from: this);

  @override
  String toString() => r'restoreBackupProvider';
}

@ProviderFor(restoreKotatsuBackup)
final restoreKotatsuBackupProvider = RestoreKotatsuBackupFamily._();

final class RestoreKotatsuBackupProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  RestoreKotatsuBackupProvider._({
    required RestoreKotatsuBackupFamily super.from,
    required Archive super.argument,
  }) : super(
         retry: null,
         name: r'restoreKotatsuBackupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$restoreKotatsuBackupHash();

  @override
  String toString() {
    return r'restoreKotatsuBackupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as Archive;
    return restoreKotatsuBackup(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreKotatsuBackupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$restoreKotatsuBackupHash() =>
    r'4b43cb1719527b3030b9966e5ef662c29435425d';

final class RestoreKotatsuBackupFamily extends $Family
    with $FunctionalFamilyOverride<void, Archive> {
  RestoreKotatsuBackupFamily._()
    : super(
        retry: null,
        name: r'restoreKotatsuBackupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RestoreKotatsuBackupProvider call(Archive archive) =>
      RestoreKotatsuBackupProvider._(argument: archive, from: this);

  @override
  String toString() => r'restoreKotatsuBackupProvider';
}

@ProviderFor(restoreTachiBkBackup)
final restoreTachiBkBackupProvider = RestoreTachiBkBackupFamily._();

final class RestoreTachiBkBackupProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  RestoreTachiBkBackupProvider._({
    required RestoreTachiBkBackupFamily super.from,
    required (String, BackupType) super.argument,
  }) : super(
         retry: null,
         name: r'restoreTachiBkBackupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$restoreTachiBkBackupHash();

  @override
  String toString() {
    return r'restoreTachiBkBackupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as (String, BackupType);
    return restoreTachiBkBackup(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreTachiBkBackupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$restoreTachiBkBackupHash() =>
    r'54434eaa9dc875d03ffb1dcf62ad2d7971649d61';

final class RestoreTachiBkBackupFamily extends $Family
    with $FunctionalFamilyOverride<void, (String, BackupType)> {
  RestoreTachiBkBackupFamily._()
    : super(
        retry: null,
        name: r'restoreTachiBkBackupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RestoreTachiBkBackupProvider call(String path, BackupType bkType) =>
      RestoreTachiBkBackupProvider._(argument: (path, bkType), from: this);

  @override
  String toString() => r'restoreTachiBkBackupProvider';
}
