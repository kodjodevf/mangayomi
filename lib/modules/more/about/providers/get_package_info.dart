import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_package_info.g.dart';

@riverpod
Future<PackageInfo> getPackageInfo(GetPackageInfoRef ref) async {
  return (await PackageInfo.fromPlatform());
}
