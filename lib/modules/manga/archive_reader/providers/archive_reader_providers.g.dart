// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getArchivesDataFromDirectory)
const getArchivesDataFromDirectoryProvider =
    GetArchivesDataFromDirectoryFamily._();

final class GetArchivesDataFromDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<(String, LocalExtensionType, Uint8List, String)>>,
          List<(String, LocalExtensionType, Uint8List, String)>,
          FutureOr<List<(String, LocalExtensionType, Uint8List, String)>>
        >
    with
        $FutureModifier<List<(String, LocalExtensionType, Uint8List, String)>>,
        $FutureProvider<List<(String, LocalExtensionType, Uint8List, String)>> {
  const GetArchivesDataFromDirectoryProvider._({
    required GetArchivesDataFromDirectoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getArchivesDataFromDirectoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getArchivesDataFromDirectoryHash();

  @override
  String toString() {
    return r'getArchivesDataFromDirectoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<(String, LocalExtensionType, Uint8List, String)>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<(String, LocalExtensionType, Uint8List, String)>> create(
    Ref ref,
  ) {
    final argument = this.argument as String;
    return getArchivesDataFromDirectory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchivesDataFromDirectoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getArchivesDataFromDirectoryHash() =>
    r'2a4d1a11e2b028e569ffd8a2700e4a1779bb9264';

final class GetArchivesDataFromDirectoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<(String, LocalExtensionType, Uint8List, String)>>,
          String
        > {
  const GetArchivesDataFromDirectoryFamily._()
    : super(
        retry: null,
        name: r'getArchivesDataFromDirectoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetArchivesDataFromDirectoryProvider call(String path) =>
      GetArchivesDataFromDirectoryProvider._(argument: path, from: this);

  @override
  String toString() => r'getArchivesDataFromDirectoryProvider';
}

@ProviderFor(getArchiveDataFromDirectory)
const getArchiveDataFromDirectoryProvider =
    GetArchiveDataFromDirectoryFamily._();

final class GetArchiveDataFromDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LocalArchive>>,
          List<LocalArchive>,
          FutureOr<List<LocalArchive>>
        >
    with
        $FutureModifier<List<LocalArchive>>,
        $FutureProvider<List<LocalArchive>> {
  const GetArchiveDataFromDirectoryProvider._({
    required GetArchiveDataFromDirectoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getArchiveDataFromDirectoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getArchiveDataFromDirectoryHash();

  @override
  String toString() {
    return r'getArchiveDataFromDirectoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LocalArchive>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LocalArchive>> create(Ref ref) {
    final argument = this.argument as String;
    return getArchiveDataFromDirectory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchiveDataFromDirectoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getArchiveDataFromDirectoryHash() =>
    r'49aa47895feafd9fa0c4f20e25d7674a3d54b212';

final class GetArchiveDataFromDirectoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LocalArchive>>, String> {
  const GetArchiveDataFromDirectoryFamily._()
    : super(
        retry: null,
        name: r'getArchiveDataFromDirectoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetArchiveDataFromDirectoryProvider call(String path) =>
      GetArchiveDataFromDirectoryProvider._(argument: path, from: this);

  @override
  String toString() => r'getArchiveDataFromDirectoryProvider';
}

@ProviderFor(getArchivesDataFromFile)
const getArchivesDataFromFileProvider = GetArchivesDataFromFileFamily._();

final class GetArchivesDataFromFileProvider
    extends
        $FunctionalProvider<
          AsyncValue<(String, LocalExtensionType, Uint8List, String)>,
          (String, LocalExtensionType, Uint8List, String),
          FutureOr<(String, LocalExtensionType, Uint8List, String)>
        >
    with
        $FutureModifier<(String, LocalExtensionType, Uint8List, String)>,
        $FutureProvider<(String, LocalExtensionType, Uint8List, String)> {
  const GetArchivesDataFromFileProvider._({
    required GetArchivesDataFromFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getArchivesDataFromFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getArchivesDataFromFileHash();

  @override
  String toString() {
    return r'getArchivesDataFromFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<(String, LocalExtensionType, Uint8List, String)>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<(String, LocalExtensionType, Uint8List, String)> create(Ref ref) {
    final argument = this.argument as String;
    return getArchivesDataFromFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchivesDataFromFileProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getArchivesDataFromFileHash() =>
    r'79874b548614b4410c19bca5f74978ec761742c5';

final class GetArchivesDataFromFileFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<(String, LocalExtensionType, Uint8List, String)>,
          String
        > {
  const GetArchivesDataFromFileFamily._()
    : super(
        retry: null,
        name: r'getArchivesDataFromFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetArchivesDataFromFileProvider call(String path) =>
      GetArchivesDataFromFileProvider._(argument: path, from: this);

  @override
  String toString() => r'getArchivesDataFromFileProvider';
}

@ProviderFor(getArchiveDataFromFile)
const getArchiveDataFromFileProvider = GetArchiveDataFromFileFamily._();

final class GetArchiveDataFromFileProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalArchive>,
          LocalArchive,
          FutureOr<LocalArchive>
        >
    with $FutureModifier<LocalArchive>, $FutureProvider<LocalArchive> {
  const GetArchiveDataFromFileProvider._({
    required GetArchiveDataFromFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getArchiveDataFromFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getArchiveDataFromFileHash();

  @override
  String toString() {
    return r'getArchiveDataFromFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LocalArchive> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalArchive> create(Ref ref) {
    final argument = this.argument as String;
    return getArchiveDataFromFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchiveDataFromFileProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getArchiveDataFromFileHash() =>
    r'a5d8bf8246bfa250af6a7fd3c09bba6a012e0b2d';

final class GetArchiveDataFromFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LocalArchive>, String> {
  const GetArchiveDataFromFileFamily._()
    : super(
        retry: null,
        name: r'getArchiveDataFromFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetArchiveDataFromFileProvider call(String path) =>
      GetArchiveDataFromFileProvider._(argument: path, from: this);

  @override
  String toString() => r'getArchiveDataFromFileProvider';
}
