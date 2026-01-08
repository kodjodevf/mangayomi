// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_package_info.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getPackageInfo)
final getPackageInfoProvider = GetPackageInfoProvider._();

final class GetPackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  GetPackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPackageInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPackageInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return getPackageInfo(ref);
  }
}

String _$getPackageInfoHash() => r'41844966a85f413f78ccddac1f5c235d2547c33f';
