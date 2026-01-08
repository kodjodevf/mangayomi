// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_reader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mangaReader)
final mangaReaderProvider = MangaReaderFamily._();

final class MangaReaderProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChapterWithPages>,
          ChapterWithPages,
          FutureOr<ChapterWithPages>
        >
    with $FutureModifier<ChapterWithPages>, $FutureProvider<ChapterWithPages> {
  MangaReaderProvider._({
    required MangaReaderFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'mangaReaderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaReaderHash();

  @override
  String toString() {
    return r'mangaReaderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ChapterWithPages> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChapterWithPages> create(Ref ref) {
    final argument = this.argument as int;
    return mangaReader(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaReaderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaReaderHash() => r'cf8c44c6c3567ba4e9a0e08137ab2f29b71307eb';

final class MangaReaderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ChapterWithPages>, int> {
  MangaReaderFamily._()
    : super(
        retry: null,
        name: r'mangaReaderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaReaderProvider call(int chapterId) =>
      MangaReaderProvider._(argument: chapterId, from: this);

  @override
  String toString() => r'mangaReaderProvider';
}
