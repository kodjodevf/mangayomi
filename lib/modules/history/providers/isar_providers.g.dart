// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getAllHistoryStream)
final getAllHistoryStreamProvider = GetAllHistoryStreamFamily._();

final class GetAllHistoryStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<History>>,
          List<History>,
          Stream<List<History>>
        >
    with $FutureModifier<List<History>>, $StreamProvider<List<History>> {
  GetAllHistoryStreamProvider._({
    required GetAllHistoryStreamFamily super.from,
    required ({ItemType itemType, String search}) super.argument,
  }) : super(
         retry: null,
         name: r'getAllHistoryStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAllHistoryStreamHash();

  @override
  String toString() {
    return r'getAllHistoryStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<History>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<History>> create(Ref ref) {
    final argument = this.argument as ({ItemType itemType, String search});
    return getAllHistoryStream(
      ref,
      itemType: argument.itemType,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllHistoryStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAllHistoryStreamHash() =>
    r'1ce5bd0046fbbec46e91b7a486523945699d95f3';

final class GetAllHistoryStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<History>>,
          ({ItemType itemType, String search})
        > {
  GetAllHistoryStreamFamily._()
    : super(
        retry: null,
        name: r'getAllHistoryStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAllHistoryStreamProvider call({
    required ItemType itemType,
    String search = '',
  }) => GetAllHistoryStreamProvider._(
    argument: (itemType: itemType, search: search),
    from: this,
  );

  @override
  String toString() => r'getAllHistoryStreamProvider';
}

@ProviderFor(getAllUpdateStream)
final getAllUpdateStreamProvider = GetAllUpdateStreamFamily._();

final class GetAllUpdateStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Update>>,
          List<Update>,
          Stream<List<Update>>
        >
    with $FutureModifier<List<Update>>, $StreamProvider<List<Update>> {
  GetAllUpdateStreamProvider._({
    required GetAllUpdateStreamFamily super.from,
    required ({ItemType itemType, String search}) super.argument,
  }) : super(
         retry: null,
         name: r'getAllUpdateStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAllUpdateStreamHash();

  @override
  String toString() {
    return r'getAllUpdateStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<Update>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Update>> create(Ref ref) {
    final argument = this.argument as ({ItemType itemType, String search});
    return getAllUpdateStream(
      ref,
      itemType: argument.itemType,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllUpdateStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAllUpdateStreamHash() =>
    r'43369b20d702d12aeae627fcd04ceb61caf0dc74';

final class GetAllUpdateStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<Update>>,
          ({ItemType itemType, String search})
        > {
  GetAllUpdateStreamFamily._()
    : super(
        retry: null,
        name: r'getAllUpdateStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAllUpdateStreamProvider call({
    required ItemType itemType,
    String search = '',
  }) => GetAllUpdateStreamProvider._(
    argument: (itemType: itemType, search: search),
    from: this,
  );

  @override
  String toString() => r'getAllUpdateStreamProvider';
}
