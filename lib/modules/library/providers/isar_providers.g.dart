// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllMangaStream)
final getAllMangaStreamProvider = GetAllMangaStreamFamily._();

final class GetAllMangaStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manga>>,
          List<Manga>,
          Stream<List<Manga>>
        >
    with $FutureModifier<List<Manga>>, $StreamProvider<List<Manga>> {
  GetAllMangaStreamProvider._({
    required GetAllMangaStreamFamily super.from,
    required ({int? categoryId, ItemType itemType}) super.argument,
  }) : super(
         retry: null,
         name: r'getAllMangaStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAllMangaStreamHash();

  @override
  String toString() {
    return r'getAllMangaStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Manga>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Manga>> create(Ref ref) {
    final argument = this.argument as ({int? categoryId, ItemType itemType});
    return getAllMangaStream(
      ref,
      categoryId: argument.categoryId,
      itemType: argument.itemType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllMangaStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAllMangaStreamHash() => r'95240271805b7dc64e47c37b7e6fcf5d06d32cab';

final class GetAllMangaStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<Manga>>,
          ({int? categoryId, ItemType itemType})
        > {
  GetAllMangaStreamFamily._()
    : super(
        retry: null,
        name: r'getAllMangaStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAllMangaStreamProvider call({
    required int? categoryId,
    required ItemType itemType,
  }) => GetAllMangaStreamProvider._(
    argument: (categoryId: categoryId, itemType: itemType),
    from: this,
  );

  @override
  String toString() => r'getAllMangaStreamProvider';
}

@ProviderFor(getAllMangaWithoutCategoriesStream)
final getAllMangaWithoutCategoriesStreamProvider =
    GetAllMangaWithoutCategoriesStreamFamily._();

final class GetAllMangaWithoutCategoriesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manga>>,
          List<Manga>,
          Stream<List<Manga>>
        >
    with $FutureModifier<List<Manga>>, $StreamProvider<List<Manga>> {
  GetAllMangaWithoutCategoriesStreamProvider._({
    required GetAllMangaWithoutCategoriesStreamFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'getAllMangaWithoutCategoriesStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$getAllMangaWithoutCategoriesStreamHash();

  @override
  String toString() {
    return r'getAllMangaWithoutCategoriesStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Manga>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Manga>> create(Ref ref) {
    final argument = this.argument as ItemType;
    return getAllMangaWithoutCategoriesStream(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllMangaWithoutCategoriesStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAllMangaWithoutCategoriesStreamHash() =>
    r'7e22e4f7c5ebe653eb6b40e85d1bf7fedc86e2cb';

final class GetAllMangaWithoutCategoriesStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Manga>>, ItemType> {
  GetAllMangaWithoutCategoriesStreamFamily._()
    : super(
        retry: null,
        name: r'getAllMangaWithoutCategoriesStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAllMangaWithoutCategoriesStreamProvider call({
    required ItemType itemType,
  }) => GetAllMangaWithoutCategoriesStreamProvider._(
    argument: itemType,
    from: this,
  );

  @override
  String toString() => r'getAllMangaWithoutCategoriesStreamProvider';
}

@ProviderFor(getSettingsStream)
final getSettingsStreamProvider = GetSettingsStreamProvider._();

final class GetSettingsStreamProvider
    extends
        $FunctionalProvider<AsyncValue<Settings>, Settings, Stream<Settings>>
    with $FutureModifier<Settings>, $StreamProvider<Settings> {
  GetSettingsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSettingsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSettingsStreamHash();

  @$internal
  @override
  $StreamProviderElement<Settings> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Settings> create(Ref ref) {
    return getSettingsStream(ref);
  }
}

String _$getSettingsStreamHash() => r'bbd743d60324ae71865df45d563399f8189de8f1';
