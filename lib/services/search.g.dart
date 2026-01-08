// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(search)
final searchProvider = SearchFamily._();

final class SearchProvider
    extends $FunctionalProvider<AsyncValue<MPages?>, MPages?, FutureOr<MPages?>>
    with $FutureModifier<MPages?>, $FutureProvider<MPages?> {
  SearchProvider._({
    required SearchFamily super.from,
    required ({Source source, String query, int page, List<dynamic> filterList})
    super.argument,
  }) : super(
         retry: null,
         name: r'searchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchHash();

  @override
  String toString() {
    return r'searchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MPages?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MPages?> create(Ref ref) {
    final argument =
        this.argument
            as ({
              Source source,
              String query,
              int page,
              List<dynamic> filterList,
            });
    return search(
      ref,
      source: argument.source,
      query: argument.query,
      page: argument.page,
      filterList: argument.filterList,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchHash() => r'03bfee6172b386c53aee05fe2429a10ce5915b18';

final class SearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MPages?>,
          ({Source source, String query, int page, List<dynamic> filterList})
        > {
  SearchFamily._()
    : super(
        retry: null,
        name: r'searchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchProvider call({
    required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList,
  }) => SearchProvider._(
    argument: (
      source: source,
      query: query,
      page: page,
      filterList: filterList,
    ),
    from: this,
  );

  @override
  String toString() => r'searchProvider';
}
