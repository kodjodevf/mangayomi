import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Shiori settings group displaying the status and path of extension server files.
class ExtensionServerStatusGroup extends StatelessWidget {
  const ExtensionServerStatusGroup({
    super.key,
    required this.requiresJre,
    required this.jrePath,
    required this.jreExists,
    required this.extensionServerPath,
    required this.serverExists,
    required this.installedVersion,
    required this.latestVersion,
    this.releaseCheckMessage,
  });

  final bool requiresJre;
  final String jrePath;
  final bool jreExists;
  final String extensionServerPath;
  final bool serverExists;
  final String installedVersion;
  final String latestVersion;
  final String? releaseCheckMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ShioriSettingsGroup(
      title: l10n.status,
      footer: (releaseCheckMessage != null && releaseCheckMessage!.isNotEmpty)
          ? releaseCheckMessage
          : null,
      children: [
        if (requiresJre)
          _fileRow(context, l10n.jre_executable, jrePath, jreExists),
        _fileRow(
          context,
          l10n.extension_server_jar,
          extensionServerPath,
          serverExists,
        ),
        ShioriSettingRow(
          title: l10n.installed_version,
          subtitle: installedVersion.isEmpty ? l10n.unknown : installedVersion,
        ),
        ShioriSettingRow(
          title: l10n.latest_version,
          subtitle: latestVersion.isEmpty ? l10n.unknown : latestVersion,
        ),
      ],
    );
  }

  Widget _fileRow(
    BuildContext context,
    String label,
    String value,
    bool exists,
  ) {
    final c = context.shiori.color;
    return ShioriSettingRow(
      title: label,
      subtitle: value.isEmpty ? context.l10n.not_configured : value,
      trailing: Icon(
        exists ? Symbols.check_circle_rounded : Symbols.error_rounded,
        fill: 1,
        color: exists ? c.completed.foreground : c.offline.foreground,
      ),
    );
  }
}
