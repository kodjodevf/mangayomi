// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllMangaStreamHash() => r'880357b7617f6592cd453186336b8114982a081b';

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

typedef GetAllMangaStreamRef = AutoDisposeStreamProviderRef<List<Manga>>;

/// See also [getAllMangaStream].
@ProviderFor(getAllMangaStream)
const getAllMangaStreamProvider = GetAllMangaStreamFamily();

/// See also [getAllMangaStream].
class GetAllMangaStreamFamily extends Family<AsyncValue<List<Manga>>> {
  /// See also [getAllMangaStream].
  const GetAllMangaStreamFamily();

  /// See also [getAllMangaStream].
  GetAllMangaStreamProvider call({
    required int? categoryId,
  }) {
    return GetAllMangaStreamProvider(
      categoryId: categoryId,
    );
  }

  @override
  GetAllMangaStreamProvider getProviderOverride(
    covariant GetAllMangaStreamProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
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
  String? get name => r'getAllMangaStreamProvider';
}

/// See also [getAllMangaStream].
class GetAllMangaStreamProvider extends AutoDisposeStreamProvider<List<Manga>> {
  /// See also [getAllMangaStream].
  GetAllMangaStreamProvider({
    required this.categoryId,
  }) : super.internal(
          (ref) => getAllMangaStream(
            ref,
            categoryId: categoryId,
          ),
          from: getAllMangaStreamProvider,
          name: r'getAllMangaStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllMangaStreamHash,
          dependencies: GetAllMangaStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllMangaStreamFamily._allTransitiveDependencies,
        );

  final int? categoryId;

  @override
  bool operator ==(Object other) {
    return other is GetAllMangaStreamProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
