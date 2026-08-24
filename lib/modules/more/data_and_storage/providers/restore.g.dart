// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doRestore)
final doRestoreProvider = DoRestoreFamily._();

final class DoRestoreProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  DoRestoreProvider._({
    required DoRestoreFamily super.from,
    required ({
      String path,
      BuildContext context,
      bool merge,
      Map<String, bool> categoryDecisions,
      Map<String, int> sourceDecisions,
      bool? syncAfterRestore,
    })
    super.argument,
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String path,
              BuildContext context,
              bool merge,
              Map<String, bool> categoryDecisions,
              Map<String, int> sourceDecisions,
              bool? syncAfterRestore,
            });
    return doRestore(
      ref,
      path: argument.path,
      context: argument.context,
      merge: argument.merge,
      categoryDecisions: argument.categoryDecisions,
      sourceDecisions: argument.sourceDecisions,
      syncAfterRestore: argument.syncAfterRestore,
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

String _$doRestoreHash() => r'21371f2df249a161fccaa258cf49f95dbc6b74ff';

final class DoRestoreFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({
            String path,
            BuildContext context,
            bool merge,
            Map<String, bool> categoryDecisions,
            Map<String, int> sourceDecisions,
            bool? syncAfterRestore,
          })
        > {
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
    bool merge = false,
    Map<String, bool> categoryDecisions = const {},
    Map<String, int> sourceDecisions = const {},
    bool? syncAfterRestore,
  }) => DoRestoreProvider._(
    argument: (
      path: path,
      context: context,
      merge: merge,
      categoryDecisions: categoryDecisions,
      sourceDecisions: sourceDecisions,
      syncAfterRestore: syncAfterRestore,
    ),
    from: this,
  );

  @override
  String toString() => r'doRestoreProvider';
}

@ProviderFor(restoreBackup)
final restoreBackupProvider = RestoreBackupFamily._();

final class RestoreBackupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as (Map<String, dynamic>, {bool full});
    return restoreBackup(ref, argument.$1, full: argument.full);
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

String _$restoreBackupHash() => r'e2091b4ae0a868f6f13697663be45affe2c58a71';

final class RestoreBackupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          (Map<String, dynamic>, {bool full})
        > {
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
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as Archive;
    return restoreKotatsuBackup(ref, argument);
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
    r'5c3ac81350d5a6ca4c4f72e4f15928e9817beeb9';

final class RestoreKotatsuBackupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, Archive> {
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
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  RestoreTachiBkBackupProvider._({
    required RestoreTachiBkBackupFamily super.from,
    required (
      String,
      BackupType, {
      bool merge,
      Map<String, bool> categoryDecisions,
      Map<String, int> sourceDecisions,
    })
    super.argument,
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument
            as (
              String,
              BackupType, {
              bool merge,
              Map<String, bool> categoryDecisions,
              Map<String, int> sourceDecisions,
            });
    return restoreTachiBkBackup(
      ref,
      argument.$1,
      argument.$2,
      merge: argument.merge,
      categoryDecisions: argument.categoryDecisions,
      sourceDecisions: argument.sourceDecisions,
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
    r'aa5e671fb4c3c4f8d09c6b6fc464f96aa1b67d2b';

final class RestoreTachiBkBackupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          (
            String,
            BackupType, {
            bool merge,
            Map<String, bool> categoryDecisions,
            Map<String, int> sourceDecisions,
          })
        > {
  RestoreTachiBkBackupFamily._()
    : super(
        retry: null,
        name: r'restoreTachiBkBackupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RestoreTachiBkBackupProvider call(
    String path,
    BackupType bkType, {
    bool merge = false,
    Map<String, bool> categoryDecisions = const {},
    Map<String, int> sourceDecisions = const {},
  }) => RestoreTachiBkBackupProvider._(
    argument: (
      path,
      bkType,
      merge: merge,
      categoryDecisions: categoryDecisions,
      sourceDecisions: sourceDecisions,
    ),
    from: this,
  );

  @override
  String toString() => r'restoreTachiBkBackupProvider';
}
