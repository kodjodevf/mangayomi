// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chapter_url.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChapterUrlHash() => r'46fc82b7ddeb8f6f1658dbc942db69f651505aad';

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

typedef GetChapterUrlRef = AutoDisposeFutureProviderRef<GetChapterUrlModel>;

/// See also [getChapterUrl].
@ProviderFor(getChapterUrl)
const getChapterUrlProvider = GetChapterUrlFamily();

/// See also [getChapterUrl].
class GetChapterUrlFamily extends Family<AsyncValue<GetChapterUrlModel>> {
  /// See also [getChapterUrl].
  const GetChapterUrlFamily();

  /// See also [getChapterUrl].
  GetChapterUrlProvider call({
    required Chapter chapter,
  }) {
    return GetChapterUrlProvider(
      chapter: chapter,
    );
  }

  @override
  GetChapterUrlProvider getProviderOverride(
    covariant GetChapterUrlProvider provider,
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
  String? get name => r'getChapterUrlProvider';
}

/// See also [getChapterUrl].
class GetChapterUrlProvider
    extends AutoDisposeFutureProvider<GetChapterUrlModel> {
  /// See also [getChapterUrl].
  GetChapterUrlProvider({
    required this.chapter,
  }) : super.internal(
          (ref) => getChapterUrl(
            ref,
            chapter: chapter,
          ),
          from: getChapterUrlProvider,
          name: r'getChapterUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChapterUrlHash,
          dependencies: GetChapterUrlFamily._dependencies,
          allTransitiveDependencies:
              GetChapterUrlFamily._allTransitiveDependencies,
        );

  final Chapter chapter;

  @override
  bool operator ==(Object other) {
    return other is GetChapterUrlProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
