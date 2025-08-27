import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/widgets/sync_listile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class SyncScreen extends ConsumerWidget {
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
      appBar: AppBar(title: Text(l10nLocalizations(context)!.syncing)),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: isar.syncPreferences.filter().syncIdIsNotNull().watch(
            fireImmediately: true,
          ),
          builder: (context, snapshot) {
            SyncPreference syncPreference = snapshot.data?.isNotEmpty ?? false
                ? snapshot.data?.first ?? SyncPreference()
                : SyncPreference();
            final bool isLogged = syncPreference.authToken?.isNotEmpty ?? false;
            return Column(
              children: [
                SwitchListTile(
                  value: syncPreference.syncOn,
                  title: Text(context.l10n.sync_on),
                  onChanged: (value) {
                    ref
                        .read(SynchingProvider(syncId: 1).notifier)
                        .setSyncOn(value);
                    if (!value) {
                      ref
                          .read(SynchingProvider(syncId: 1).notifier)
                          .setAutoSyncFrequency(0);
                    }
                  },
                ),
                ListTile(
                  enabled: syncPreference.syncOn,
                  onTap: () {
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
                                  final optionName = autoSyncOptions.keys
                                      .elementAt(index);
                                  final optionValue = autoSyncOptions.values
                                      .elementAt(index);
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
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text(l10n.sync_auto),
                  subtitle: Text(
                    autoSyncOptions.entries
                        .where(
                          (o) => o.value == syncPreference.autoSyncFrequency,
                        )
                        .first
                        .key,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: context.secondaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.sync_auto_warning,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SwitchListTile(
                  value: syncPreference.syncHistories,
                  title: Text(context.l10n.sync_enable_histories),
                  onChanged: syncPreference.syncOn
                      ? (value) {
                          ref
                              .read(SynchingProvider(syncId: 1).notifier)
                              .setSyncHistories(value);
                        }
                      : null,
                ),
                SwitchListTile(
                  value: syncPreference.syncUpdates,
                  title: Text(context.l10n.sync_enable_updates),
                  onChanged: syncPreference.syncOn
                      ? (value) {
                          ref
                              .read(SynchingProvider(syncId: 1).notifier)
                              .setSyncUpdates(value);
                        }
                      : null,
                ),
                SwitchListTile(
                  value: syncPreference.syncSettings,
                  title: Text(context.l10n.sync_enable_settings),
                  onChanged: syncPreference.syncOn
                      ? (value) {
                          ref
                              .read(SynchingProvider(syncId: 1).notifier)
                              .setSyncSettings(value);
                        }
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                    top: 5,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.services,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SyncListile(
                  enabled: syncPreference.syncOn,
                  onTap: () async {
                    _showDialogLogin(context, ref, syncPreference);
                  },
                  id: 1,
                  preference: syncPreference,
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: context.secondaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.syncing_subtitle,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.sync, color: context.secondaryColor),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            const SizedBox(width: 20),
                            Text(
                              "${l10n.last_sync_manga}: ${dateFormat((syncPreference.lastSyncManga ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastSyncManga ?? 0).toString(), context)}",
                              style: TextStyle(
                                fontSize: 11,
                                color: context.secondaryColor,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "${l10n.last_sync_history}: ${dateFormat((syncPreference.lastSyncHistory ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastSyncHistory ?? 0).toString(), context)}",
                              style: TextStyle(
                                fontSize: 11,
                                color: context.secondaryColor,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "${l10n.last_sync_update}: ${dateFormat((syncPreference.lastSyncUpdate ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastSyncUpdate ?? 0).toString(), context)}",
                              style: TextStyle(
                                fontSize: 11,
                                color: context.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        IconButton(
                          onPressed: !syncPreference.syncOn || !isLogged
                              ? null
                              : () {
                                  ref
                                      .read(
                                        syncServerProvider(syncId: 1).notifier,
                                      )
                                      .startSync(l10n, false);
                                },
                          icon: Icon(
                            Icons.sync,
                            color: !syncPreference.syncOn || !isLogged
                                ? context.secondaryColor
                                : context.primaryColor,
                          ),
                        ),
                        Text(l10n.sync_button_sync),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        IconButton(
                          onPressed: !syncPreference.syncOn || !isLogged
                              ? null
                              : () => _showConfirmDialog(context, ref, true),
                          icon: Icon(
                            Icons.file_upload_outlined,
                            color: !syncPreference.syncOn || !isLogged
                                ? context.secondaryColor
                                : context.primaryColor,
                          ),
                        ),
                        Text(l10n.sync_button_upload),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        IconButton(
                          onPressed: !syncPreference.syncOn || !isLogged
                              ? null
                              : () => _showConfirmDialog(context, ref, false),
                          icon: Icon(
                            Icons.file_download_outlined,
                            color: !syncPreference.syncOn || !isLogged
                                ? context.secondaryColor
                                : context.primaryColor,
                          ),
                        ),
                        Text(l10n.sync_button_download),
                      ],
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

  void _showDialogLogin(
    BuildContext context,
    WidgetRef ref,
    SyncPreference syncPreference,
  ) {
    final serverController = TextEditingController(text: syncPreference.server);
    final emailController = TextEditingController(text: syncPreference.email);
    final passwordController = TextEditingController();
    String server = "";
    String email = "";
    String password = "";
    String errorMessage = "";
    bool isLoading = false;
    bool obscureText = true;
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
            content: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: serverController,
                      autofocus: true,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: emailController,
                      autofocus: true,
                      onChanged: (value) => setState(() {
                        email = value;
                      }),
                      decoration: InputDecoration(
                        hintText: l10n.email_adress,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      onChanged: (value) => setState(() {
                        password = value;
                      }),
                      decoration: InputDecoration(
                        hintText: l10n.sync_password,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            obscureText = !obscureText;
                          }),
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
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
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: context.width(1),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final res = await ref
                                    .read(
                                      syncServerProvider(syncId: 1).notifier,
                                    )
                                    .login(l10n, server, email, password);
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
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text(l10n.login),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
