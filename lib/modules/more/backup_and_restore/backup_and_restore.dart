import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/backup.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/restore.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class BackupAndRestore extends ConsumerWidget {
  const BackupAndRestore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupFrequency = ref.watch(backupFrequencyStateProvider);
    final backupFrequencyOptions =
        ref.watch(backupFrequencyOptionsStateProvider);
    final autoBackupLocation = ref.watch(autoBackupLocationStateProvider);
    ref.read(autoBackupLocationStateProvider.notifier).refresh();

    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backup_and_restore),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                final list = _getList(context);
                List<int> indexList = [];
                indexList.addAll(backupFrequencyOptions);
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text(l10n.create_backup_dialog_title),
                            content: SizedBox(
                                width: context.width(0.8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return ListTileChapterFilter(
                                        label: list[index],
                                        type: indexList.contains(index) ? 1 : 0,
                                        onTap: () {
                                          if (indexList.contains(index)) {
                                            setState(() {
                                              indexList.remove(index);
                                            });
                                          } else {
                                            setState(() {
                                              indexList.add(index);
                                            });
                                          }
                                        });
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
                                  TextButton(
                                      onPressed: () async {
                                        String? result;
                                        if (Platform.isIOS) {
                                          result = (await StorageProvider()
                                                  .getIosBackupDirectory())!
                                              .path;
                                        } else {
                                          result = await FilePicker.platform
                                              .getDirectoryPath();
                                        }

                                        if (result != null && context.mounted) {
                                          ref.watch(doBackUpProvider(
                                              list: indexList,
                                              path: result,
                                              context: context));
                                        }
                                      },
                                      child: Text(
                                        l10n.ok,
                                        style: TextStyle(
                                            color: context.primaryColor),
                                      )),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    });
              },
              title: Text(l10n.create_backup),
              subtitle: Text(
                l10n.create_backup_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.restore_backup),
                        content: SizedBox(
                            width: context.width(0.8),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded,
                                        color: context.secondaryColor),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child:
                                      Text(l10n.restore_backup_warning_title),
                                ),
                              ],
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
                                    style:
                                        TextStyle(color: context.primaryColor),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(allowMultiple: false, 
                                                  type: FileType.custom, 
                                                  allowedExtensions: ["backup"]);

                                      if (result != null && context.mounted) {
                                        ref.watch(doRestoreProvider(
                                            path: result.files.first.path!,
                                            context: context));
                                      }
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                    } catch (_) {
                                      botToast("Error");
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    l10n.ok,
                                    style:
                                        TextStyle(color: context.primaryColor),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.restore_backup),
              subtitle: Text(
                l10n.restore_backup_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                children: [
                  Text(l10n.automatic_backups,
                      style:
                          TextStyle(fontSize: 13, color: context.primaryColor)),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      final list = _getBackupFrequencyList(context);
                      return AlertDialog(
                        title: Text(l10n.backup_frequency),
                        content: SizedBox(
                            width: context.width(0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  groupValue: backupFrequency,
                                  onChanged: (value) {
                                    ref
                                        .read(backupFrequencyStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text(list[index])],
                                  ),
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
                                    style:
                                        TextStyle(color: context.primaryColor),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.backup_frequency),
              subtitle: Text(
                _getBackupFrequencyList(context)[backupFrequency],
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            if (!Platform.isIOS)
              ListTile(
                onTap: () async {
                  String? result = await FilePicker.platform.getDirectoryPath();

                  if (result != null) {
                    ref
                        .read(autoBackupLocationStateProvider.notifier)
                        .set(result);
                  }
                },
                title: Text(l10n.backup_location),
                subtitle: Text(
                  autoBackupLocation.$2.isEmpty
                      ? autoBackupLocation.$1
                      : autoBackupLocation.$2,
                  style: TextStyle(fontSize: 11, color: context.secondaryColor),
                ),
              ),
            ListTile(
              onTap: () {
                final list = _getList(context);
                List<int> indexList = [];
                indexList.addAll(backupFrequencyOptions);
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text(
                              l10n.backup_options_subtitle,
                            ),
                            content: SizedBox(
                                width: context.width(0.8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return ListTileChapterFilter(
                                        label: list[index],
                                        type: indexList.contains(index) ? 1 : 0,
                                        onTap: () {
                                          if (indexList.contains(index)) {
                                            setState(() {
                                              indexList.remove(index);
                                            });
                                          } else {
                                            setState(() {
                                              indexList.add(index);
                                            });
                                          }
                                        });
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
                                  TextButton(
                                      onPressed: () async {
                                        ref
                                            .read(
                                                backupFrequencyOptionsStateProvider
                                                    .notifier)
                                            .set(indexList);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        l10n.ok,
                                        style: TextStyle(
                                            color: context.primaryColor),
                                      )),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    });
              },
              title: Text(l10n.backup_options),
              subtitle: Text(
                l10n.backup_options_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: context.secondaryColor),
                  ],
                ),
              ),
              subtitle: Text(l10n.backup_and_restore_warning_info,
                  style:
                      TextStyle(fontSize: 11, color: context.secondaryColor)),
            )
          ],
        ),
      ),
    );
  }
}

List<String> _getList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.library_entries,
    l10n.categories,
    l10n.chapters_and_episode,
    l10n.tracking,
    l10n.history,
    l10n.settings,
    l10n.extensions
  ];
}

List<String> _getBackupFrequencyList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.off,
    l10n.every_6_hours,
    l10n.every_12_hours,
    l10n.daily,
    l10n.every_2_days,
    l10n.weekly
  ];
}
