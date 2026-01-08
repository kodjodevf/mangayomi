// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simkl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Simkl)
final simklProvider = SimklFamily._();

final class SimklProvider extends $NotifierProvider<Simkl, void> {
  SimklProvider._({
    required SimklFamily super.from,
    required ({int syncId, ItemType? itemType, dynamic widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'simklProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$simklHash();

  @override
  String toString() {
    return r'simklProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  Simkl create() => Simkl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SimklProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$simklHash() => r'a5311b207d0bfb5b34911633ee73d5d77ebde6cf';

final class SimklFamily extends $Family
    with
        $ClassFamilyOverride<
          Simkl,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, dynamic widgetRef})
        > {
  SimklFamily._()
    : super(
        retry: null,
        name: r'simklProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SimklProvider call({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) => SimklProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'simklProvider';
}

abstract class _$Simkl extends $Notifier<void> {
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
