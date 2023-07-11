// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchSourcesListHash() => r'151bfddc9daf2cde079bf0f98f523d92b7e6ab00';

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

typedef FetchSourcesListRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [fetchSourcesList].
@ProviderFor(fetchSourcesList)
const fetchSourcesListProvider = FetchSourcesListFamily();

/// See also [fetchSourcesList].
class FetchSourcesListFamily extends Family<AsyncValue<dynamic>> {
  /// See also [fetchSourcesList].
  const FetchSourcesListFamily();

  /// See also [fetchSourcesList].
  FetchSourcesListProvider call({
    int? id,
  }) {
    return FetchSourcesListProvider(
      id: id,
    );
  }

  @override
  FetchSourcesListProvider getProviderOverride(
    covariant FetchSourcesListProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'fetchSourcesListProvider';
}

/// See also [fetchSourcesList].
class FetchSourcesListProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [fetchSourcesList].
  FetchSourcesListProvider({
    this.id,
  }) : super.internal(
          (ref) => fetchSourcesList(
            ref,
            id: id,
          ),
          from: fetchSourcesListProvider,
          name: r'fetchSourcesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchSourcesListHash,
          dependencies: FetchSourcesListFamily._dependencies,
          allTransitiveDependencies:
              FetchSourcesListFamily._allTransitiveDependencies,
        );

  final int? id;

  @override
  bool operator ==(Object other) {
    return other is FetchSourcesListProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
