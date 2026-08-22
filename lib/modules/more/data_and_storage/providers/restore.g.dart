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
            });
    return doRestore(
      ref,
      path: argument.path,
      context: argument.context,
      merge: argument.merge,
      categoryDecisions: argument.categoryDecisions,
      sourceDecisions: argument.sourceDecisions,
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

String _$doRestoreHash() => r'44cee71b4ad28492800f34f72a9c8b385d8b6ca3';

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
  }) => DoRestoreProvider._(
    argument: (
      path: path,
      context: context,
      merge: merge,
      categoryDecisions: categoryDecisions,
      sourceDecisions: sourceDecisions,
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

String _$restoreBackupHash() => r'02e1e607cf60fc3e0784deef5bdc27debe8d847e';

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
    r'e63edd7e3260920b9ced279927cae3902701f8a3';

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
    r'20c74e7c12682bd61d4df5ab0ae6ac79cbac0e8b';

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
