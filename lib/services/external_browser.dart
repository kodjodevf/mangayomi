import 'dart:async';
import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

/// A browser the user can pick to open external links.
class BrowserApp {
  const BrowserApp({required this.id, required this.name});

  /// The `.desktop` file's basename, including `.desktop` -- this is the name
  /// `gtk-launch` accepts.
  final String id;

  /// The user-visible name from the `.desktop` file's `Name=` entry.
  final String name;
}

/// Routes external links through a browser the user chose.
///
/// Each public entry point only dispatches on the platform and hands off to a
/// small per-platform function. Only Linux has a real implementation (browsers
/// listed from `.desktop` files, launched via `gtk-launch`); every other
/// platform falls to the shared `_default` function, which is where a Windows
/// or macOS implementation goes.
///
/// `url_launcher`'s [LaunchMode.externalApplication] always uses the OS default
/// handler and cannot name an app, so Linux launches the saved `.desktop` id
/// directly with `gtk-launch`.
class ExternalBrowser {
  const ExternalBrowser._();

  /// The saved browser id, or an empty string for "system default".
  static String get savedId =>
      settingsRepository.currentOrNull?.externalBrowser ?? '';

  /// Persists [id] as the browser to open external links with. An empty string
  /// means the system default.
  ///
  /// A local-state write: which browsers are installed is a property of this
  /// machine, so the choice must not be treated as a settings change that
  /// travels to another device.
  static void save(String id) {
    settingsRepository.updateLocalState((s) => s.externalBrowser = id);
  }

  // --- installed browsers -------------------------------------------------

  /// The browsers installed on this machine, sorted by name.
  ///
  /// Cached: this is read on every external link, and re-scanning the `.desktop`
  /// directories each time is wasteful. [refreshAvailable] forces a fresh scan
  /// (used when the picker opens, so a newly installed browser still shows).
  static List<BrowserApp> available() => _cache ??= _listBrowsers();

  static void refreshAvailable() => _cache = null;

  static List<BrowserApp>? _cache;

  static List<BrowserApp> _listBrowsers() {
    if (Platform.isLinux) return _listBrowsersLinux();
    // TODO(platforms): implement the macOS and Windows browser enumeration.
    if (Platform.isMacOS) return _listBrowsersDefault();
    if (Platform.isWindows) return _listBrowsersDefault();
    return _listBrowsersDefault();
  }

  /// Mobile (and any platform without enumeration): none.
  static List<BrowserApp> _listBrowsersDefault() => const [];

