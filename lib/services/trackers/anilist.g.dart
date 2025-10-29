// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anilist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Anilist)
const anilistProvider = AnilistFamily._();

final class AnilistProvider extends $NotifierProvider<Anilist, void> {
  const AnilistProvider._({
    required AnilistFamily super.from,
    required ({int syncId, ItemType? itemType, WidgetRef widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'anilistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$anilistHash();

  @override
  String toString() {
    return r'anilistProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Anilist create() => Anilist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnilistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$anilistHash() => r'2d34818d1f8c58455b0081d4ae707cff160ea91d';

final class AnilistFamily extends $Family
    with
        $ClassFamilyOverride<
          Anilist,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, WidgetRef widgetRef})
        > {
  const AnilistFamily._()
    : super(
        retry: null,
        name: r'anilistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnilistProvider call({
    required int syncId,
    ItemType? itemType,
    required WidgetRef widgetRef,
  }) => AnilistProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'anilistProvider';
}

abstract class _$Anilist extends $Notifier<void> {
  late final _$args =
      ref.$arg as ({int syncId, ItemType? itemType, WidgetRef widgetRef});
  int get syncId => _$args.syncId;
  ItemType? get itemType => _$args.itemType;
  WidgetRef get widgetRef => _$args.widgetRef;

  void build({
    required int syncId,
    ItemType? itemType,
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
