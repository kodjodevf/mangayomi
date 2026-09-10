import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/sync_preference_repository.dart';
import 'package:mangayomi/modules/more/settings/appearance/appearance_screen.dart'
    show SettingsSection;
import 'package:mangayomi/modules/more/settings/sync/providers/sync_connection_status_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/widgets/sync_listile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
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
            final enabled = syncPreference.syncOn && connected && !progress.active;
            return Column(
              children: [
                // Account comes first: nothing else on this screen means
                // anything before you're logged in to a server.
                SettingsSection(
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
                SettingsSection(
                  title: l10n.sync_section_general,
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.sync),
                      value: syncPreference.syncOn,
                      title: Text(l10n.sync_on),
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
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      enabled: syncPreference.syncOn,
                      onTap: () => _showAutoSyncDialog(
                        context,
                        ref,
                        syncPreference,
                        autoSyncOptions,
                      ),
                      title: Text(l10n.sync_auto),
                      subtitle: Text(
                        autoSyncOptions.entries
                            .where(
                              (o) =>
                                  o.value == syncPreference.autoSyncFrequency,
                            )
                            .first
                            .key,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryColor,
                        ),
                      ),
                    ),
                    if (syncPreference.autoSyncFrequency > 0)
                      _hintTile(
                        context,
                        icon: Icons.warning_amber_outlined,
                        text: l10n.sync_auto_warning,
                      ),
                    if (syncPreference.lastSync != null)
                      ListTile(
                        leading: Icon(
                          Icons.history_toggle_off,
                          color: context.secondaryColor,
                        ),
                        title: Text(
                          "${l10n.last_sync} ${dateFormat(syncPreference.lastSync!.toString(), ref: ref, context: context)} ${dateFormatHour(syncPreference.lastSync!.toString(), context)}",
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: !enabled
                            ? null
                            : () {
                                ref
                                    .read(
                                      syncServerProvider(syncId: 1).notifier,
                                    )
                                    .startSync(l10n, false);
                              },
                        icon: const Icon(Icons.sync),
                        label: Text(l10n.sync_button_sync),
                      ),
                      OutlinedButton.icon(
                        onPressed: !enabled
                            ? null
                            : () => _showConfirmDialog(context, ref, true),
                        icon: const Icon(Icons.file_upload_outlined),
                        label: Text(l10n.sync_button_upload),
                      ),
                      OutlinedButton.icon(
                        onPressed: !enabled
                            ? null
                            : () => _showConfirmDialog(context, ref, false),
                        icon: const Icon(Icons.file_download_outlined),
                        label: Text(l10n.sync_button_download),
                      ),
                    ],
                  ),
                ),
                if (progress.active)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        LinearProgressIndicator(value: progress.fraction),
                        const SizedBox(height: 6),
                        Text(
                          progress.fraction != null
                              ? l10n.sync_progress_percent(
                                  (progress.fraction! * 100).round(),
                                )
                              : l10n.sync_progress_indeterminate,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                SettingsSection(
                  title: l10n.about,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 10,
                        top: 10,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () async {
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
                        label: Text(l10n.get_sync_server),
                        icon: const Icon(Icons.download_outlined),
                      ),
                    ),
                    _hintTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      text: l10n.syncing_subtitle,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _hintTile(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.secondaryColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                softWrap: true,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
          ],
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
        Icons.link_off,
        context.secondaryColor,
        l10n.sync_status_not_configured,
      ),
      SyncConnectionStatus.checking => (
        Icons.sync,
        context.secondaryColor,
        l10n.sync_status_checking,
      ),
      SyncConnectionStatus.connected => (
        Icons.check_circle,
        Colors.green,
        l10n.sync_status_connected,
      ),
      SyncConnectionStatus.unauthorized => (
        Icons.error_outline,
        Colors.red,
        l10n.sync_status_unauthorized,
      ),
      SyncConnectionStatus.unreachable => (
        Icons.error_outline,
        Colors.red,
        l10n.sync_status_unreachable,
      ),
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: TextStyle(fontSize: 13, color: color)),
      trailing: IconButton(
        icon: const Icon(Icons.refresh, size: 20),
        onPressed: () {
          ref.read(syncConnectionStateProvider(syncId: 1).notifier).recheck();
        },
      ),
    );
  }

  void _showAutoSyncDialog(
    BuildContext context,
    WidgetRef ref,
    SyncPreference syncPreference,
    Map<String, int> autoSyncOptions,
  ) {
    final l10n = l10nLocalizations(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.sync_auto),
          content: SizedBox(
            width: context.width(0.8),
            child: RadioGroup(
              groupValue: syncPreference.autoSyncFrequency,
              onChanged: (value) {
                ref
                    .read(synchingProvider(syncId: 1).notifier)
                    .setAutoSyncFrequency(value!);
                Navigator.pop(context);
              },
              child: SuperListView.builder(
                shrinkWrap: true,
                itemCount: autoSyncOptions.length,
                itemBuilder: (context, index) {
                  final optionName = autoSyncOptions.keys.elementAt(index);
                  final optionValue = autoSyncOptions.values.elementAt(index);
                  return RadioListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    value: optionValue,
                    title: Text(optionName),
                  );
                },
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    bool isUpload,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            isUpload
                ? context.l10n.sync_button_upload_info
                : context.l10n.sync_button_download_info,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(syncServerProvider(syncId: 1).notifier)
                        .startSync(
                          context.l10n,
                          false,
                          upload: isUpload,
                          download: !isUpload,
                        );
                    Navigator.pop(context);
                  },
                  child: Text(context.l10n.dialog_confirm),
                ),
              ],
            ),
          ],
        );
      },
    );
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
          return AlertDialog(
            title: Text(
              l10n.login_into("SyncServer"),
              style: const TextStyle(fontSize: 30),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: serverController,
                        autofocus: !isTv,
                        onChanged: (value) => setState(() {
                          server = value;
                        }),
                        decoration: InputDecoration(
                          hintText: l10n.sync_server,
                          filled: false,
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 0.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: context.width(1),
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: isLoading || server.trim().isEmpty
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                    errorMessage = "";
                                  });
                                  final res = await ref
                                      .read(
                                        syncServerProvider(syncId: 1).notifier,
                                      )
                                      .login(l10n, server);
                                  if (!res.$1) {
                                    setState(() {
                                      isLoading = false;
                                      errorMessage = res.$2;
                                    });
                                  } else {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.open_in_browser),
                          label: Text(l10n.sync_login_browser),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
