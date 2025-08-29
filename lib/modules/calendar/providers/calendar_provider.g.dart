// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCalendarStreamHash() => r'850d81742f8ac5ce88175732c0edf57a7a9295d4';

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

/// See also [getCalendarStream].
@ProviderFor(getCalendarStream)
const getCalendarStreamProvider = GetCalendarStreamFamily();

/// See also [getCalendarStream].
class GetCalendarStreamFamily extends Family<AsyncValue<List<Manga>>> {
  /// See also [getCalendarStream].
  const GetCalendarStreamFamily();

  /// See also [getCalendarStream].
  GetCalendarStreamProvider call({ItemType? itemType}) {
    return GetCalendarStreamProvider(itemType: itemType);
  }

  @override
  GetCalendarStreamProvider getProviderOverride(
    covariant GetCalendarStreamProvider provider,
  ) {
    return call(itemType: provider.itemType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getCalendarStreamProvider';
}

/// See also [getCalendarStream].
class GetCalendarStreamProvider extends AutoDisposeStreamProvider<List<Manga>> {
  /// See also [getCalendarStream].
  GetCalendarStreamProvider({ItemType? itemType})
    : this._internal(
        (ref) =>
            getCalendarStream(ref as GetCalendarStreamRef, itemType: itemType),
        from: getCalendarStreamProvider,
        name: r'getCalendarStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getCalendarStreamHash,
        dependencies: GetCalendarStreamFamily._dependencies,
        allTransitiveDependencies:
            GetCalendarStreamFamily._allTransitiveDependencies,
        itemType: itemType,
      );

  GetCalendarStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
  }) : super.internal();

  final ItemType? itemType;

  @override
  Override overrideWith(
    Stream<List<Manga>> Function(GetCalendarStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCalendarStreamProvider._internal(
        (ref) => create(ref as GetCalendarStreamRef),
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
  AutoDisposeStreamProviderElement<List<Manga>> createElement() {
    return _GetCalendarStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCalendarStreamProvider && other.itemType == itemType;
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
mixin GetCalendarStreamRef on AutoDisposeStreamProviderRef<List<Manga>> {
  /// The parameter `itemType` of this provider.
  ItemType? get itemType;
}

class _GetCalendarStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Manga>>
    with GetCalendarStreamRef {
  _GetCalendarStreamProviderElement(super.provider);

  @override
  ItemType? get itemType => (origin as GetCalendarStreamProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
