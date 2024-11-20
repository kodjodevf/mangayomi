// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kitsu.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kitsuHash() => r'6953b7520cc144f42992bbecc0d5306841c2382f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Kitsu extends BuildlessAutoDisposeNotifier<void> {
  late final int syncId;
  late final bool? isManga;

  void build({
    required int syncId,
    bool? isManga,
  });
}

/// See also [Kitsu].
@ProviderFor(Kitsu)
const kitsuProvider = KitsuFamily();

/// See also [Kitsu].
class KitsuFamily extends Family<void> {
  /// See also [Kitsu].
  const KitsuFamily();

  /// See also [Kitsu].
  KitsuProvider call({
    required int syncId,
    bool? isManga,
  }) {
    return KitsuProvider(
      syncId: syncId,
      isManga: isManga,
    );
  }

  @override
  KitsuProvider getProviderOverride(
    covariant KitsuProvider provider,
  ) {
    return call(
      syncId: provider.syncId,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'kitsuProvider';
}

/// See also [Kitsu].
class KitsuProvider extends AutoDisposeNotifierProviderImpl<Kitsu, void> {
  /// See also [Kitsu].
  KitsuProvider({
    required int syncId,
    bool? isManga,
  }) : this._internal(
          () => Kitsu()
            ..syncId = syncId
            ..isManga = isManga,
          from: kitsuProvider,
          name: r'kitsuProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$kitsuHash,
          dependencies: KitsuFamily._dependencies,
          allTransitiveDependencies: KitsuFamily._allTransitiveDependencies,
          syncId: syncId,
          isManga: isManga,
        );

  KitsuProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.syncId,
    required this.isManga,
  }) : super.internal();

  final int syncId;
  final bool? isManga;

  @override
  void runNotifierBuild(
    covariant Kitsu notifier,
  ) {
    return notifier.build(
      syncId: syncId,
      isManga: isManga,
    );
  }

  @override
  Override overrideWith(Kitsu Function() create) {
    return ProviderOverride(
      origin: this,
      override: KitsuProvider._internal(
        () => create()
          ..syncId = syncId
          ..isManga = isManga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        syncId: syncId,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Kitsu, void> createElement() {
    return _KitsuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KitsuProvider &&
        other.syncId == syncId &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KitsuRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `syncId` of this provider.
  int get syncId;

  /// The parameter `isManga` of this provider.
  bool? get isManga;
}

class _KitsuProviderElement
    extends AutoDisposeNotifierProviderElement<Kitsu, void> with KitsuRef {
  _KitsuProviderElement(super.provider);

  @override
  int get syncId => (origin as KitsuProvider).syncId;
  @override
  bool? get isManga => (origin as KitsuProvider).isManga;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
