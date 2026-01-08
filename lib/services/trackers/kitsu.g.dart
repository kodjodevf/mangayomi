// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitsu.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Kitsu)
final kitsuProvider = KitsuFamily._();

final class KitsuProvider extends $NotifierProvider<Kitsu, void> {
  KitsuProvider._({
    required KitsuFamily super.from,
    required ({int syncId, ItemType? itemType, dynamic widgetRef})
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

String _$kitsuHash() => r'8a19aa11f167df8d8cb537f746cc9dc31cad1d49';

final class KitsuFamily extends $Family
    with
        $ClassFamilyOverride<
          Kitsu,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, dynamic widgetRef})
        > {
  KitsuFamily._()
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
    required dynamic widgetRef,
  }) => KitsuProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'kitsuProvider';
}

abstract class _$Kitsu extends $Notifier<void> {
  late final _$args =
      ref.$arg as ({int syncId, ItemType? itemType, dynamic widgetRef});
  int get syncId => _$args.syncId;
  ItemType? get itemType => _$args.itemType;
  dynamic get widgetRef => _$args.widgetRef;

  void build({
    required int syncId,
    ItemType? itemType,
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
