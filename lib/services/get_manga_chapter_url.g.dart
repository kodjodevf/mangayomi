// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_manga_chapter_url.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaChapterUrlHash() =>
    r'bb23f4789336a4970dddaaf61707998a9c79bcb5';

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

typedef GetMangaChapterUrlRef
    = AutoDisposeFutureProviderRef<GetMangaChapterUrlModel>;

/// See also [getMangaChapterUrl].
@ProviderFor(getMangaChapterUrl)
const getMangaChapterUrlProvider = GetMangaChapterUrlFamily();

/// See also [getMangaChapterUrl].
class GetMangaChapterUrlFamily
    extends Family<AsyncValue<GetMangaChapterUrlModel>> {
  /// See also [getMangaChapterUrl].
  const GetMangaChapterUrlFamily();

  /// See also [getMangaChapterUrl].
  GetMangaChapterUrlProvider call({
    required Chapter chapter,
  }) {
    return GetMangaChapterUrlProvider(
      chapter: chapter,
    );
  }

  @override
  GetMangaChapterUrlProvider getProviderOverride(
    covariant GetMangaChapterUrlProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
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
  String? get name => r'getMangaChapterUrlProvider';
}

/// See also [getMangaChapterUrl].
class GetMangaChapterUrlProvider
    extends AutoDisposeFutureProvider<GetMangaChapterUrlModel> {
  /// See also [getMangaChapterUrl].
  GetMangaChapterUrlProvider({
    required this.chapter,
  }) : super.internal(
          (ref) => getMangaChapterUrl(
            ref,
            chapter: chapter,
          ),
          from: getMangaChapterUrlProvider,
          name: r'getMangaChapterUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaChapterUrlHash,
          dependencies: GetMangaChapterUrlFamily._dependencies,
          allTransitiveDependencies:
              GetMangaChapterUrlFamily._allTransitiveDependencies,
        );

  final Chapter chapter;

  @override
  bool operator ==(Object other) {
    return other is GetMangaChapterUrlProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
