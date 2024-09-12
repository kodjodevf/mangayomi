// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllHistoryStreamHash() =>
    r'32dc5fa16315f199a5c86ee99cf59b7190c4d28e';

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

/// See also [getAllHistoryStream].
@ProviderFor(getAllHistoryStream)
const getAllHistoryStreamProvider = GetAllHistoryStreamFamily();

/// See also [getAllHistoryStream].
class GetAllHistoryStreamFamily extends Family<AsyncValue<List<History>>> {
  /// See also [getAllHistoryStream].
  const GetAllHistoryStreamFamily();

  /// See also [getAllHistoryStream].
  GetAllHistoryStreamProvider call({
    required bool isManga,
  }) {
    return GetAllHistoryStreamProvider(
      isManga: isManga,
    );
  }

  @override
  GetAllHistoryStreamProvider getProviderOverride(
    covariant GetAllHistoryStreamProvider provider,
  ) {
    return call(
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
  String? get name => r'getAllHistoryStreamProvider';
}

/// See also [getAllHistoryStream].
class GetAllHistoryStreamProvider
    extends AutoDisposeStreamProvider<List<History>> {
  /// See also [getAllHistoryStream].
  GetAllHistoryStreamProvider({
    required bool isManga,
  }) : this._internal(
          (ref) => getAllHistoryStream(
            ref as GetAllHistoryStreamRef,
            isManga: isManga,
          ),
          from: getAllHistoryStreamProvider,
          name: r'getAllHistoryStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllHistoryStreamHash,
          dependencies: GetAllHistoryStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllHistoryStreamFamily._allTransitiveDependencies,
          isManga: isManga,
        );

  GetAllHistoryStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
  }) : super.internal();

  final bool isManga;

  @override
  Override overrideWith(
    Stream<List<History>> Function(GetAllHistoryStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllHistoryStreamProvider._internal(
        (ref) => create(ref as GetAllHistoryStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<History>> createElement() {
    return _GetAllHistoryStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllHistoryStreamProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetAllHistoryStreamRef on AutoDisposeStreamProviderRef<List<History>> {
  /// The parameter `isManga` of this provider.
  bool get isManga;
}

class _GetAllHistoryStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<History>>
    with GetAllHistoryStreamRef {
  _GetAllHistoryStreamProviderElement(super.provider);

  @override
  bool get isManga => (origin as GetAllHistoryStreamProvider).isManga;
}

String _$getAllFeedStreamHash() => r'3d60bca5377bf6fc2aee36e7bec5b319b2377add';

/// See also [getAllFeedStream].
@ProviderFor(getAllFeedStream)
const getAllFeedStreamProvider = GetAllFeedStreamFamily();

/// See also [getAllFeedStream].
class GetAllFeedStreamFamily extends Family<AsyncValue<List<Feed>>> {
  /// See also [getAllFeedStream].
  const GetAllFeedStreamFamily();

  /// See also [getAllFeedStream].
  GetAllFeedStreamProvider call({
    required bool isManga,
  }) {
    return GetAllFeedStreamProvider(
      isManga: isManga,
    );
  }

  @override
  GetAllFeedStreamProvider getProviderOverride(
    covariant GetAllFeedStreamProvider provider,
  ) {
    return call(
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
  String? get name => r'getAllFeedStreamProvider';
}

/// See also [getAllFeedStream].
class GetAllFeedStreamProvider extends AutoDisposeStreamProvider<List<Feed>> {
  /// See also [getAllFeedStream].
  GetAllFeedStreamProvider({
    required bool isManga,
  }) : this._internal(
          (ref) => getAllFeedStream(
            ref as GetAllFeedStreamRef,
            isManga: isManga,
          ),
          from: getAllFeedStreamProvider,
          name: r'getAllFeedStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllFeedStreamHash,
          dependencies: GetAllFeedStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllFeedStreamFamily._allTransitiveDependencies,
          isManga: isManga,
        );

  GetAllFeedStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
  }) : super.internal();

  final bool isManga;

  @override
  Override overrideWith(
    Stream<List<Feed>> Function(GetAllFeedStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllFeedStreamProvider._internal(
        (ref) => create(ref as GetAllFeedStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Feed>> createElement() {
    return _GetAllFeedStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllFeedStreamProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetAllFeedStreamRef on AutoDisposeStreamProviderRef<List<Feed>> {
  /// The parameter `isManga` of this provider.
  bool get isManga;
}

class _GetAllFeedStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Feed>>
    with GetAllFeedStreamRef {
  _GetAllFeedStreamProviderElement(super.provider);

  @override
  bool get isManga => (origin as GetAllFeedStreamProvider).isManga;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
