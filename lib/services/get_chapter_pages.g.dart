// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_chapter_pages.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getChapterPagesHash() => r'08f56022f03c4834c69c50d0020007fa8b26c091';

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

/// See also [getChapterPages].
@ProviderFor(getChapterPages)
const getChapterPagesProvider = GetChapterPagesFamily();

/// See also [getChapterPages].
class GetChapterPagesFamily extends Family<AsyncValue<GetChapterPagesModel>> {
  /// See also [getChapterPages].
  const GetChapterPagesFamily();

  /// See also [getChapterPages].
  GetChapterPagesProvider call({
    required Chapter chapter,
  }) {
    return GetChapterPagesProvider(
      chapter: chapter,
    );
  }

  @override
  GetChapterPagesProvider getProviderOverride(
    covariant GetChapterPagesProvider provider,
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
  String? get name => r'getChapterPagesProvider';
}

/// See also [getChapterPages].
class GetChapterPagesProvider
    extends AutoDisposeFutureProvider<GetChapterPagesModel> {
  /// See also [getChapterPages].
  GetChapterPagesProvider({
    required Chapter chapter,
  }) : this._internal(
          (ref) => getChapterPages(
            ref as GetChapterPagesRef,
            chapter: chapter,
          ),
          from: getChapterPagesProvider,
          name: r'getChapterPagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChapterPagesHash,
          dependencies: GetChapterPagesFamily._dependencies,
          allTransitiveDependencies:
              GetChapterPagesFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  GetChapterPagesProvider._internal(
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
    FutureOr<GetChapterPagesModel> Function(GetChapterPagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChapterPagesProvider._internal(
        (ref) => create(ref as GetChapterPagesRef),
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
  AutoDisposeFutureProviderElement<GetChapterPagesModel> createElement() {
    return _GetChapterPagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChapterPagesProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetChapterPagesRef on AutoDisposeFutureProviderRef<GetChapterPagesModel> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _GetChapterPagesProviderElement
    extends AutoDisposeFutureProviderElement<GetChapterPagesModel>
    with GetChapterPagesRef {
  _GetChapterPagesProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as GetChapterPagesProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
