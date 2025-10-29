// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_item_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchItemSourcesList)
const fetchItemSourcesListProvider = FetchItemSourcesListFamily._();

final class FetchItemSourcesListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const FetchItemSourcesListProvider._({
    required FetchItemSourcesListFamily super.from,
    required ({int? id, bool reFresh, ItemType itemType}) super.argument,
  }) : super(
         retry: null,
         name: r'fetchItemSourcesListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchItemSourcesListHash();

  @override
  String toString() {
    return r'fetchItemSourcesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({int? id, bool reFresh, ItemType itemType});
    return fetchItemSourcesList(
      ref,
      id: argument.id,
      reFresh: argument.reFresh,
      itemType: argument.itemType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchItemSourcesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchItemSourcesListHash() =>
    r'16238be20517fddacf52a2694fbd50cafbfa7496';

final class FetchItemSourcesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({int? id, bool reFresh, ItemType itemType})
        > {
  const FetchItemSourcesListFamily._()
    : super(
        retry: null,
        name: r'fetchItemSourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  FetchItemSourcesListProvider call({
    int? id,
    required bool reFresh,
    required ItemType itemType,
  }) => FetchItemSourcesListProvider._(
    argument: (id: id, reFresh: reFresh, itemType: itemType),
    from: this,
  );

  @override
  String toString() => r'fetchItemSourcesListProvider';
}
