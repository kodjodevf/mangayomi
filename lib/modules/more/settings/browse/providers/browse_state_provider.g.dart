// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getRepoInfosHash() => r'aae66dfcaadf7f59867fbc599b900862ef1dd3e7';

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

/// See also [getRepoInfos].
@ProviderFor(getRepoInfos)
const getRepoInfosProvider = GetRepoInfosFamily();

/// See also [getRepoInfos].
class GetRepoInfosFamily extends Family<AsyncValue<Repo?>> {
  /// See also [getRepoInfos].
  const GetRepoInfosFamily();

  /// See also [getRepoInfos].
  GetRepoInfosProvider call({
    required String jsonUrl,
  }) {
    return GetRepoInfosProvider(
      jsonUrl: jsonUrl,
    );
  }

  @override
  GetRepoInfosProvider getProviderOverride(
    covariant GetRepoInfosProvider provider,
  ) {
    return call(
      jsonUrl: provider.jsonUrl,
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
  String? get name => r'getRepoInfosProvider';
}

/// See also [getRepoInfos].
class GetRepoInfosProvider extends AutoDisposeFutureProvider<Repo?> {
  /// See also [getRepoInfos].
  GetRepoInfosProvider({
    required String jsonUrl,
  }) : this._internal(
          (ref) => getRepoInfos(
            ref as GetRepoInfosRef,
            jsonUrl: jsonUrl,
          ),
          from: getRepoInfosProvider,
          name: r'getRepoInfosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRepoInfosHash,
          dependencies: GetRepoInfosFamily._dependencies,
          allTransitiveDependencies:
              GetRepoInfosFamily._allTransitiveDependencies,
          jsonUrl: jsonUrl,
        );

  GetRepoInfosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.jsonUrl,
  }) : super.internal();

  final String jsonUrl;

  @override
  Override overrideWith(
    FutureOr<Repo?> Function(GetRepoInfosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRepoInfosProvider._internal(
        (ref) => create(ref as GetRepoInfosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        jsonUrl: jsonUrl,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Repo?> createElement() {
    return _GetRepoInfosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRepoInfosProvider && other.jsonUrl == jsonUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jsonUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetRepoInfosRef on AutoDisposeFutureProviderRef<Repo?> {
  /// The parameter `jsonUrl` of this provider.
  String get jsonUrl;
}

class _GetRepoInfosProviderElement
    extends AutoDisposeFutureProviderElement<Repo?> with GetRepoInfosRef {
  _GetRepoInfosProviderElement(super.provider);

  @override
  String get jsonUrl => (origin as GetRepoInfosProvider).jsonUrl;
}

String _$onlyIncludePinnedSourceStateHash() =>
    r'77c4bff96e186c4bce0a5c312871ceec88a269d0';

/// See also [OnlyIncludePinnedSourceState].
@ProviderFor(OnlyIncludePinnedSourceState)
final onlyIncludePinnedSourceStateProvider =
    AutoDisposeNotifierProvider<OnlyIncludePinnedSourceState, bool>.internal(
  OnlyIncludePinnedSourceState.new,
  name: r'onlyIncludePinnedSourceStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$onlyIncludePinnedSourceStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OnlyIncludePinnedSourceState = AutoDisposeNotifier<bool>;
String _$extensionsRepoStateHash() =>
    r'3ea91c79a9bc24f086fce49de2c61a1e06bad1fe';

abstract class _$ExtensionsRepoState
    extends BuildlessAutoDisposeNotifier<List<Repo>> {
  late final ItemType itemType;

  List<Repo> build(
    ItemType itemType,
  );
}

/// See also [ExtensionsRepoState].
@ProviderFor(ExtensionsRepoState)
const extensionsRepoStateProvider = ExtensionsRepoStateFamily();

/// See also [ExtensionsRepoState].
class ExtensionsRepoStateFamily extends Family<List<Repo>> {
  /// See also [ExtensionsRepoState].
  const ExtensionsRepoStateFamily();

  /// See also [ExtensionsRepoState].
  ExtensionsRepoStateProvider call(
    ItemType itemType,
  ) {
    return ExtensionsRepoStateProvider(
      itemType,
    );
  }

  @override
  ExtensionsRepoStateProvider getProviderOverride(
    covariant ExtensionsRepoStateProvider provider,
  ) {
    return call(
      provider.itemType,
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
  String? get name => r'extensionsRepoStateProvider';
}

/// See also [ExtensionsRepoState].
class ExtensionsRepoStateProvider
    extends AutoDisposeNotifierProviderImpl<ExtensionsRepoState, List<Repo>> {
  /// See also [ExtensionsRepoState].
  ExtensionsRepoStateProvider(
    ItemType itemType,
  ) : this._internal(
          () => ExtensionsRepoState()..itemType = itemType,
          from: extensionsRepoStateProvider,
          name: r'extensionsRepoStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$extensionsRepoStateHash,
          dependencies: ExtensionsRepoStateFamily._dependencies,
          allTransitiveDependencies:
              ExtensionsRepoStateFamily._allTransitiveDependencies,
          itemType: itemType,
        );

  ExtensionsRepoStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
  }) : super.internal();

  final ItemType itemType;

  @override
  List<Repo> runNotifierBuild(
    covariant ExtensionsRepoState notifier,
  ) {
    return notifier.build(
      itemType,
    );
  }

  @override
  Override overrideWith(ExtensionsRepoState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExtensionsRepoStateProvider._internal(
        () => create()..itemType = itemType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ExtensionsRepoState, List<Repo>>
      createElement() {
    return _ExtensionsRepoStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExtensionsRepoStateProvider && other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExtensionsRepoStateRef on AutoDisposeNotifierProviderRef<List<Repo>> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _ExtensionsRepoStateProviderElement
    extends AutoDisposeNotifierProviderElement<ExtensionsRepoState, List<Repo>>
    with ExtensionsRepoStateRef {
  _ExtensionsRepoStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as ExtensionsRepoStateProvider).itemType;
}

String _$autoUpdateExtensionsStateHash() =>
    r'30ce3c558504e005f9c85e2fc969ab7a581510cd';

/// See also [AutoUpdateExtensionsState].
@ProviderFor(AutoUpdateExtensionsState)
final autoUpdateExtensionsStateProvider =
    AutoDisposeNotifierProvider<AutoUpdateExtensionsState, bool>.internal(
  AutoUpdateExtensionsState.new,
  name: r'autoUpdateExtensionsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoUpdateExtensionsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoUpdateExtensionsState = AutoDisposeNotifier<bool>;
String _$checkForExtensionsUpdateStateHash() =>
    r'1b1f22a50e0862a7d643fbe0fcb5d563bd0169c2';

/// See also [CheckForExtensionsUpdateState].
@ProviderFor(CheckForExtensionsUpdateState)
final checkForExtensionsUpdateStateProvider =
    AutoDisposeNotifierProvider<CheckForExtensionsUpdateState, bool>.internal(
  CheckForExtensionsUpdateState.new,
  name: r'checkForExtensionsUpdateStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkForExtensionsUpdateStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CheckForExtensionsUpdateState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