  static List<BrowserApp> _listBrowsersLinux() {
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

  // --- open an external link ----------------------------------------------

  /// Opens [url] with the chosen browser, or the system default when none is
  /// saved or the saved one is no longer installed.
  static Future<bool> open(String url) {
    if (Platform.isLinux) return _openLinux(url);
    // TODO(platforms): implement the macOS and Windows chosen-browser launch.
    if (Platform.isMacOS) return _openDefault(url);
    if (Platform.isWindows) return _openDefault(url);
    return _openDefault(url);
  }

  /// Linux: a normal web link goes to the chosen browser; anything else (and any
  /// failure) goes to the system default.
  static Future<bool> _openLinux(String url) async {
    final uri = Uri.parse(url);
    final id = savedId;
    // Only normal web links go to the chosen browser. Any other scheme
    // (mailto:, magnet:, tg:, ...) must reach the OS handler that owns it.
    final isWeb = uri.scheme == 'http' || uri.scheme == 'https';
    if (id.isNotEmpty && isWeb && available().any((a) => a.id == id)) {
      try {
        final result = await Process.run(
          'gtk-launch',
          [id, url],
          // An AppImage points LD_LIBRARY_PATH/LD_PRELOAD at its own bundled
          // libraries. An empty value stops the launched browser inheriting
          // them and loading the wrong shared objects.
          environment: {'LD_LIBRARY_PATH': '', 'LD_PRELOAD': ''},
        );
        if (result.exitCode == 0) return true;
      } catch (_) {
        // Fall through to the system default when gtk-launch is unavailable.
      }
    }
    return _openDefault(url);
  }

  /// The system default handler (mobile, and macOS/Windows until implemented).
  static Future<bool> _openDefault(String url) async {
    try {
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }

  // --- oauth login --------------------------------------------------------

  /// The in-flight OAuth loopback server and its timeout. A login that never
  /// completes keeps its port; close it before the next attempt binds.
  static HttpServer? _oauthServer;
  static Timer? _oauthTimer;

  /// Runs an OAuth login and returns the callback URI (the code is in its
  /// query), or null on failure/timeout.
  static Future<Uri?> openOAuth(
    String authUrl, {
    required int port,
    required String callbackUrlScheme,
  }) {
    if (Platform.isLinux) return _openOAuthLinux(authUrl, port: port);
    // TODO(platforms): implement the macOS and Windows chosen-browser login.
    if (Platform.isMacOS) {
      return _openOAuthDefault(authUrl, callbackUrlScheme: callbackUrlScheme);
    }
    if (Platform.isWindows) {
      return _openOAuthDefault(authUrl, callbackUrlScheme: callbackUrlScheme);
    }
    return _openOAuthDefault(authUrl, callbackUrlScheme: callbackUrlScheme);
  }

  /// Linux: open the authorize page in the chosen browser and catch the
  /// redirect on a local loopback server bound to [port].
  static Future<Uri?> _openOAuthLinux(
    String authUrl, {
    required int port,
  }) async {
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
      if (identical(_oauthTimer, timer)) _oauthTimer = null;
      await server.close(force: true);
    }
  }

  /// The original `flutter_web_auth_2` flow (mobile, and macOS/Windows until
  /// implemented).
  static Future<Uri?> _openOAuthDefault(
    String authUrl, {
    required String callbackUrlScheme,
  }) async {
    return Uri.parse(
      await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: callbackUrlScheme,
      ),
    );
  }

  // --- linux desktop files ------------------------------------------------

  /// The directories that hold `.desktop` files, highest priority first.
  ///
  /// XDG_DATA_HOME/XDG_DATA_DIRS are the standard source; the snap and Flatpak
  /// export directories are added explicitly because they are not always
  /// present in the app's own environment.
  static List<String> _applicationDirs() {
    final home = Platform.environment['HOME'] ?? '';
    final dataHome =
        Platform.environment['XDG_DATA_HOME'] ?? '$home/.local/share';
    final dataDirs =
        Platform.environment['XDG_DATA_DIRS'] ?? '/usr/local/share:/usr/share';
    final dirs = <String>[];
    void add(String base) {
      if (base.isEmpty) return;
      final path = '$base/applications';
      if (!dirs.contains(path)) dirs.add(path);
    }

    add(dataHome);
    for (final base in dataDirs.split(':')) {
      add(base);
    }
    // Ubuntu ships Firefox/Chromium as snaps, and many users install browsers
    // through Flatpak; both live outside the usual desktop-file directories.
    add('/var/lib/snapd/desktop');
    add('/var/lib/flatpak/exports/share');
    add('$home/.local/share/flatpak/exports/share');
    return dirs;
  }

  static _DesktopEntry _parseDesktopFile(String contents) {
    var isBrowser = false;
    var hidden = false;
    String? name;
    for (final rawLine in contents.split('\n')) {
      final line = rawLine.trim();
      if (line.startsWith('Name=') && name == null) {
        name = line.substring('Name='.length).trim();
      } else if (line.startsWith('Categories=')) {
        final categories = line.substring('Categories='.length).split(';');
        if (categories.contains('WebBrowser')) isBrowser = true;
      } else if (line.startsWith('NoDisplay=') || line.startsWith('Hidden=')) {
        // NoDisplay hides the entry from menus; Hidden marks it removed.
        final value = line.substring(line.indexOf('=') + 1).trim();
        if (value.toLowerCase() == 'true') hidden = true;
      }
    }
    return _DesktopEntry(isBrowser: isBrowser && !hidden, name: name ?? '');
  }
}

class _DesktopEntry {
  const _DesktopEntry({required this.isBrowser, required this.name});

  final bool isBrowser;
  final String name;
}
