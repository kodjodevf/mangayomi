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

typedef GetAllHistoryStreamRef = AutoDisposeStreamProviderRef<List<History>>;

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
    required this.isManga,
  }) : super.internal(
          (ref) => getAllHistoryStream(
            ref,
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
        );

  final bool isManga;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
