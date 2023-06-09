// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_crop_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoCropImageHash() => r'aae86e74203def1027400fa81e06e8e10344487d';

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

typedef AutoCropImageRef = AutoDisposeFutureProviderRef<Uint8List?>;

/// See also [autoCropImage].
@ProviderFor(autoCropImage)
const autoCropImageProvider = AutoCropImageFamily();

/// See also [autoCropImage].
class AutoCropImageFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [autoCropImage].
  const AutoCropImageFamily();

  /// See also [autoCropImage].
  AutoCropImageProvider call(
    String? url,
    Uint8List? data,
  ) {
    return AutoCropImageProvider(
      url,
      data,
    );
  }

  @override
  AutoCropImageProvider getProviderOverride(
    covariant AutoCropImageProvider provider,
  ) {
    return call(
      provider.url,
      provider.data,
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
  String? get name => r'autoCropImageProvider';
}

/// See also [autoCropImage].
class AutoCropImageProvider extends AutoDisposeFutureProvider<Uint8List?> {
  /// See also [autoCropImage].
  AutoCropImageProvider(
    this.url,
    this.data,
  ) : super.internal(
          (ref) => autoCropImage(
            ref,
            url,
            data,
          ),
          from: autoCropImageProvider,
          name: r'autoCropImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$autoCropImageHash,
          dependencies: AutoCropImageFamily._dependencies,
          allTransitiveDependencies:
              AutoCropImageFamily._allTransitiveDependencies,
        );

  final String? url;
  final Uint8List? data;

  @override
  bool operator ==(Object other) {
    return other is AutoCropImageProvider &&
        other.url == url &&
        other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
