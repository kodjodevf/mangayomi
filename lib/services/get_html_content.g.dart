// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_html_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getHtmlContentHash() => r'fa74506c0adebbdb7a0dda5a8d16a784466b79bb';

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

/// See also [getHtmlContent].
@ProviderFor(getHtmlContent)
const getHtmlContentProvider = GetHtmlContentFamily();

/// See also [getHtmlContent].
class GetHtmlContentFamily extends Family<AsyncValue<(String, EpubBook?)>> {
  /// See also [getHtmlContent].
  const GetHtmlContentFamily();

  /// See also [getHtmlContent].
  GetHtmlContentProvider call({required Chapter chapter}) {
    return GetHtmlContentProvider(chapter: chapter);
  }

  @override
  GetHtmlContentProvider getProviderOverride(
    covariant GetHtmlContentProvider provider,
  ) {
    return call(chapter: provider.chapter);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getHtmlContentProvider';
}

/// See also [getHtmlContent].
class GetHtmlContentProvider
    extends AutoDisposeFutureProvider<(String, EpubBook?)> {
  /// See also [getHtmlContent].
  GetHtmlContentProvider({required Chapter chapter})
    : this._internal(
        (ref) => getHtmlContent(ref as GetHtmlContentRef, chapter: chapter),
        from: getHtmlContentProvider,
        name: r'getHtmlContentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getHtmlContentHash,
        dependencies: GetHtmlContentFamily._dependencies,
        allTransitiveDependencies:
            GetHtmlContentFamily._allTransitiveDependencies,
        chapter: chapter,
      );

  GetHtmlContentProvider._internal(
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
    FutureOr<(String, EpubBook?)> Function(GetHtmlContentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetHtmlContentProvider._internal(
        (ref) => create(ref as GetHtmlContentRef),
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
  AutoDisposeFutureProviderElement<(String, EpubBook?)> createElement() {
    return _GetHtmlContentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHtmlContentProvider && other.chapter == chapter;
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
mixin GetHtmlContentRef on AutoDisposeFutureProviderRef<(String, EpubBook?)> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _GetHtmlContentProviderElement
    extends AutoDisposeFutureProviderElement<(String, EpubBook?)>
    with GetHtmlContentRef {
  _GetHtmlContentProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as GetHtmlContentProvider).chapter;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
