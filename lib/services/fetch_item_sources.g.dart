// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_item_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reads the extension repositories of [itemType], or acts on the one
/// extension [id]: installs it, or installs the update the last read found
/// for it, from where it was found.

@ProviderFor(fetchItemSourcesList)
final fetchItemSourcesListProvider = FetchItemSourcesListFamily._();

/// Reads the extension repositories of [itemType], or acts on the one
/// extension [id]: installs it, or installs the update the last read found
/// for it, from where it was found.

final class FetchItemSourcesListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Reads the extension repositories of [itemType], or acts on the one
  /// extension [id]: installs it, or installs the update the last read found
  /// for it, from where it was found.
  FetchItemSourcesListProvider._({
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
    r'd1cc82483e4bdbf95a4f3327e343a84753e2fa81';

/// Reads the extension repositories of [itemType], or acts on the one
/// extension [id]: installs it, or installs the update the last read found
/// for it, from where it was found.

final class FetchItemSourcesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({int? id, bool reFresh, ItemType itemType})
        > {
  FetchItemSourcesListFamily._()
    : super(
        retry: null,
        name: r'fetchItemSourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Reads the extension repositories of [itemType], or acts on the one
  /// extension [id]: installs it, or installs the update the last read found
  /// for it, from where it was found.

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
