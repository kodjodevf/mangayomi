// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadChapterHash() => r'f407f5839eff9754f9590f2f2189bcb604f3fa06';

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

/// See also [downloadChapter].
@ProviderFor(downloadChapter)
const downloadChapterProvider = DownloadChapterFamily();

/// See also [downloadChapter].
class DownloadChapterFamily extends Family<AsyncValue<List<PageUrl>>> {
  /// See also [downloadChapter].
  const DownloadChapterFamily();

  /// See also [downloadChapter].
  DownloadChapterProvider call({
    required Chapter chapter,
    bool? useWifi,
  }) {
    return DownloadChapterProvider(
      chapter: chapter,
      useWifi: useWifi,
    );
  }

  @override
  DownloadChapterProvider getProviderOverride(
    covariant DownloadChapterProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
      useWifi: provider.useWifi,
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
  String? get name => r'downloadChapterProvider';
}

/// See also [downloadChapter].
class DownloadChapterProvider extends AutoDisposeFutureProvider<List<PageUrl>> {
  /// See also [downloadChapter].
  DownloadChapterProvider({
    required Chapter chapter,
    bool? useWifi,
  }) : this._internal(
          (ref) => downloadChapter(
            ref as DownloadChapterRef,
            chapter: chapter,
            useWifi: useWifi,
          ),
          from: downloadChapterProvider,
          name: r'downloadChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$downloadChapterHash,
          dependencies: DownloadChapterFamily._dependencies,
          allTransitiveDependencies:
              DownloadChapterFamily._allTransitiveDependencies,
          chapter: chapter,
          useWifi: useWifi,
        );

  DownloadChapterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
    required this.useWifi,
  }) : super.internal();

  final Chapter chapter;
  final bool? useWifi;

  @override
  Override overrideWith(
    FutureOr<List<PageUrl>> Function(DownloadChapterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DownloadChapterProvider._internal(
        (ref) => create(ref as DownloadChapterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
        useWifi: useWifi,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PageUrl>> createElement() {
    return _DownloadChapterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadChapterProvider &&
        other.chapter == chapter &&
        other.useWifi == useWifi;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);
    hash = _SystemHash.combine(hash, useWifi.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DownloadChapterRef on AutoDisposeFutureProviderRef<List<PageUrl>> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;

  /// The parameter `useWifi` of this provider.
  bool? get useWifi;
}

class _DownloadChapterProviderElement
    extends AutoDisposeFutureProviderElement<List<PageUrl>>
    with DownloadChapterRef {
  _DownloadChapterProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as DownloadChapterProvider).chapter;
  @override
  bool? get useWifi => (origin as DownloadChapterProvider).useWifi;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
