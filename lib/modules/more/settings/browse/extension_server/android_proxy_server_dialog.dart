import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Asks for the Android proxy's address; a trailing slash is dropped.
Future<void> showAndroidProxyServerDialog(
  BuildContext context, {
  required String proxyServer,
  required ValueChanged<String> onConfirm,
}) async {
  final l10n = context.l10n;
  final server = await showShioriPrompt(
    context,
    title: l10n.android_proxy_server,
    confirmLabel: l10n.dialog_confirm,
    initialValue: proxyServer,
    hint: l10n.proxy_server_ip_hint,
    keyboardType: TextInputType.url,
    allowEmpty: true,
  );
  if (server == null) return;
  final segments = server.split('/');
  if (segments.isNotEmpty && segments.last.isEmpty) segments.removeLast();
  onConfirm(segments.join('/'));
}
