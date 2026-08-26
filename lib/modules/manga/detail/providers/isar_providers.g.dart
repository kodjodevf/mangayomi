// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMangaDetailStream)
final getMangaDetailStreamProvider = GetMangaDetailStreamFamily._();

final class GetMangaDetailStreamProvider
    extends $FunctionalProvider<AsyncValue<Manga?>, Manga?, Stream<Manga?>>
    with $FutureModifier<Manga?>, $StreamProvider<Manga?> {
  GetMangaDetailStreamProvider._({
    required GetMangaDetailStreamFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getMangaDetailStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMangaDetailStreamHash();

  @override
  String toString() {
    return r'getMangaDetailStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Manga?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Manga?> create(Ref ref) {
    final argument = this.argument as int;
    return getMangaDetailStream(ref, mangaId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMangaDetailStreamHash() =>
    r'03dc6231218ca8c0f8bef31ae9b06270b0d242e9';

final class GetMangaDetailStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Manga?>, int> {
  GetMangaDetailStreamFamily._()
    : super(
        retry: null,
        name: r'getMangaDetailStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMangaDetailStreamProvider call({required int mangaId}) =>
      GetMangaDetailStreamProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'getMangaDetailStreamProvider';
}

@ProviderFor(getChaptersStream)
final getChaptersStreamProvider = GetChaptersStreamFamily._();

final class GetChaptersStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Chapter>>,
          List<Chapter>,
          Stream<List<Chapter>>
        >
    with $FutureModifier<List<Chapter>>, $StreamProvider<List<Chapter>> {
  GetChaptersStreamProvider._({
    required GetChaptersStreamFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getChaptersStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getChaptersStreamHash();

  @override
  String toString() {
    return r'getChaptersStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Chapter>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Chapter>> create(Ref ref) {
    final argument = this.argument as int;
    return getChaptersStream(ref, mangaId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChaptersStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getChaptersStreamHash() => r'c66f2dd4e71b1dce03bdc89986f692f021d2b824';

final class GetChaptersStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Chapter>>, int> {
  GetChaptersStreamFamily._()
    : super(
        retry: null,
        name: r'getChaptersStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetChaptersStreamProvider call({required int mangaId}) =>
      GetChaptersStreamProvider._(argument: mangaId, from: this);

  @override
  String toString() => r'getChaptersStreamProvider';
}
