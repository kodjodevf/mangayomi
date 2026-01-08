// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyAnimeList)
final myAnimeListProvider = MyAnimeListFamily._();

final class MyAnimeListProvider extends $NotifierProvider<MyAnimeList, void> {
  MyAnimeListProvider._({
    required MyAnimeListFamily super.from,
    required ({int syncId, ItemType? itemType, dynamic widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'myAnimeListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myAnimeListHash();

  @override
  String toString() {
    return r'myAnimeListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MyAnimeList create() => MyAnimeList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MyAnimeListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myAnimeListHash() => r'2aeddba481f6f97fac7ce2037f6c38f84acf755d';

final class MyAnimeListFamily extends $Family
    with
        $ClassFamilyOverride<
          MyAnimeList,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, dynamic widgetRef})
        > {
  MyAnimeListFamily._()
    : super(
        retry: null,
        name: r'myAnimeListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyAnimeListProvider call({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) => MyAnimeListProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'myAnimeListProvider';
}

abstract class _$MyAnimeList extends $Notifier<void> {
  late final _$args =
      ref.$arg as ({int syncId, ItemType? itemType, dynamic widgetRef});
  int get syncId => _$args.syncId;
  ItemType? get itemType => _$args.itemType;
  dynamic get widgetRef => _$args.widgetRef;

  void build({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        syncId: _$args.syncId,
        itemType: _$args.itemType,
        widgetRef: _$args.widgetRef,
      ),
    );
  }
}
