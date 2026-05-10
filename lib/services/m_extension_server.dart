import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:m_extension_server/m_extension_server.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MExtensionServerPlatform {
  WidgetRef ref;
  MExtensionServerPlatform(this.ref);

  Future<bool> check() async {
    if (_baseUrl == "http://127.0.0.1:0") return false;
    try {
      final res = await http.get(Uri.parse("$_baseUrl/"));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> startServer() async {
    try {
      final isRunning = await check();
      if (!isRunning) {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final port = server.port;
        await server.close();
        if (isDesktop) {
          final settings = isar.settings.getSync(227);
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
        ref
            .read(androidProxyServerStateProvider.notifier)
            .set("http://127.0.0.1:$port");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> stopServer() async {
    try {
      await MExtensionServer().stopServer();
    } catch (_) {}
  }

  String get _baseUrl => ref.watch(androidProxyServerStateProvider);
}
