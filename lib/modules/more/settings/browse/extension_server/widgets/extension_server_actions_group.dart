import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Shiori settings group providing main download/update actions and install folder configuration.
class ExtensionServerActionsGroup extends StatelessWidget {
  const ExtensionServerActionsGroup({
    super.key,
    required this.isChecking,
    required this.isInstalled,
    required this.statusLabel,
    required this.versions,
    required this.isDownloading,
    required this.onRefreshStatus,
    required this.canDownloadOrUpdate,
    required this.onDownloadOrUpdate,
    required this.actionIcon,
    required this.actionLabel,
    required this.totalBytes,
    required this.receivedBytes,
    required this.selectedInstallDirectory,
    required this.requiresJre,
    required this.onChooseInstallDirectory,
    required this.canDetectFilesInSelectedFolder,
    required this.onUseExistingLocation,
  });

  final bool isChecking;
  final bool isInstalled;
  final String statusLabel;
  final String versions;
  final bool isDownloading;
  final VoidCallback onRefreshStatus;
  final bool canDownloadOrUpdate;
  final VoidCallback onDownloadOrUpdate;
  final IconData actionIcon;
  final String actionLabel;
  final int totalBytes;
  final int receivedBytes;
  final String selectedInstallDirectory;
  final bool requiresJre;
  final VoidCallback onChooseInstallDirectory;
  final bool canDetectFilesInSelectedFolder;
  final VoidCallback onUseExistingLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;

    return ShioriSettingsGroup(
      title: l10n.mihon_proxy_server,
      children: [
        ShioriSettingRow(
          icon: isChecking
              ? Symbols.sync_rounded
              : (isInstalled
                    ? Symbols.check_circle_rounded
                    : Symbols.error_rounded),
          title: statusLabel,
          subtitle: versions.isEmpty ? null : versions,
          onTap: isDownloading ? null : onRefreshStatus,
          trailing: ShioriButton(
            onPressed: canDownloadOrUpdate ? onDownloadOrUpdate : null,
            icon: actionIcon,
            label: actionLabel,
          ),
        ),
        if (isDownloading)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s4,
              ShioriSpace.s16,
              ShioriSpace.s12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ShioriSpace.s8,
              children: [
                ShioriProgressBar(
                  value: totalBytes > 0 ? receivedBytes / totalBytes : null,
                ),
                Text(
                  totalBytes > 0
                      ? '${(receivedBytes / 1048576).toStringAsFixed(2)}/${(totalBytes / 1048576).toStringAsFixed(2)} MB'
                      : l10n.preparing_download,
                  style: tokens.caption,
                ),
              ],
            ),
          ),
        ShioriSettingRow(
          icon: Symbols.folder_open_rounded,
          title: Platform.isIOS
              ? l10n.app_install_location
              : l10n.install_location,
          subtitle: selectedInstallDirectory.isEmpty
              ? l10n.not_configured
              : selectedInstallDirectory,
          onTap: requiresJre && !isDownloading
              ? onChooseInstallDirectory
              : null,
        ),
        ShioriSettingRow(
          icon: Symbols.link_rounded,
          title: Platform.isIOS
              ? l10n.import_existing_jar
              : l10n.detect_files_in_selected_folder,
          enabled: !isDownloading && canDetectFilesInSelectedFolder,
          onTap: onUseExistingLocation,
        ),
      ],
    );
  }
}
