// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_crop_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoCropImageBorderHash() =>
    r'059cbf2ee6f6ef931841e19851f201047a16bad6';

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

/// See also [autoCropImageBorder].
@ProviderFor(autoCropImageBorder)
const autoCropImageBorderProvider = AutoCropImageBorderFamily();

/// See also [autoCropImageBorder].
class AutoCropImageBorderFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [autoCropImageBorder].
  const AutoCropImageBorderFamily();

  /// See also [autoCropImageBorder].
  AutoCropImageBorderProvider call({
    required bool autoCrop,
    required String? url,
    required Uint8List? archiveImages,
    required bool isLocaleList,
    required Directory path,
    required int index,
  }) {
    return AutoCropImageBorderProvider(
      autoCrop: autoCrop,
      url: url,
      archiveImages: archiveImages,
      isLocaleList: isLocaleList,
      path: path,
      index: index,
    );
  }

  @override
  AutoCropImageBorderProvider getProviderOverride(
    covariant AutoCropImageBorderProvider provider,
  ) {
    return call(
      autoCrop: provider.autoCrop,
      url: provider.url,
      archiveImages: provider.archiveImages,
      isLocaleList: provider.isLocaleList,
      path: provider.path,
      index: provider.index,
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
  String? get name => r'autoCropImageBorderProvider';
}

/// See also [autoCropImageBorder].
class AutoCropImageBorderProvider extends FutureProvider<Uint8List?> {
  /// See also [autoCropImageBorder].
  AutoCropImageBorderProvider({
    required bool autoCrop,
    required String? url,
    required Uint8List? archiveImages,
    required bool isLocaleList,
    required Directory path,
    required int index,
  }) : this._internal(
          (ref) => autoCropImageBorder(
            ref as AutoCropImageBorderRef,
            autoCrop: autoCrop,
            url: url,
            archiveImages: archiveImages,
            isLocaleList: isLocaleList,
            path: path,
            index: index,
          ),
          from: autoCropImageBorderProvider,
          name: r'autoCropImageBorderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$autoCropImageBorderHash,
          dependencies: AutoCropImageBorderFamily._dependencies,
          allTransitiveDependencies:
              AutoCropImageBorderFamily._allTransitiveDependencies,
          autoCrop: autoCrop,
          url: url,
          archiveImages: archiveImages,
          isLocaleList: isLocaleList,
          path: path,
          index: index,
        );

  AutoCropImageBorderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.autoCrop,
    required this.url,
    required this.archiveImages,
    required this.isLocaleList,
    required this.path,
    required this.index,
  }) : super.internal();

  final bool autoCrop;
  final String? url;
  final Uint8List? archiveImages;
  final bool isLocaleList;
  final Directory path;
  final int index;

  @override
  Override overrideWith(
    FutureOr<Uint8List?> Function(AutoCropImageBorderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoCropImageBorderProvider._internal(
        (ref) => create(ref as AutoCropImageBorderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        autoCrop: autoCrop,
        url: url,
        archiveImages: archiveImages,
        isLocaleList: isLocaleList,
        path: path,
        index: index,
      ),
    );
  }

  @override
  FutureProviderElement<Uint8List?> createElement() {
    return _AutoCropImageBorderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AutoCropImageBorderProvider &&
        other.autoCrop == autoCrop &&
        other.url == url &&
        other.archiveImages == archiveImages &&
        other.isLocaleList == isLocaleList &&
        other.path == path &&
        other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, autoCrop.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, archiveImages.hashCode);
    hash = _SystemHash.combine(hash, isLocaleList.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AutoCropImageBorderRef on FutureProviderRef<Uint8List?> {
  /// The parameter `autoCrop` of this provider.
  bool get autoCrop;

  /// The parameter `url` of this provider.
  String? get url;

  /// The parameter `archiveImages` of this provider.
  Uint8List? get archiveImages;

  /// The parameter `isLocaleList` of this provider.
  bool get isLocaleList;

  /// The parameter `path` of this provider.
  Directory get path;

  /// The parameter `index` of this provider.
  int get index;
}

class _AutoCropImageBorderProviderElement
    extends FutureProviderElement<Uint8List?> with AutoCropImageBorderRef {
  _AutoCropImageBorderProviderElement(super.provider);

  @override
  bool get autoCrop => (origin as AutoCropImageBorderProvider).autoCrop;
  @override
  String? get url => (origin as AutoCropImageBorderProvider).url;
  @override
  Uint8List? get archiveImages =>
      (origin as AutoCropImageBorderProvider).archiveImages;
  @override
  bool get isLocaleList => (origin as AutoCropImageBorderProvider).isLocaleList;
  @override
  Directory get path => (origin as AutoCropImageBorderProvider).path;
  @override
  int get index => (origin as AutoCropImageBorderProvider).index;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
