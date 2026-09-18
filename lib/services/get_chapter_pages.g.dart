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
    required ({Chapter chapter, bool forceRefresh}) super.argument,
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
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GetChapterPagesModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetChapterPagesModel> create(Ref ref) {
    final argument = this.argument as ({Chapter chapter, bool forceRefresh});
    return getChapterPages(
      ref,
      chapter: argument.chapter,
      forceRefresh: argument.forceRefresh,
    );
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

String _$getChapterPagesHash() => r'a66f484ee4dffced26bd6e94138fd22f0d1988b3';

final class GetChapterPagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GetChapterPagesModel>,
          ({Chapter chapter, bool forceRefresh})
        > {
  GetChapterPagesFamily._()
    : super(
        retry: null,
        name: r'getChapterPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetChapterPagesProvider call({
    required Chapter chapter,
    bool forceRefresh = false,
  }) => GetChapterPagesProvider._(
    argument: (chapter: chapter, forceRefresh: forceRefresh),
    from: this,
  );

  @override
  String toString() => r'getChapterPagesProvider';
}
