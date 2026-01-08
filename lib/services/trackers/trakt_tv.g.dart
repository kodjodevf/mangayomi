// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trakt_tv.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TraktTv)
final traktTvProvider = TraktTvFamily._();

final class TraktTvProvider extends $NotifierProvider<TraktTv, void> {
  TraktTvProvider._({
    required TraktTvFamily super.from,
    required ({int syncId, ItemType? itemType, dynamic widgetRef})
    super.argument,
  }) : super(
         retry: null,
         name: r'traktTvProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$traktTvHash();

  @override
  String toString() {
    return r'traktTvProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TraktTv create() => TraktTv();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TraktTvProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$traktTvHash() => r'6843c07d55eb4daec6fd99a14037d2cefd51f8de';

final class TraktTvFamily extends $Family
    with
        $ClassFamilyOverride<
          TraktTv,
          void,
          void,
          void,
          ({int syncId, ItemType? itemType, dynamic widgetRef})
        > {
  TraktTvFamily._()
    : super(
        retry: null,
        name: r'traktTvProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TraktTvProvider call({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) => TraktTvProvider._(
    argument: (syncId: syncId, itemType: itemType, widgetRef: widgetRef),
    from: this,
  );

  @override
  String toString() => r'traktTvProvider';
}

abstract class _$TraktTv extends $Notifier<void> {
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
