// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitsu.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Kitsu)
const kitsuProvider = KitsuFamily._();

final class KitsuProvider extends $NotifierProvider<Kitsu, void> {
  const KitsuProvider._({
    required KitsuFamily super.from,
    required ({int syncId, ItemType? itemType, WidgetRef widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'kitsuProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kitsuHash();

  @override
  String toString() {
    return r'kitsuProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Kitsu create() => Kitsu();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KitsuProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kitsuHash() => r'ae5836feaaa4f95953f4890be2084cd1f7a3a412';

final class KitsuFamily extends $Family
    with
        $ClassFamilyOverride<
          Kitsu,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, WidgetRef widgetRef})
        > {
  const KitsuFamily._()
    : super(
        retry: null,
        name: r'kitsuProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  KitsuProvider call({
    required int syncId,
    ItemType? itemType,
    required WidgetRef widgetRef,
  }) => KitsuProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'kitsuProvider';
}

abstract class _$Kitsu extends $Notifier<void> {
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
