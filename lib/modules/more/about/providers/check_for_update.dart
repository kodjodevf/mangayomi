import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_for_update.g.dart';

@riverpod
class CheckForAppUpdates extends _$CheckForAppUpdates {
  @override
  bool build() {
    return isar.settings.getSync(227)?.checkForAppUpdates ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);

    state = value;

    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings!
          ..checkForAppUpdates = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
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
          ) ||
          assetUrls.any((url) => url.endsWith('.apk'));
    }
    return assetUrls.any(
          (url) => url.endsWith('.apk') && !url.contains('android-tv'),
        ) ||
        assetUrls.any((url) => url.endsWith('.apk'));
  } else if (Platform.isIOS) {
    return assetUrls.any((url) => url.endsWith('-ios.ipa'));
  } else if (Platform.isMacOS) {
    return assetUrls.any((url) => url.endsWith('-macos.dmg'));
  } else if (Platform.isWindows) {
    return assetUrls.any(
      (url) => url.endsWith('-windows.exe') || url.endsWith('-windows.zip'),
    );
  } else if (Platform.isLinux) {
    return assetUrls.any(
      (url) =>
          url.endsWith('-linux.AppImage') ||
          url.endsWith('-linux.deb') ||
          url.endsWith('-linux.rpm') ||
          url.endsWith('-linux.zip'),
    );
  }
  return true;
}

/// Performs an update check unconditionally, ignoring the auto-update setting.
Future<UpdateInfo?> performManualUpdateCheck() => _getUpdateIfAvailable();

Future<UpdateInfo> _fetchLatestRelease() async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final res = await http.get(
    Uri.parse(
      'https://api.github.com/repos/kodjodevf/Mangayomi/releases/latest',
    ),
  );
  final release = jsonDecode(res.body) as Map<String, dynamic>;
  return (
    release['name'].toString().substringAfter('v').substringBefore('-'),
    release['body'].toString(),
    release['html_url'].toString(),
    (release['assets'] as List)
        .map((asset) => asset['browser_download_url'])
        .toList(),
  );
}
