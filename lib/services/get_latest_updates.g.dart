// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_latest_updates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getLatestUpdatesHash() => r'fd4ece1d796e079a469e5f80f456ee821ff0bc03';

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

/// See also [getLatestUpdates].
@ProviderFor(getLatestUpdates)
const getLatestUpdatesProvider = GetLatestUpdatesFamily();

/// See also [getLatestUpdates].
class GetLatestUpdatesFamily extends Family<AsyncValue<MPages?>> {
  /// See also [getLatestUpdates].
  const GetLatestUpdatesFamily();

  /// See also [getLatestUpdates].
  GetLatestUpdatesProvider call({required Source source, required int page}) {
    return GetLatestUpdatesProvider(source: source, page: page);
  }

  @override
  GetLatestUpdatesProvider getProviderOverride(
    covariant GetLatestUpdatesProvider provider,
  ) {
    return call(source: provider.source, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getLatestUpdatesProvider';
}

/// See also [getLatestUpdates].
class GetLatestUpdatesProvider extends AutoDisposeFutureProvider<MPages?> {
  /// See also [getLatestUpdates].
  GetLatestUpdatesProvider({required Source source, required int page})
    : this._internal(
        (ref) => getLatestUpdates(
          ref as GetLatestUpdatesRef,
          source: source,
          page: page,
        ),
        from: getLatestUpdatesProvider,
        name: r'getLatestUpdatesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getLatestUpdatesHash,
        dependencies: GetLatestUpdatesFamily._dependencies,
        allTransitiveDependencies:
            GetLatestUpdatesFamily._allTransitiveDependencies,
        source: source,
        page: page,
      );

  GetLatestUpdatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.page,
  }) : super.internal();

  final Source source;
  final int page;

  @override
  Override overrideWith(
    FutureOr<MPages?> Function(GetLatestUpdatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLatestUpdatesProvider._internal(
        (ref) => create(ref as GetLatestUpdatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MPages?> createElement() {
    return _GetLatestUpdatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLatestUpdatesProvider &&
        other.source == source &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetLatestUpdatesRef on AutoDisposeFutureProviderRef<MPages?> {
  /// The parameter `source` of this provider.
  Source get source;

  /// The parameter `page` of this provider.
  int get page;
}

class _GetLatestUpdatesProviderElement
    extends AutoDisposeFutureProviderElement<MPages?>
    with GetLatestUpdatesRef {
  _GetLatestUpdatesProviderElement(super.provider);

  @override
  Source get source => (origin as GetLatestUpdatesProvider).source;
  @override
  int get page => (origin as GetLatestUpdatesProvider).page;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
