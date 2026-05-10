// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_to_cbz.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(convertToCBZ)
final convertToCBZProvider = ConvertToCBZFamily._();

final class ConvertToCBZProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  ConvertToCBZProvider._({
    required ConvertToCBZFamily super.from,
    required (String, String, String, List<String>, {ComicInfoData? comicInfo})
    super.argument,
  }) : super(
         retry: null,
         name: r'convertToCBZProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$convertToCBZHash();

  @override
  String toString() {
    return r'convertToCBZProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument =
        this.argument
            as (
              String,
              String,
              String,
              List<String>, {
              ComicInfoData? comicInfo,
            });
    return convertToCBZ(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
      comicInfo: argument.comicInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConvertToCBZProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$convertToCBZHash() => r'0f75969b8eccb5932089e5e269a5bba4012842b8';

final class ConvertToCBZFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<String>>,
          (String, String, String, List<String>, {ComicInfoData? comicInfo})
        > {
  ConvertToCBZFamily._()
    : super(
        retry: null,
        name: r'convertToCBZProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConvertToCBZProvider call(
    String chapterDir,
    String mangaDir,
    String chapterName,
    List<String> pageList, {
    ComicInfoData? comicInfo,
  }) => ConvertToCBZProvider._(
    argument: (
      chapterDir,
      mangaDir,
      chapterName,
      pageList,
      comicInfo: comicInfo,
    ),
    from: this,
  );

  @override
  String toString() => r'convertToCBZProvider';
}
