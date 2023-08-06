// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_crop_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoCropBorderHash() => r'42f55a8c0704730e69055f914fc1b9766776dd64';

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

typedef AutoCropBorderRef = AutoDisposeFutureProviderRef<List<Uint8List?>>;

/// See also [autoCropBorder].
@ProviderFor(autoCropBorder)
const autoCropBorderProvider = AutoCropBorderFamily();

/// See also [autoCropBorder].
class AutoCropBorderFamily extends Family<AsyncValue<List<Uint8List?>>> {
  /// See also [autoCropBorder].
  const AutoCropBorderFamily();

  /// See also [autoCropBorder].
  AutoCropBorderProvider call({
    required List<String?> url,
    required List<Uint8List?> archiveImages,
    required List<bool> isLocaleList,
    required Directory path,
  }) {
    return AutoCropBorderProvider(
      url: url,
      archiveImages: archiveImages,
      isLocaleList: isLocaleList,
      path: path,
    );
  }

  @override
  AutoCropBorderProvider getProviderOverride(
    covariant AutoCropBorderProvider provider,
  ) {
    return call(
      url: provider.url,
      archiveImages: provider.archiveImages,
      isLocaleList: provider.isLocaleList,
      path: provider.path,
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
  String? get name => r'autoCropBorderProvider';
}

/// See also [autoCropBorder].
class AutoCropBorderProvider
    extends AutoDisposeFutureProvider<List<Uint8List?>> {
  /// See also [autoCropBorder].
  AutoCropBorderProvider({
    required this.url,
    required this.archiveImages,
    required this.isLocaleList,
    required this.path,
  }) : super.internal(
          (ref) => autoCropBorder(
            ref,
            url: url,
            archiveImages: archiveImages,
            isLocaleList: isLocaleList,
            path: path,
          ),
          from: autoCropBorderProvider,
          name: r'autoCropBorderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$autoCropBorderHash,
          dependencies: AutoCropBorderFamily._dependencies,
          allTransitiveDependencies:
              AutoCropBorderFamily._allTransitiveDependencies,
        );

  final List<String?> url;
  final List<Uint8List?> archiveImages;
  final List<bool> isLocaleList;
  final Directory path;

  @override
  bool operator ==(Object other) {
    return other is AutoCropBorderProvider &&
        other.url == url &&
        other.archiveImages == archiveImages &&
        other.isLocaleList == isLocaleList &&
        other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, archiveImages.hashCode);
    hash = _SystemHash.combine(hash, isLocaleList.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
