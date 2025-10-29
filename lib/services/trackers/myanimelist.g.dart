// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyAnimeList)
const myAnimeListProvider = MyAnimeListFamily._();

final class MyAnimeListProvider extends $NotifierProvider<MyAnimeList, void> {
  const MyAnimeListProvider._({
    required MyAnimeListFamily super.from,
    required ({int syncId, ItemType? itemType, WidgetRef widgetRef})
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

String _$myAnimeListHash() => r'6fc4940fbc11af8b3779ecc42bb3845eadc06f0f';

final class MyAnimeListFamily extends $Family
    with
        $ClassFamilyOverride<
          MyAnimeList,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, WidgetRef widgetRef})
        > {
  const MyAnimeListFamily._()
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
    required WidgetRef widgetRef,
  }) => MyAnimeListProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'myAnimeListProvider';
}

abstract class _$MyAnimeList extends $Notifier<void> {
  late final _$args =
      ref.$arg as ({int syncId, ItemType? itemType, WidgetRef widgetRef});
  int get syncId => _$args.syncId;
  ItemType? get itemType => _$args.itemType;
  WidgetRef get widgetRef => _$args.widgetRef;

  void build({
    required int syncId,
    required ItemType? itemType,
    required WidgetRef widgetRef,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    build(
      syncId: _$args.syncId,
      itemType: _$args.itemType,
      widgetRef: _$args.widgetRef,
    );
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
