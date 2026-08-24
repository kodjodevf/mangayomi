import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// One line naming the device and OS, for the "Device" field of a bug report.
///
/// Model and OS version only. Nothing here identifies the device or its owner.
Future<String> deviceDescription() async {
  try {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}, '
          'Android ${android.version.release} (SDK ${android.version.sdkInt})';
    }
    if (Platform.isIOS) {
      final ios = await info.iosInfo;
      return '${ios.model}, iOS ${ios.systemVersion}';
    }
    if (Platform.isMacOS) {
      final mac = await info.macOsInfo;
      return 'Mac ${mac.model}, macOS ${mac.osRelease}';
    }
    if (Platform.isWindows) {
      final windows = await info.windowsInfo;
      return 'Windows ${windows.displayVersion} '
          '(build ${windows.buildNumber})';
    }
    if (Platform.isLinux) {
      final linux = await info.linuxInfo;
      return linux.prettyName;
    }
  } catch (_) {
    // Falls through to the operating system's own name.
  }
  return Platform.operatingSystem;
}

/// The app version and build, for the "Mangayomi version" field.
Future<String> appVersionDescription() async {
  try {
    final info = await PackageInfo.fromPlatform();
    return '${info.version} (${info.buildNumber})';
  } catch (_) {
    return 'unknown';
  }
}
