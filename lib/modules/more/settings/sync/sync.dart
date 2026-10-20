import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/sync_preference_repository.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_connection_status_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/widgets/sync_listile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class SyncScreen extends ConsumerWidget {
  static const serverUrl = "https://github.com/Schnitzel5/mangayomi-server";

  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final autoSyncOptions = {
      l10n.sync_auto_off: 0,
      l10n.sync_auto_5_minutes: 300,
      l10n.sync_auto_10_minutes: 600,
      l10n.sync_auto_30_minutes: 1800,
      l10n.sync_auto_1_hour: 3600,
      l10n.sync_auto_3_hours: 10800,
      l10n.sync_auto_6_hours: 21600,
      l10n.sync_auto_12_hours: 43200,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncing)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: StreamBuilder(
          stream: syncPreferenceRepository.watchAllWithSyncId(),
          builder: (context, snapshot) {
            SyncPreference syncPreference = snapshot.data?.isNotEmpty ?? false
                ? snapshot.data?.first ?? SyncPreference()
                : SyncPreference();
            final bool isLogged = syncPreference.authToken?.isNotEmpty ?? false;
            final connectionStatus = ref.watch(
              syncConnectionStateProvider(syncId: 1),
            );
            final bool connected =
                connectionStatus == SyncConnectionStatus.connected;
            final progress = ref.watch(syncProgressProvider(syncId: 1));
            final enabled =
                syncPreference.syncOn && connected && !progress.active;
            final frequencyChoices = [
              for (final e in autoSyncOptions.entries)
                ShioriChoice(e.value, e.key),
            ];
            return Column(
              children: [
                // Account comes first: nothing else on this screen means
                // anything before you're logged in to a server.
                ShioriSettingsGroup(
                  title: l10n.services,
                  children: [
                    SyncListile(
                      onTap: () =>
                          _showDialogLogin(context, ref, syncPreference),
                      id: 1,
                      preference: syncPreference,
                    ),
                    if (isLogged)
                      _connectionStatusTile(context, ref, connectionStatus),
                  ],
                ),
                ShioriSettingsGroup(
                  title: l10n.sync_section_general,
                  footer: syncPreference.autoSyncFrequency > 0
                      ? l10n.sync_auto_warning
                      : null,
                  children: [
                    ShioriSwitchRow(
                      icon: Symbols.sync_rounded,
                      title: l10n.sync_on,
                      value: syncPreference.syncOn,
                      onChanged: !isLogged
                          ? null
                          : (value) {
                              ref
                                  .read(synchingProvider(syncId: 1).notifier)
                                  .setSyncOn(value);
                              if (!value) {
                                ref
                                    .read(synchingProvider(syncId: 1).notifier)
                                    .setAutoSyncFrequency(0);
                              }
                            },
                    ),
                    ShioriValueRow<int>(
                      icon: Symbols.schedule_rounded,
                      title: l10n.sync_auto,
                      value: syncPreference.autoSyncFrequency,
                      options: frequencyChoices,
                      onChanged: !syncPreference.syncOn
                          ? null
                          : (v) => ref
                                .read(synchingProvider(syncId: 1).notifier)
                                .setAutoSyncFrequency(v),
                    ),
                    if (syncPreference.lastSync != null)
                      ShioriSettingRow(
                        icon: Symbols.history_toggle_off_rounded,
                        title: l10n.last_sync,
                        subtitle:
                            "${dateFormat(syncPreference.lastSync!.toString(), ref: ref, context: context)} ${dateFormatHour(syncPreference.lastSync!.toString(), context)}",
                      ),
                    // The three ways to sync as rows of the group, like every
                    // other action in the settings, rather than buttons of
                    // three widths centred under it.
                    ShioriSettingRow(
                      icon: Symbols.sync_rounded,
                      title: l10n.sync_button_sync,
                      enabled: enabled,
                      onTap: () => ref
                          .read(syncServerProvider(syncId: 1).notifier)
                          .startSync(l10n, false),
                    ),
                    ShioriSettingRow(
                      icon: Symbols.file_upload_rounded,
                      title: l10n.sync_button_upload,
                      enabled: enabled,
                      onTap: () => _confirmOneWay(context, ref, true),
                    ),
                    ShioriSettingRow(
                      icon: Symbols.file_download_rounded,
                      title: l10n.sync_button_download,
                      enabled: enabled,
                      onTap: () => _confirmOneWay(context, ref, false),
                    ),
                  ],
                ),
                if (progress.active)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ShioriSpace.s16,
                      vertical: ShioriSpace.s8,
                    ),
                    child: Column(
                      spacing: ShioriSpace.s8,
                      children: [
                        ShioriProgressBar(value: progress.fraction),
                        Text(
                          progress.fraction != null
                              ? l10n.sync_progress_percent(
                                  (progress.fraction! * 100).round(),
                                )
                              : l10n.sync_progress_indeterminate,
                          style: context.shiori.caption,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: ShioriSpace.s16),
                ShioriSettingsGroup(
                  title: l10n.about,
                  footer: l10n.syncing_subtitle,
                  children: [
                    ShioriSettingRow(
                      icon: Symbols.open_in_new_rounded,
                      title: l10n.get_sync_server,
                      subtitle: serverUrl,
                      onTap: () async {
                        if (!await launchUrl(
                          Uri.parse(serverUrl),
                          mode: LaunchMode.externalApplication,
                        )) {
                          AppLogger.log(
                            'Could not launch $serverUrl',
                            logLevel: LogLevel.error,
                          );
                          botToast(l10n.could_not_launch_url(serverUrl));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: ShioriSpace.s24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _connectionStatusTile(
    BuildContext context,
    WidgetRef ref,
    SyncConnectionStatus status,
  ) {
    final l10n = l10nLocalizations(context)!;
    final (icon, color, label) = switch (status) {
      SyncConnectionStatus.notConfigured => (
        Symbols.link_off_rounded,
        context.shiori.color.fgMuted,
        l10n.sync_status_not_configured,
      ),
      SyncConnectionStatus.checking => (
        Symbols.sync_rounded,
        context.shiori.color.fgMuted,
        l10n.sync_status_checking,
      ),
      SyncConnectionStatus.connected => (
        Symbols.check_circle_rounded,
        context.shiori.color.completed.foreground,
        l10n.sync_status_connected,
      ),
      SyncConnectionStatus.unauthorized => (
        Symbols.error_rounded,
        context.shiori.color.error.foreground,
        l10n.sync_status_unauthorized,
      ),
      SyncConnectionStatus.unreachable => (
        Symbols.error_rounded,
        context.shiori.color.offline.foreground,
        l10n.sync_status_unreachable,
      ),
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: context.shiori.text.row.copyWith(color: color)),
      trailing: IconButton(
        tooltip: context.l10n.refresh,
        icon: const Icon(Symbols.refresh_rounded, fill: 1, size: 20),
        onPressed: () {
          ref.read(syncConnectionStateProvider(syncId: 1).notifier).recheck();
        },
      ),
    );
  }

  /// Upload or download replaces one side with the other: asks first.
  Future<void> _confirmOneWay(
    BuildContext context,
    WidgetRef ref,
    bool isUpload,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showShioriConfirm(
      context,
      title: isUpload ? l10n.sync_button_upload : l10n.sync_button_download,
      message: isUpload
          ? l10n.sync_button_upload_info
          : l10n.sync_button_download_info,
      confirmLabel: l10n.dialog_confirm,
      destructive: true,
    );
    if (!confirmed) return;
    ref
        .read(syncServerProvider(syncId: 1).notifier)
        .startSync(l10n, false, upload: isUpload, download: !isUpload);
  }

  // Only a server address is asked for here - there's no username/password
  // field. Logging in opens the system browser to that server's own login
  // page (OAuth/PKCE against the server's /api/oauth/authorize), so this
  // dialog never sees or handles a credential itself.
  void _showDialogLogin(
    BuildContext context,
    WidgetRef ref,
    SyncPreference syncPreference,
  ) {
    final serverController = TextEditingController(text: syncPreference.server);
    String server = syncPreference.server ?? "";
    String errorMessage = "";
    bool isLoading = false;
    final l10n = l10nLocalizations(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> login() async {
            setState(() {
              isLoading = true;
              errorMessage = "";
            });
            final res = await ref
                .read(syncServerProvider(syncId: 1).notifier)
                .login(l10n, server);
            if (!res.$1) {
              setState(() {
                isLoading = false;
                errorMessage = res.$2;
              });
            } else if (context.mounted) {
              Navigator.pop(context);
            }
          }

          final canLogin = !isLoading && server.trim().isNotEmpty;
          return ShioriDialog(
            title: l10n.login_into("SyncServer"),
            content: TextField(
              controller: serverController,
              autofocus: !isTv,
              keyboardType: TextInputType.url,
              onChanged: (value) => setState(() => server = value),
              onSubmitted: (_) => canLogin ? login() : null,
              decoration: InputDecoration(
                labelText: l10n.sync_server,
                errorText: errorMessage.isEmpty ? null : errorMessage,
                errorMaxLines: 3,
              ),
            ),
            actions: [
              ShioriButton.quiet(
                label: l10n.cancel,
                onPressed: () => Navigator.pop(context),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(ShioriSpace.s8),
                  child: ShioriLoading.inline(),
                )
              else
                ShioriButton(
                  icon: Symbols.open_in_browser_rounded,
                  label: l10n.sync_login_browser,
                  onPressed: canLogin ? login : null,
                ),
            ],
          );
        },
      ),
    );
  }
}
