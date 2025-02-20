import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
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
    final syncProvider = ref.watch(synchingProvider(syncId: 1));
    final changedParts = ref.watch(synchingProvider(syncId: 1).notifier);
    final autoSyncFrequency =
        ref.watch(synchingProvider(syncId: 1)).autoSyncFrequency;
    final l10n = l10nLocalizations(context)!;
    final autoSyncOptions = {
      l10n.sync_auto_off: 0,
      l10n.sync_auto_30_seconds: 30,
      l10n.sync_auto_1_minute: 60,
      l10n.sync_auto_5_minutes: 300,
      l10n.sync_auto_10_minutes: 600,
      l10n.sync_auto_30_minutes: 1800,
      l10n.sync_auto_1_hour: 3600,
      l10n.sync_auto_3_hours: 10800,
      l10n.sync_auto_6_hours: 21600,
      l10n.sync_auto_12_hours: 43200,
    };
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
                  SwitchListTile(
                      value: syncProvider.syncOn,
                      title: Text(context.l10n.sync_on),
                      onChanged: !isLogged
                          ? null
                          : (value) {
                              ref
                                  .read(SynchingProvider(syncId: 1).notifier)
                                  .setSyncOn(value);
                            }),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                l10n.sync_auto,
                              ),
                              content: SizedBox(
                                  width: context.width(0.8),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: autoSyncOptions.length,
                                    itemBuilder: (context, index) {
                                      final optionName =
                                          autoSyncOptions.keys.elementAt(index);
                                      final optionValue = autoSyncOptions.values
                                          .elementAt(index);
                                      return RadioListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: optionValue,
                                        groupValue: autoSyncFrequency,
                                        onChanged: (value) {
                                          ref
                                              .read(synchingProvider(syncId: 1)
                                                  .notifier)
                                              .setAutoSyncFrequency(value!);
                                          Navigator.pop(context);
                                        },
                                        title: Text(optionName),
                                      );
                                    },
                                  )),
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
                                              color: context.primaryColor),
                                        )),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: Text(l10n.sync_auto),
                    subtitle: Text(
                      autoSyncOptions.entries
                          .where((o) => o.value == autoSyncFrequency)
                          .first
                          .key,
                      style: TextStyle(
                          fontSize: 11, color: context.secondaryColor),
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
                          Text(l10n.sync_auto_warning,
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 11, color: context.secondaryColor))
                        ],
                      ),
                    ),
                  ),
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
                              softWrap: true,
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
                                "${l10n.last_sync}: ${dateFormat((syncPreference.lastSync ?? 0).toString(), ref: ref, context: context)} ${dateFormatHour((syncPreference.lastSync ?? 0).toString(), context)}",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: context.secondaryColor)),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          IconButton(
                              onPressed: !isLogged
                                  ? null
                                  : () {
                                      ref
                                          .read(syncServerProvider(syncId: 1)
                                              .notifier)
                                          .startSync(l10n, false);
                                    },
                              icon: Icon(
                                Icons.sync,
                                color: !isLogged
                                    ? context.secondaryColor
                                    : context.primaryColor,
                              )),
                          Text(l10n.sync_button_sync),
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
                                                  l10n.sync_confirm_snapshot),
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
                                                              .createSnapshot(
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
                                Icons.save_as,
                                color: !isLogged
                                    ? context.secondaryColor
                                    : context.primaryColor,
                              )),
                          Text(l10n.sync_button_snapshot),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 30),
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
                      const SizedBox(width: 30),
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
                                                                  l10n,
                                                                  false,
                                                                  true);
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
                  ),
                  const SizedBox(height: 40),
                  buildChangedItemWidget(
                      l10n.sync_pending_manga,
                      changedParts.getChangedParts([
                        ActionType.addItem,
                        ActionType.removeItem,
                        ActionType.updateItem
                      ])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_chapter,
                      changedParts.getChangedParts([
                        ActionType.addChapter,
                        ActionType.removeChapter,
                        ActionType.updateChapter
                      ])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_category,
                      changedParts.getChangedParts([
                        ActionType.addCategory,
                        ActionType.removeCategory,
                        ActionType.renameCategory
                      ])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_history,
                      changedParts.getChangedParts([
                        ActionType.addHistory,
                        ActionType.clearHistory,
                        ActionType.removeHistory,
                        ActionType.updateHistory,
                      ])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_update,
                      changedParts.getChangedParts(
                          [ActionType.addUpdate, ActionType.clearUpdates])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_extension,
                      changedParts.getChangedParts([
                        ActionType.addExtension,
                        ActionType.clearExtension,
                        ActionType.removeExtension,
                        ActionType.updateExtension
                      ])),
                  const SizedBox(height: 15),
                  buildChangedItemWidget(
                      l10n.sync_pending_track,
                      changedParts.getChangedParts([
                        ActionType.addTrack,
                        ActionType.removeTrack,
                        ActionType.updateTrack
                      ])),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 5),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: !isLogged
                                ? null
                                : () async {
                                    final snapshots = await ref
                                        .read(syncServerProvider(syncId: 1)
                                            .notifier)
                                        .getSnapshots(l10n);
                                    if (context.mounted) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                l10n.sync_snapshots,
                                              ),
                                              content: SizedBox(
                                                  width: context.width(0.8),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: snapshots.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: Card(
                                                          child: Column(
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      elevation:
                                                                          0,
                                                                      shadowColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(0),
                                                                              bottomRight: Radius.circular(0),
                                                                              topRight: Radius.circular(10),
                                                                              topLeft: Radius.circular(10)))),
                                                                  onPressed: () {},
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .save),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              Text("${dateFormat((snapshots[index].createdAt!).toString(), ref: ref, context: context)} ${dateFormatHour((snapshots[index].createdAt!).toString(), context)}"))
                                                                    ],
                                                                  )),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return StatefulBuilder(
                                                                                    builder: (context, setState) {
                                                                                      return AlertDialog(
                                                                                        title: Text(
                                                                                          l10n.sync_load_snapshot,
                                                                                        ),
                                                                                        actions: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text(l10n.cancel)),
                                                                                              const SizedBox(
                                                                                                width: 15,
                                                                                              ),
                                                                                              TextButton(
                                                                                                  onPressed: () async {
                                                                                                    await ref.read(SyncServerProvider(syncId: 1).notifier).downloadSnapshot(l10n, snapshots[index].uuid!);
                                                                                                    if (context.mounted) {
                                                                                                      Navigator.pop(context);
                                                                                                    }
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    l10n.ok,
                                                                                                  )),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                });
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.cloud_download_outlined)),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return StatefulBuilder(
                                                                                    builder: (context, setState) {
                                                                                      return AlertDialog(
                                                                                        title: Text(
                                                                                          l10n.sync_delete_snapshot,
                                                                                        ),
                                                                                        actions: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Text(l10n.cancel)),
                                                                                              const SizedBox(
                                                                                                width: 15,
                                                                                              ),
                                                                                              TextButton(
                                                                                                  onPressed: () async {
                                                                                                    await ref.read(syncServerProvider(syncId: 1).notifier).deleteSnapshot(l10n, snapshots[index].uuid!);
                                                                                                    if (context.mounted) {
                                                                                                      Navigator.pop(context);
                                                                                                    }
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    l10n.ok,
                                                                                                  )),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                });
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.delete_outlined))
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          l10n.cancel,
                                                          style: TextStyle(
                                                              color: context
                                                                  .primaryColor),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    }
                                  },
                            child: Text(l10n.sync_browse_snapshots)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
      ),
    );
  }
}

Widget buildChangedItemWidget(String text, List<ChangedPart> changedParts) {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 5),
    child: Row(
      children: [
        Text(
          "$text: ${changedParts.length}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            background: Paint()
              ..color = changedParts.isEmpty
                  ? Color.fromARGB(125, 78, 182, 92)
                  : Color.fromARGB(123, 245, 233, 132)
              ..strokeWidth = 20
              ..strokeJoin = StrokeJoin.round
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
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
