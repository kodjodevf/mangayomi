// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_borders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cropBordersHash() => r'70030b178c121d536676f66ba1f90d9a15b801ba';

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

/// See also [cropBorders].
@ProviderFor(cropBorders)
const cropBordersProvider = CropBordersFamily();

/// See also [cropBorders].
class CropBordersFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [cropBorders].
  const CropBordersFamily();

  /// See also [cropBorders].
  CropBordersProvider call({
    required UChapDataPreload datas,
    required bool cropBorder,
  }) {
    return CropBordersProvider(
      datas: datas,
      cropBorder: cropBorder,
    );
  }

  @override
  CropBordersProvider getProviderOverride(
    covariant CropBordersProvider provider,
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
  String? get name => r'cropBordersProvider';
}

/// See also [cropBorders].
class CropBordersProvider extends FutureProvider<Uint8List?> {
  /// See also [cropBorders].
  CropBordersProvider({
    required UChapDataPreload datas,
    required bool cropBorder,
  }) : this._internal(
          (ref) => cropBorders(
            ref as CropBordersRef,
            datas: datas,
            cropBorder: cropBorder,
          ),
          from: cropBordersProvider,
          name: r'cropBordersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cropBordersHash,
          dependencies: CropBordersFamily._dependencies,
          allTransitiveDependencies:
              CropBordersFamily._allTransitiveDependencies,
          datas: datas,
          cropBorder: cropBorder,
        );

  CropBordersProvider._internal(
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
    FutureOr<Uint8List?> Function(CropBordersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CropBordersProvider._internal(
        (ref) => create(ref as CropBordersRef),
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
    return _CropBordersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CropBordersProvider &&
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

mixin CropBordersRef on FutureProviderRef<Uint8List?> {
  /// The parameter `datas` of this provider.
  UChapDataPreload get datas;

  /// The parameter `cropBorder` of this provider.
  bool get cropBorder;
}

class _CropBordersProviderElement extends FutureProviderElement<Uint8List?>
    with CropBordersRef {
  _CropBordersProviderElement(super.provider);

  @override
  UChapDataPreload get datas => (origin as CropBordersProvider).datas;
  @override
  bool get cropBorder => (origin as CropBordersProvider).cropBorder;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
