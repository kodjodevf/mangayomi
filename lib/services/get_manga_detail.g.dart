// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_manga_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailHash() => r'f8a4047fc7d1661b6abdfcfa0786e0d78a20c8ed';

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

typedef GetMangaDetailRef = AutoDisposeFutureProviderRef<GetMangaDetailModel>;

/// See also [getMangaDetail].
@ProviderFor(getMangaDetail)
const getMangaDetailProvider = GetMangaDetailFamily();

/// See also [getMangaDetail].
class GetMangaDetailFamily extends Family<AsyncValue<GetMangaDetailModel>> {
  /// See also [getMangaDetail].
  const GetMangaDetailFamily();

  /// See also [getMangaDetail].
  GetMangaDetailProvider call({
    required String image,
    required String url,
    required String name,
    String lang = '',
    required String source,
  }) {
    return GetMangaDetailProvider(
      image: image,
      url: url,
      name: name,
      lang: lang,
      source: source,
    );
  }

  @override
  GetMangaDetailProvider getProviderOverride(
    covariant GetMangaDetailProvider provider,
  ) {
    return call(
      image: provider.image,
      url: provider.url,
      name: provider.name,
      lang: provider.lang,
      source: provider.source,
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
  String? get name => r'getMangaDetailProvider';
}

/// See also [getMangaDetail].
class GetMangaDetailProvider
    extends AutoDisposeFutureProvider<GetMangaDetailModel> {
  /// See also [getMangaDetail].
  GetMangaDetailProvider({
    required this.image,
    required this.url,
    required this.name,
    this.lang = '',
    required this.source,
  }) : super.internal(
          (ref) => getMangaDetail(
            ref,
            image: image,
            url: url,
            name: name,
            lang: lang,
            source: source,
          ),
          from: getMangaDetailProvider,
          name: r'getMangaDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaDetailHash,
          dependencies: GetMangaDetailFamily._dependencies,
          allTransitiveDependencies:
              GetMangaDetailFamily._allTransitiveDependencies,
        );

  final String image;
  final String url;
  final String name;
  final String lang;
  final String source;

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailProvider &&
        other.image == image &&
        other.url == url &&
        other.name == name &&
        other.lang == lang &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, image.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, name.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
