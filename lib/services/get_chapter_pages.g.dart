// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chapter_pages.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getChapterPages)
final getChapterPagesProvider = GetChapterPagesFamily._();

final class GetChapterPagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetChapterPagesModel>,
          GetChapterPagesModel,
          FutureOr<GetChapterPagesModel>
        >
    with
        $FutureModifier<GetChapterPagesModel>,
        $FutureProvider<GetChapterPagesModel> {
  GetChapterPagesProvider._({
    required GetChapterPagesFamily super.from,
    required Chapter super.argument,
  }) : super(
         retry: null,
         name: r'getChapterPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getChapterPagesHash();

  @override
  String toString() {
    return r'getChapterPagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GetChapterPagesModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetChapterPagesModel> create(Ref ref) {
    final argument = this.argument as Chapter;
    return getChapterPages(ref, chapter: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChapterPagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getChapterPagesHash() => r'544311ac02b1034b938bb5f85e97fe34683c26c7';

final class GetChapterPagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GetChapterPagesModel>, Chapter> {
  GetChapterPagesFamily._()
    : super(
        retry: null,
        name: r'getChapterPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetChapterPagesProvider call({required Chapter chapter}) =>
      GetChapterPagesProvider._(argument: chapter, from: this);

  @override
  String toString() => r'getChapterPagesProvider';
}
