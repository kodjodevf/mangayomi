import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:m_extension_server/m_extension_server.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MExtensionServerPlatform {
  static Future<void>? _iosStartOperation;
  static String? _iosActiveBaseUrl;

  WidgetRef ref;
  MExtensionServerPlatform(this.ref);

  Future<bool> check() => _check(_baseUrl);

  Future<bool> _check(String baseUrl) async {
    if (baseUrl == "http://127.0.0.1:0") return false;
    try {
      final res = await http.get(Uri.parse("$baseUrl/"));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> startServer({bool forceLocal = false}) {
    if (!Platform.isIOS) return _startServer();

    return _iosStartOperation ??=
        _startServer(
          baseUrl: forceLocal
              ? _iosActiveBaseUrl ?? 'http://127.0.0.1:0'
              : null,
        ).whenComplete(() {
          _iosStartOperation = null;
        });
  }

  Future<void> _startServer({String? baseUrl}) async {
    try {
      final isRunning = baseUrl == null ? await check() : await _check(baseUrl);
      if (!isRunning) {
        // Binding then immediately closing just to learn a free port number
        // is inherently racy: JVM startup takes real time, and on Windows
        // especially, another process can grab that exact port before our
        // server finishes binding to it. When that happens every request
        // silently goes to whatever unrelated service ended up on the port
        // instead - which has no idea what "/dalvik" means and answers with
        // something like a bare error, uniformly breaking every extension.
        // Verify the server that comes up is actually ours before trusting
        // the port, retrying with a fresh one a few times otherwise.
        String? localBaseUrl;
        for (var attempt = 0; attempt < 3 && localBaseUrl == null; attempt++) {
          final probe = await HttpServer.bind(
            InternetAddress.loopbackIPv4,
            0,
          );
          final port = probe.port;
          await probe.close();
          if (isDesktop) {
            final settings = settingsRepository.currentOrNull;
            final jrePath = settings?.jrePath;
            final serverJarPath = settings?.extensionServerPath;
            if ((jrePath?.isEmpty ?? true) ||
                (serverJarPath?.isEmpty ?? true)) {
              return;
            }
            if (!await File(jrePath!).exists() ||
                !await File(serverJarPath!).exists()) {
              return;
            }
            await MExtensionServer().startServer(
              port,
              jvmPath: jrePath,
              serverJarPath: serverJarPath,
            );
          } else {
            await MExtensionServer().startServer(port);
          }
          final candidateUrl = "http://127.0.0.1:$port";
          if (await _isOurServer(candidateUrl)) {
            localBaseUrl = candidateUrl;
          } else {
            try {
              await MExtensionServer().stopServer();
            } catch (_) {}
          }
        }
        if (localBaseUrl == null) return;
        if (Platform.isIOS) _iosActiveBaseUrl = localBaseUrl;
        ref.read(androidProxyServerStateProvider.notifier).set(localBaseUrl);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Confirms [baseUrl] is actually our extension server rather than some
  /// other service that happened to be handed the same port, by polling for
  /// the "/capabilities" marker unique to it while the JVM finishes starting.
  Future<bool> _isOurServer(String baseUrl) async {
    for (var i = 0; i < 20; i++) {
      try {
        final res = await http
            .get(Uri.parse("$baseUrl/capabilities"))
            .timeout(const Duration(milliseconds: 500));
        if (res.statusCode == 200 &&
            res.body.contains('"mangayomiMihonBridge"')) {
          return true;
        }
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 250));
    }
    return false;
  }

  Future<void> stopServer() async {
    try {
      if (Platform.isIOS) await _iosStartOperation;
      await MExtensionServer().stopServer();
      if (Platform.isIOS) _iosActiveBaseUrl = null;
    } catch (_) {}
  }

  Future<bool> checkLocalServer() async =>
      _iosActiveBaseUrl != null && await _check(_iosActiveBaseUrl!);

  String get _baseUrl => ref.watch(androidProxyServerStateProvider);
}
