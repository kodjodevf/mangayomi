import 'dart:ffi';
import 'dart:io';

import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;

const extensionServerFallbackVersion = '1.0.0';
const extensionServerJarPrefix = 'MExtensionServer-';
const extensionServerReleaseApiUrl =
    'https://api.github.com/repos/kodjodevf/M-Extension-Server/releases?page=1&per_page=10';
const apkBridgeReleaseUrl =
    'https://github.com/Schnitzel5/ApkBridge/releases/latest';

String? extensionServerDirectoryFromPaths({
  required String jrePath,
  required String extensionServerPath,
}) {
  if (extensionServerPath.isNotEmpty) {
    return path.dirname(extensionServerPath);
  }
  if (jrePath.isNotEmpty) {
    return path.dirname(jrePath);
  }
  return null;
}

Future<String?> findExtensionServerJavaExecutable(Directory root) async {
  final executableName = Platform.isWindows ? 'java.exe' : 'java';
  final preferredPath = path.join(
    root.path,
    'jre',
    'jre',
    'bin',
    executableName,
  );
  if (await File(preferredPath).exists()) {
    return preferredPath;
  }
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File &&
        path.basename(entity.path).toLowerCase() == executableName) {
      return entity.path;
    }
  }
  return null;
}

Future<String?> findExtensionServerJar(Directory root) async {
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    final fileName = path.basename(entity.path);
    if (entity is File &&
        fileName.startsWith(extensionServerJarPrefix) &&
        fileName.endsWith('.jar')) {
      return entity.path;
    }
  }
  return null;
}

String? extensionServerAssetNameForCurrentPlatform() {
  final abi = Abi.current();
  if (Platform.isIOS) {
    return abi == Abi.iosArm64 ? 'macOS-arm64-bundle.zip' : null;
  }
  if (Platform.isWindows) {
    return abi == Abi.windowsX64 ? 'windows-x64-bundle.zip' : null;
  }
  if (Platform.isLinux) {
    return abi == Abi.linuxX64 ? 'linux-x64-bundle.zip' : null;
  }
  if (Platform.isMacOS) {
    return switch (abi) {
      Abi.macosArm64 => 'macOS-arm64-bundle.zip',
      Abi.macosX64 => 'macOS-x64-bundle.zip',
      _ => null,
    };
  }
  return null;
}

String resolveInstalledExtensionServerVersion(String extensionServerPath) {
  if (extensionServerPath.isEmpty) return '';
  return extractExtensionServerVersion(path.basename(extensionServerPath)) ??
      extensionServerFallbackVersion;
}

String resolveExtensionServerReleaseVersion(Map<String, dynamic> release) {
  final versionSource =
      release['tag_name']?.toString() ??
      release['name']?.toString() ??
      extensionServerFallbackVersion;
  return extractExtensionServerVersion(versionSource) ??
      versionSource.substringAfter('v').substringBefore('-');
}

String? extractExtensionServerVersion(String value) {
  final match = RegExp(r'v?(\d+(?:\.\d+)+)').firstMatch(value);
  return match?.group(1);
}
