// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_manga_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailHash() => r'8cc750dd5a207747b8e97db82ce6c1b141c8419a';

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
    required String imageUrl,
    required String url,
    required String title,
    required String lang,
    required String source,
  }) {
    return GetMangaDetailProvider(
      imageUrl: imageUrl,
      url: url,
      title: title,
      lang: lang,
      source: source,
    );
  }

  @override
  GetMangaDetailProvider getProviderOverride(
    covariant GetMangaDetailProvider provider,
  ) {
    return call(
      imageUrl: provider.imageUrl,
      url: provider.url,
      title: provider.title,
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
    required this.imageUrl,
    required this.url,
    required this.title,
    required this.lang,
    required this.source,
  }) : super.internal(
          (ref) => getMangaDetail(
            ref,
            imageUrl: imageUrl,
            url: url,
            title: title,
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

  final String imageUrl;
  final String url;
  final String title;
  final String lang;
  final String source;

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailProvider &&
        other.imageUrl == imageUrl &&
        other.url == url &&
        other.title == title &&
        other.lang == lang &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imageUrl.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
