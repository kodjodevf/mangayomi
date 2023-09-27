// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_crop_image_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoCropImageBorderHash() =>
    r'298f7adb70ff125c339dd793dca5be8394b96355';

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
    required UChapDataPreload datas,
    required bool cropBorder,
  }) {
    return AutoCropImageBorderProvider(
      datas: datas,
      cropBorder: cropBorder,
    );
  }

  @override
  AutoCropImageBorderProvider getProviderOverride(
    covariant AutoCropImageBorderProvider provider,
  ) {
    return call(
      datas: provider.datas,
      cropBorder: provider.cropBorder,
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
    required UChapDataPreload datas,
    required bool cropBorder,
  }) : this._internal(
          (ref) => autoCropImageBorder(
            ref as AutoCropImageBorderRef,
            datas: datas,
            cropBorder: cropBorder,
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
          datas: datas,
          cropBorder: cropBorder,
        );

  AutoCropImageBorderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.datas,
    required this.cropBorder,
  }) : super.internal();

  final UChapDataPreload datas;
  final bool cropBorder;

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
        datas: datas,
        cropBorder: cropBorder,
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
        other.datas == datas &&
        other.cropBorder == cropBorder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, datas.hashCode);
    hash = _SystemHash.combine(hash, cropBorder.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AutoCropImageBorderRef on FutureProviderRef<Uint8List?> {
  /// The parameter `datas` of this provider.
  UChapDataPreload get datas;

  /// The parameter `cropBorder` of this provider.
  bool get cropBorder;
}

class _AutoCropImageBorderProviderElement
    extends FutureProviderElement<Uint8List?> with AutoCropImageBorderRef {
  _AutoCropImageBorderProviderElement(super.provider);

  @override
  UChapDataPreload get datas => (origin as AutoCropImageBorderProvider).datas;
  @override
  bool get cropBorder => (origin as AutoCropImageBorderProvider).cropBorder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
