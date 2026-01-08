// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_borders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cropBorders)
final cropBordersProvider = CropBordersFamily._();

final class CropBordersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  CropBordersProvider._({
    required CropBordersFamily super.from,
    required ({UChapDataPreload data, bool cropBorder}) super.argument,
  }) : super(
         retry: null,
         name: r'cropBordersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cropBordersHash();

  @override
  String toString() {
    return r'cropBordersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument =
        this.argument as ({UChapDataPreload data, bool cropBorder});
    return cropBorders(
      ref,
      data: argument.data,
      cropBorder: argument.cropBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CropBordersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cropBordersHash() => r'ec9c6fc8a8c88a2bb48bb54a497478bc61376291';

final class CropBordersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Uint8List?>,
          ({UChapDataPreload data, bool cropBorder})
        > {
  CropBordersFamily._()
    : super(
        retry: null,
        name: r'cropBordersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CropBordersProvider call({
    required UChapDataPreload data,
    required bool cropBorder,
  }) => CropBordersProvider._(
    argument: (data: data, cropBorder: cropBorder),
    from: this,
  );

  @override
  String toString() => r'cropBordersProvider';
}
