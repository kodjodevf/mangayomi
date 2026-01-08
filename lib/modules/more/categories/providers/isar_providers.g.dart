// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMangaCategorieStream)
final getMangaCategorieStreamProvider = GetMangaCategorieStreamFamily._();

final class GetMangaCategorieStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  GetMangaCategorieStreamProvider._({
    required GetMangaCategorieStreamFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'getMangaCategorieStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMangaCategorieStreamHash();

  @override
  String toString() {
    return r'getMangaCategorieStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    final argument = this.argument as ItemType;
    return getMangaCategorieStream(ref, itemType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMangaCategorieStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMangaCategorieStreamHash() =>
    r'1dcf15018a6467eef7a26c1728b9e531ebd984d0';

final class GetMangaCategorieStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Category>>, ItemType> {
  GetMangaCategorieStreamFamily._()
    : super(
        retry: null,
        name: r'getMangaCategorieStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMangaCategorieStreamProvider call({required ItemType itemType}) =>
      GetMangaCategorieStreamProvider._(argument: itemType, from: this);

  @override
  String toString() => r'getMangaCategorieStreamProvider';
}
