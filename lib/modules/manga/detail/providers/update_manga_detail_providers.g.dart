// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_manga_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updateMangaDetail)
const updateMangaDetailProvider = UpdateMangaDetailFamily._();

final class UpdateMangaDetailProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  const UpdateMangaDetailProvider._({
    required UpdateMangaDetailFamily super.from,
    required ({int? mangaId, bool isInit, bool showToast}) super.argument,
  }) : super(
         retry: null,
         name: r'updateMangaDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateMangaDetailHash();

  @override
  String toString() {
    return r'updateMangaDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    final argument =
        this.argument as ({int? mangaId, bool isInit, bool showToast});
    return updateMangaDetail(
      ref,
      mangaId: argument.mangaId,
      isInit: argument.isInit,
      showToast: argument.showToast,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateMangaDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateMangaDetailHash() => r'ac2b3fcd446d50a81ad647015e3010c2309f3385';

final class UpdateMangaDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<dynamic>,
          ({int? mangaId, bool isInit, bool showToast})
        > {
  const UpdateMangaDetailFamily._()
    : super(
        retry: null,
        name: r'updateMangaDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateMangaDetailProvider call({
    required int? mangaId,
    required bool isInit,
    bool showToast = true,
  }) => UpdateMangaDetailProvider._(
    argument: (mangaId: mangaId, isInit: isInit, showToast: showToast),
    from: this,
  );

  @override
  String toString() => r'updateMangaDetailProvider';
}
