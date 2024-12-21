import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/widgets/sync_listile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10nLocalizations(context)!.syncing),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: isar.syncPreferences
                .filter()
                .syncIdIsNotNull()
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              SyncPreference syncPreference = snapshot.data?.isNotEmpty ?? false
                  ? snapshot.data?.first ?? SyncPreference()
                  : SyncPreference();
              final bool isLogged =
                  syncPreference.authToken?.isNotEmpty ?? false;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 5),
                    child: Row(
                      children: [
                        Text(l10n.services,
                            style: TextStyle(
                                fontSize: 13, color: context.primaryColor)),
                      ],
                    ),
                  ),
                  SyncListile(
                    onTap: () async {
                      _showDialogLogin(context, ref);
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
                          Text(l10n.syncing_subtitle,
                              style: TextStyle(
                                  fontSize: 11, color: context.secondaryColor))
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sync,
                            color: context.secondaryColor,
                          ),
                          const SizedBox(width: 10),
                          Column(children: [
                            const SizedBox(width: 20),
                            Text(
                                "${l10n.last_upload}: ${dateFormat((syncPreference.lastUpload ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastUpload ?? 0).toString(), context)}",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: context.secondaryColor)),
                            const SizedBox(width: 20),
                            Text(
                                "${l10n.last_download}: ${dateFormat((syncPreference.lastDownload ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastDownload ?? 0).toString(), context)}",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: context.secondaryColor)),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          IconButton(
                              onPressed: !isLogged
                                  ? null
                                  : () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  l10n.sync_confirm_upload),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            surfaceTintColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    color: context
                                                                        .secondaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          l10n.cancel,
                                                          style: TextStyle(
                                                              color: context
                                                                  .secondaryColor),
                                                        )),
                                                    const SizedBox(width: 15),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor: Colors
                                                                    .red
                                                                    .withValues(
                                                                        alpha:
                                                                            0.7)),
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                  syncServerProvider(
                                                                          syncId:
                                                                              1)
                                                                      .notifier)
                                                              .uploadToServer(
                                                                  l10n);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          l10n.dialog_confirm,
                                                          style: TextStyle(
                                                              color: context
                                                                  .secondaryColor),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                              icon: Icon(
                                Icons.cloud_upload_outlined,
                                color: !isLogged
                                    ? context.secondaryColor
                                    : context.primaryColor,
                              )),
                          Text(l10n.sync_button_upload),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          IconButton(
                              onPressed: !isLogged
                                  ? null
                                  : () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  l10n.sync_confirm_download),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            surfaceTintColor:
                                                                Colors
                                                                    .transparent,
                                                            shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    color: context
                                                                        .secondaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          l10n.cancel,
                                                          style: TextStyle(
                                                              color: context
                                                                  .secondaryColor),
                                                        )),
                                                    const SizedBox(width: 15),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor: Colors
                                                                    .red
                                                                    .withValues(
                                                                        alpha:
                                                                            0.7)),
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                  syncServerProvider(
                                                                          syncId:
                                                                              1)
                                                                      .notifier)
                                                              .downloadFromServer(
                                                                  l10n);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          l10n.dialog_confirm,
                                                          style: TextStyle(
                                                              color: context
                                                                  .secondaryColor),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                              icon: Icon(
                                Icons.cloud_download_outlined,
                                color: !isLogged
                                    ? context.secondaryColor
                                    : context.primaryColor,
                              )),
                          Text(l10n.sync_button_download),
                        ],
                      ),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}

void _showDialogLogin(BuildContext context, WidgetRef ref) {
  final serverController = TextEditingController();
  final emailController = TextEditingController();
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
    builder: (context) => StatefulBuilder(builder: (context, setState) {
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
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide()))),
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
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide()))),
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
                            icon: Icon(obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined)),
                        filled: false,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 0.4),
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(),
                            borderRadius: BorderRadius.circular(5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide()))),
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
                                        syncServerProvider(syncId: 1).notifier)
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
                            : Text(l10n.login))),
              )
            ],
          ),
        ),
      );
    }),
  );
}
