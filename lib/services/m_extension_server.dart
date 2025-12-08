import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_extension_server/m_extension_server.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class MExtensionServerPlatform {
  WidgetRef ref;
  MExtensionServerPlatform(this.ref);

  Future<void> startServer() async {
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      await server.close();
      await MExtensionServer().startServer(port);
      ref
          .read(androidProxyServerStateProvider.notifier)
          .set("http://127.0.0.1:$port");
    } catch (_) {}
  }

  Future<void> stopServer() async {
    try {
      await MExtensionServer().stopServer();
    } catch (_) {}
  }
}
