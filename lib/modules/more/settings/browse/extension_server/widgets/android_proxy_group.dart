import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/android_proxy_server_dialog.dart';
import 'package:mangayomi/modules/more/settings/browse/extension_server/extension_server_utils.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shiori settings group for configuring the Android proxy server address and downloading it.
class AndroidProxyGroup extends ConsumerWidget {
  const AndroidProxyGroup({
    super.key,
    required this.title,
    required this.androidProxyServer,
  });

  final String title;
  final String androidProxyServer;

  Future<void> _openMExtensionServerRelease(BuildContext context) async {
    final l10n = l10nLocalizations(context)!;
    if (!await launchUrl(
      Uri.parse(mExtensionServerReleaseUrl),
      mode: LaunchMode.externalApplication,
    )) {
      botToast(l10n.could_not_launch_apk_bridge_page);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.shiori.color;

    return ShioriSettingsGroup(
      title: title,
      footer: l10n.m_extension_server_description,
      children: [
        ShioriSettingRow(
          icon: Symbols.edit_rounded,
          title: l10n.set_proxy_address,
          subtitle: androidProxyServer.isEmpty
              ? l10n.not_configured
              : androidProxyServer,
          trailing: Icon(
            androidProxyServer.isNotEmpty
                ? Symbols.check_circle_rounded
                : Symbols.error_rounded,
            fill: 1,
            color: androidProxyServer.isNotEmpty
                ? c.completed.foreground
                : c.offline.foreground,
          ),
          onTap: () => showAndroidProxyServerDialog(
            context,
            proxyServer: androidProxyServer,
            onConfirm: (server) =>
                ref.read(androidProxyServerStateProvider.notifier).set(server),
          ),
        ),
        ShioriSettingRow(
          icon: Symbols.open_in_new_rounded,
          title: l10n.get_m_extension_server,
          onTap: () => _openMExtensionServerRelease(context),
        ),
      ],
    );
  }
}
