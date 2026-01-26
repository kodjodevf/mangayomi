// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doBackUp)
final doBackUpProvider = DoBackUpFamily._();

final class DoBackUpProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  DoBackUpProvider._({
    required DoBackUpFamily super.from,
    required ({List<int> list, String path, BuildContext? context})
    super.argument,
  }) : super(
         retry: null,
         name: r'doBackUpProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$doBackUpHash();

  @override
  String toString() {
    return r'doBackUpProvider'
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
        this.argument as ({List<int> list, String path, BuildContext? context});
    return doBackUp(
      ref,
      list: argument.list,
      path: argument.path,
      context: argument.context,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DoBackUpProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$doBackUpHash() => r'231b70e9de3a2ed8d01c92569ce786c4de38ddc3';

final class DoBackUpFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({List<int> list, String path, BuildContext? context})
        > {
  DoBackUpFamily._()
    : super(
        retry: null,
        name: r'doBackUpProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DoBackUpProvider call({
    required List<int> list,
    required String path,
    required BuildContext? context,
  }) => DoBackUpProvider._(
    argument: (list: list, path: path, context: context),
    from: this,
  );

  @override
  String toString() => r'doBackUpProvider';
}
