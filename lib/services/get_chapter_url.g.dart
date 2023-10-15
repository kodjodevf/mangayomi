// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chapter_url.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChapterUrlHash() => r'd3836616473c773e79c4b09258fbb7c127a60202';

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
    required Chapter chapter,
  }) : this._internal(
          (ref) => getChapterUrl(
            ref as GetChapterUrlRef,
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
          chapter: chapter,
        );

  GetChapterUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  Override overrideWith(
    FutureOr<GetChapterUrlModel> Function(GetChapterUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChapterUrlProvider._internal(
        (ref) => create(ref as GetChapterUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GetChapterUrlModel> createElement() {
    return _GetChapterUrlProviderElement(this);
  }

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

mixin GetChapterUrlRef on AutoDisposeFutureProviderRef<GetChapterUrlModel> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _GetChapterUrlProviderElement
    extends AutoDisposeFutureProviderElement<GetChapterUrlModel>
    with GetChapterUrlRef {
  _GetChapterUrlProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as GetChapterUrlProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
