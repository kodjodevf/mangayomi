import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

/// A browser the user can pick to open external links on Linux.
class BrowserApp {
  const BrowserApp({required this.id, required this.name});

  /// The `.desktop` file's basename, including `.desktop` -- this is the name
  /// `gtk-launch` accepts.
  final String id;

  /// The user-visible name from the `.desktop` file's `Name=` entry.
  final String name;
}

/// Routes external links through a browser the user chose on Linux, and through
/// the platform default handler everywhere else.
///
/// `url_launcher`'s [LaunchMode.externalApplication] always uses the OS default
/// handler and cannot name an app, so on Linux the saved `.desktop` id is
/// launched directly with `gtk-launch`.
class ExternalBrowser {
  const ExternalBrowser._();

  /// The saved browser id, or an empty string for "system default".
  static String get savedId => settingsRepository.current.externalBrowser ?? '';

  /// Persists [id] as the browser to open external links with. An empty string
  /// means the system default.
  static void save(String id) {
    settingsRepository.update((s) => s.externalBrowser = id);
  }

  /// The browsers installed on this machine, sorted by name. Empty off Linux.
  static List<BrowserApp> available() {
    if (!Platform.isLinux) return [];
    final apps = <BrowserApp>[];
    final seen = <String>{};
    for (final dir in _applicationDirs()) {
      final directory = Directory(dir);
      if (!directory.existsSync()) continue;
      List<FileSystemEntity> entries;
      try {
        entries = directory.listSync();
      } catch (error) {
        debugPrint('[ExternalBrowser] listing $dir failed: $error');
        continue;
      }
      for (final entity in entries) {
        if (entity is! File) continue;
        final basename = entity.uri.pathSegments.last;
        if (!basename.endsWith('.desktop') || seen.contains(basename)) continue;
        try {
          final entry = _parseDesktopFile(entity.readAsStringSync());
          if (!entry.isBrowser) continue;
          seen.add(basename);
          apps.add(BrowserApp(id: basename, name: entry.name));
        } catch (error) {
          debugPrint('[ExternalBrowser] reading ${entity.path} failed: $error');
        }
      }
    }
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    debugPrint(
      '[ExternalBrowser] available: '
      '${apps.map((a) => '${a.name}=${a.id}').join(', ')}',
    );
    return apps;
  }

  /// Opens [url] with the saved browser, or the system default when none is
  /// saved or the saved one is no longer installed.
  static Future<bool> open(String url) async {
    final id = savedId;
    debugPrint('[ExternalBrowser] open url="$url" savedId="$id"');
    if (Platform.isLinux && id.isNotEmpty) {
      final installed = available().map((a) => a.id).toList();
      if (installed.contains(id)) {
        try {
          final result = await Process.run('gtk-launch', [id, url]);
          debugPrint(
            '[ExternalBrowser] gtk-launch exit=${result.exitCode} '
            'out=${result.stdout} err=${result.stderr}',
          );
          if (result.exitCode == 0) return true;
        } catch (error) {
          debugPrint('[ExternalBrowser] gtk-launch threw: $error');
        }
      } else {
        debugPrint(
          '[ExternalBrowser] saved id "$id" not in installed list '
          '(${installed.join(', ')}); falling back',
        );
      }
    }
    try {
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      debugPrint('[ExternalBrowser] fallback launchUrl -> $ok');
      return ok;
    } catch (error) {
      debugPrint('[ExternalBrowser] launching $url failed: $error');
      return false;
    }
  }

  /// Opens an OAuth authorize page in the chosen browser and waits for the
  /// redirect to hit the local loopback server bound to [port]. Returns the
  /// callback URI (the code is in its query), or null on failure/timeout.
  ///
  /// Replicates what `flutter_web_auth_2` does on desktop, except the page is
  /// opened with [open] so the user's chosen browser is used.
  static Future<Uri?> openOAuth(String authUrl, {required int port}) async {
    HttpServer server;
    try {
      server = await HttpServer.bind('127.0.0.1', port);
    } catch (error) {
      debugPrint('[ExternalBrowser] could not bind oauth port $port: $error');
      return null;
    }
    Uri? result;
    final timer = Timer(const Duration(minutes: 5), () {
      debugPrint('[ExternalBrowser] oauth wait on port $port timed out');
      server.close(force: true);
    });
    try {
      debugPrint('[ExternalBrowser] oauth opening $authUrl on port $port');
      final opened = await open(authUrl);
      if (!opened) {
        debugPrint('[ExternalBrowser] oauth could not open the auth page');
        return null;
      }
      await server.listen((request) async {
        request.response.headers.add('Content-Type', 'text/html');
        request.response.write(
          '<html><body>You can close this window and return to the app.</body></html>',
        );
        await request.response.close();
        result = request.requestedUri;
        await server.close(force: true);
      }).asFuture();
      debugPrint('[ExternalBrowser] oauth callback: $result');
      return result;
    } catch (error) {
      debugPrint('[ExternalBrowser] oauth on port $port failed: $error');
      return null;
    } finally {
      timer.cancel();
      await server.close(force: true);
    }
  }

  static List<String> _applicationDirs() => [
    '/usr/share/applications',
    '/usr/local/share/applications',
    '${Platform.environment['HOME'] ?? ''}/.local/share/applications',
    // Ubuntu ships Firefox/Chromium as snaps, and many users install browsers
    // through Flatpak; both live outside the usual desktop-file directories.
    '/var/lib/snapd/desktop/applications',
    '/var/lib/flatpak/exports/share/applications',
    '${Platform.environment['HOME'] ?? ''}/.local/share/flatpak/exports/share/applications',
  ];

  static _DesktopEntry _parseDesktopFile(String contents) {
    var isBrowser = false;
    var noDisplay = false;
    String? name;
    for (final rawLine in contents.split('\n')) {
      final line = rawLine.trim();
      if (line.startsWith('Name=') && name == null) {
        name = line.substring('Name='.length).trim();
      } else if (line.startsWith('Categories=')) {
        final categories = line.substring('Categories='.length).split(';');
        if (categories.contains('WebBrowser')) isBrowser = true;
      } else if (line.startsWith('NoDisplay=')) {
        noDisplay =
            line.substring('NoDisplay='.length).trim().toLowerCase() == 'true';
      }
    }
    return _DesktopEntry(isBrowser: isBrowser && !noDisplay, name: name ?? '');
  }
}

class _DesktopEntry {
  const _DesktopEntry({required this.isBrowser, required this.name});

  final bool isBrowser;
  final String name;
}
