import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_release.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_utils.dart';
import 'package:path/path.dart' as path;

/// Service for checking and downloading M-Extension-Server releases from GitHub.
class ExtensionServerReleaseService {
  const ExtensionServerReleaseService._();

  /// Fetches the latest published release from GitHub and matches the bundle
  /// asset for the current operating system and architecture.
  static Future<ExtensionServerRelease?> fetchLatestRelease({
    http.Client? client,
  }) async {
    final assetName = extensionServerAssetNameForCurrentPlatform();
    if (assetName == null) return null;
    final httpClient = client ?? http.Client();
    try {
      final response = await httpClient.get(
        Uri.parse(extensionServerReleaseApiUrl),
        headers: const {'Accept': 'application/vnd.github+json'},
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Failed to check extension server releases (${response.statusCode}).',
        );
      }
      final releases = jsonDecode(response.body) as List;
      for (final item in releases) {
        final release = item as Map<String, dynamic>;
        final isDraftOrPrerelease =
            (release['draft'] as bool? ?? false) ||
            (release['prerelease'] as bool? ?? false);
        if (isDraftOrPrerelease) continue;
        final assets = (release['assets'] as List?) ?? const [];
        for (final assetItem in assets) {
          final asset = assetItem as Map<String, dynamic>;
          if (asset['name'] == assetName) {
            return ExtensionServerRelease(
              version: resolveExtensionServerReleaseVersion(release),
              assetName: assetName,
              downloadUrl: asset['browser_download_url'].toString(),
            );
          }
        }
      }
      return null;
    } finally {
      if (client == null) httpClient.close();
    }
  }

  /// Downloads the release bundle with progress reporting.
  static Future<void> downloadBundle({
    required ExtensionServerRelease release,
    required File destinationZip,
    required void Function(int receivedBytes, int totalBytes) onProgress,
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final request = http.Request('GET', Uri.parse(release.downloadUrl));
      final response = await httpClient.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Failed to download bundle (${response.statusCode})',
        );
      }
      final total = response.contentLength ?? 0;
      onProgress(0, total);
      final sink = destinationZip.openWrite();
      var received = 0;
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        onProgress(received, total);
      }
      await sink.flush();
      await sink.close();
    } finally {
      if (client == null) httpClient.close();
    }
  }

  /// Unpacks [archiveFile] into [installDir] while guarding against Zip Slip path traversal.
  static Future<void> extractArchive(
    File archiveFile,
    Directory installDir,
  ) async {
    final archivePath = archiveFile.path;
    final installPath = installDir.path;
    await Isolate.run(() async {
      final bytes = await File(archivePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive.files) {
        final outputPath = path.normalize(path.join(installPath, file.name));
        if (!path.isWithin(installPath, outputPath) &&
            outputPath != installPath) {
          continue;
        }
        if (file.isFile) {
          final extractedFile = File(outputPath);
          await extractedFile.parent.create(recursive: true);
          await extractedFile.writeAsBytes(file.content as List<int>);
        } else {
          await Directory(outputPath).create(recursive: true);
        }
      }
    });
  }

  /// Recursively deletes a directory, with retries on Windows to prevent lock collisions.
  static Future<void> deleteDirectoryWithRetry(Directory directory) async {
    const retryCount = 5;
    for (var attempt = 0; attempt < retryCount; attempt++) {
      try {
        await directory.delete(recursive: true);
        break;
      } catch (e) {
        if (!Platform.isWindows || attempt == retryCount - 1) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
  }
}
