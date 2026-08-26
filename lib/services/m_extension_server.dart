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
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final port = server.port;
        await server.close();
        if (isDesktop) {
          final settings = settingsRepository.currentOrNull;
          final jrePath = settings?.jrePath;
          final serverJarPath = settings?.extensionServerPath;
          if ((jrePath?.isEmpty ?? true) || (serverJarPath?.isEmpty ?? true)) {
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
        final localBaseUrl = "http://127.0.0.1:$port";
        if (Platform.isIOS) _iosActiveBaseUrl = localBaseUrl;
        ref.read(androidProxyServerStateProvider.notifier).set(localBaseUrl);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
