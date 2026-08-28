import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_for_update.g.dart';

@riverpod
class CheckForAppUpdates extends _$CheckForAppUpdates {
  @override
  bool build() {
    return settingsRepository.current.checkForAppUpdates ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.checkForAppUpdates = value);
  }
}

/// Convenience alias: (version, body, htmlUrl, assets).
typedef UpdateInfo = (String, String, String, List<dynamic>);

/// Automatic update-check provider.
///
/// Respects the user's [checkForAppUpdatesProvider] preference.  Returns
/// [UpdateInfo] when a newer version exists and downloadable assets are ready,
/// `null` otherwise.
@riverpod
Future<UpdateInfo?> checkForUpdate(Ref ref) async {
  if (!ref.read(checkForAppUpdatesProvider)) return null;
  return _getUpdateIfAvailable();
}

/// Compares the running version against the latest release.
/// Returns [UpdateInfo] when an update is available and assets for the current
/// platform are ready, or `null` when already up-to-date or assets are still building.
Future<UpdateInfo?> _getUpdateIfAvailable() async {
  final info = await PackageInfo.fromPlatform();
  if (kDebugMode) {
    log(info.data.toString());
  }
  final latest = await _fetchLatestRelease();
  if (latest == null) {
    return null;
  }
  if (compareVersions(info.version, latest.$1) >= 0) {
    return null;
  }
  if (!_hasPlatformAssets(latest.$4)) {
    return null;
  }
  return latest;
}

/// Validates that release assets for the current platform are present.
/// Avoids notifying users while CI build workflows are still running.
bool _hasPlatformAssets(List<dynamic> assets) {
  if (assets.isEmpty) return false;

  final assetUrls = assets
      .whereType<String>()
      .map((url) => url.toLowerCase())
      .toList();
  if (assetUrls.isEmpty) return false;

  if (Platform.isAndroid) {
    if (isTv) {
      return assetUrls.any(
        (url) => url.endsWith('.apk') && url.contains('android-tv'),
      );
    }
    return assetUrls.any(
      (url) => url.endsWith('.apk') && !url.contains('android-tv'),
    );
  } else if (Platform.isIOS) {
    return assetUrls.any((url) => url.endsWith('.ipa'));
  } else if (Platform.isMacOS) {
    return assetUrls.any((url) => url.endsWith('.dmg') || url.endsWith('.pkg'));
  } else if (Platform.isWindows) {
    return assetUrls.any(
      (url) =>
          url.endsWith('.exe') ||
          url.endsWith('.msix') ||
          (url.endsWith('.zip') && url.contains('windows')),
    );
  } else if (Platform.isLinux) {
    return assetUrls.any(
      (url) =>
          url.endsWith('.appimage') ||
          url.endsWith('.deb') ||
          url.endsWith('.rpm') ||
          (url.endsWith('.zip') && url.contains('linux')),
    );
  }
  return true;
}

/// Performs an update check unconditionally, ignoring the auto-update setting.
Future<UpdateInfo?> performManualUpdateCheck() => _getUpdateIfAvailable();

Future<UpdateInfo?> _fetchLatestRelease() async {
  try {
    final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
    final res = await http.get(
      Uri.parse(
        'https://api.github.com/repos/kodjodevf/Mangayomi/releases/latest',
      ),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );
    if (res.statusCode != 200) {
      if (kDebugMode) {
        log('GitHub releases check failed with status: ${res.statusCode}');
      }
      return null;
    }
    final release = jsonDecode(res.body) as Map<String, dynamic>;
    final tagName =
        (release['tag_name'] as String?) ?? (release['name'] as String?) ?? '';
    final cleanVersion = tagName
        .trim()
        .replaceFirst(RegExp(r'^[vV]'), '')
        .split(RegExp(r'[-+]'))
        .first;
    if (cleanVersion.isEmpty) return null;

    final body = (release['body'] as String?) ?? '';
    final htmlUrl = (release['html_url'] as String?) ?? '';
    final rawAssets = release['assets'] as List<dynamic>? ?? [];
    final assets = rawAssets
        .map(
          (asset) => (asset as Map<String, dynamic>)['browser_download_url']
              ?.toString(),
        )
        .whereType<String>()
        .toList();

    return (cleanVersion, body, htmlUrl, assets);
  } catch (e, st) {
    if (kDebugMode) {
      log('Error fetching latest release: $e\n$st');
    }
    return null;
  }
}
