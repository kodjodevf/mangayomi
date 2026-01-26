// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_archive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(importArchivesFromFile)
final importArchivesFromFileProvider = ImportArchivesFromFileFamily._();

final class ImportArchivesFromFileProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  ImportArchivesFromFileProvider._({
    required ImportArchivesFromFileFamily super.from,
    required (Manga?, {ItemType itemType, bool init}) super.argument,
  }) : super(
         retry: null,
         name: r'importArchivesFromFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importArchivesFromFileHash();

  @override
  String toString() {
    return r'importArchivesFromFileProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    final argument = this.argument as (Manga?, {ItemType itemType, bool init});
    return importArchivesFromFile(
      ref,
      argument.$1,
      itemType: argument.itemType,
      init: argument.init,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImportArchivesFromFileProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importArchivesFromFileHash() =>
    r'52d80a07200627e1bc650b06d1fd8aed66c03e4c';

final class ImportArchivesFromFileFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<dynamic>,
          (Manga?, {ItemType itemType, bool init})
        > {
  ImportArchivesFromFileFamily._()
    : super(
        retry: null,
        name: r'importArchivesFromFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ImportArchivesFromFileProvider call(
    Manga? mManga, {
    required ItemType itemType,
    required bool init,
  }) => ImportArchivesFromFileProvider._(
    argument: (mManga, itemType: itemType, init: init),
    from: this,
  );

  @override
  String toString() => r'importArchivesFromFileProvider';
}
