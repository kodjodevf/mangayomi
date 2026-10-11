import 'dart:async';
import 'dart:io';

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
/// TODO(platforms): only Linux is implemented (browsers listed from `.desktop`
/// files, launched via `gtk-launch`). Windows and macOS could enumerate their
/// installed browsers the same way; Android/iOS have no user-selectable browser.
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
      } catch (_) {
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
        } catch (_) {
          continue;
        }
      }
    }
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return apps;
  }

  /// Opens [url] with the saved browser, or the system default when none is
  /// saved or the saved one is no longer installed.
  static Future<bool> open(String url) async {
    final id = savedId;
    if (Platform.isLinux && id.isNotEmpty) {
      final installed = available().map((a) => a.id).toList();
      if (installed.contains(id)) {
        try {
          final result = await Process.run('gtk-launch', [id, url]);
          if (result.exitCode == 0) return true;
        } catch (_) {
          // Fall through to the system default when gtk-launch is unavailable.
        }
      }
    }
    try {
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  /// The in-flight OAuth loopback server and its timeout. A login that never
  /// completes keeps its port; close it before the next attempt binds.
  static HttpServer? _oauthServer;
  static Timer? _oauthTimer;

  /// Opens an OAuth authorize page in the chosen browser and waits for the
  /// redirect to hit the local loopback server bound to [port]. Returns the
  /// callback URI (the code is in its query), or null on failure/timeout.
  ///
  /// Replicates what `flutter_web_auth_2` does on desktop, except the page is
  /// opened with [open] so the user's chosen browser is used.
  static Future<Uri?> openOAuth(String authUrl, {required int port}) async {
    // A previous, still-waiting login owns the port; close it before retrying
    // (binding the same port twice throws "shared flag needs to be true").
    await _oauthServer?.close(force: true);
    _oauthServer = null;
    _oauthTimer?.cancel();
    HttpServer server;
    try {
      server = await HttpServer.bind('127.0.0.1', port);
      _oauthServer = server;
    } catch (_) {
      return null;
    }
    Uri? result;
    final timer = Timer(const Duration(minutes: 5), () {
      server.close(force: true);
    });
    _oauthTimer = timer;
    try {
      final opened = await open(authUrl);
      if (!opened) return null;
      await server.listen((request) async {
        request.response.headers.add('Content-Type', 'text/html');
        request.response.write(
          '<html><body>You can close this window and return to the app.</body></html>',
        );
        await request.response.close();
        result = request.requestedUri;
        await server.close(force: true);
      }).asFuture();
      return result;
    } catch (_) {
      return null;
    } finally {
      timer.cancel();
      if (identical(_oauthServer, server)) _oauthServer = null;
      _oauthTimer = null;
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