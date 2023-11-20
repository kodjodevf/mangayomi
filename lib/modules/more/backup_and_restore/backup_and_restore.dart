import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/backup.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/restore.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';

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
        title: const Text("Backup and restore"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              final list = _getList();
              List<int> indexList = [];
              indexList.addAll(backupFrequencyOptions);
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text(
                            "What do you want to backup?",
                          ),
                          content: SizedBox(
                              width: mediaWidth(context, 0.8),
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
                                          color: primaryColor(context)),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      String? result = await FilePicker.platform
                                          .getDirectoryPath();

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
                                          color: primaryColor(context)),
                                    )),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  });
            },
            title: const Text("Create backup"),
            subtitle: Text(
              "Can be used to restore current library",
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          ListTile(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['backup']);

              if (result != null && context.mounted) {
                ref.watch(doRestoreProvider(
                    path: result.files.first.path!, context: context));
              }
            },
            title: const Text("Restore backup"),
            subtitle: Text(
              "Restore library from backup file",
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Text('Automatic backups',
                    style:
                        TextStyle(fontSize: 13, color: primaryColor(context))),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    final list = _getBackupFrequencyList();
                    return AlertDialog(
                      title: const Text("Backup frequency"),
                      content: SizedBox(
                          width: mediaWidth(context, 0.8),
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
                                      .read(
                                          backupFrequencyStateProvider.notifier)
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
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: const Text("Backup frequency"),
            subtitle: Text(
              _getBackupFrequencyList()[backupFrequency],
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          ListTile(
            onTap: () async {
              String? result = await FilePicker.platform.getDirectoryPath();

              if (result != null) {
                ref.read(autoBackupLocationStateProvider.notifier).set(result);
              }
            },
            title: const Text('Backup location'),
            subtitle: Text(
              autoBackupLocation.$2.isEmpty
                  ? autoBackupLocation.$1
                  : autoBackupLocation.$2,
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          ListTile(
            onTap: () {
              final list = _getList();
              List<int> indexList = [];
              indexList.addAll(backupFrequencyOptions);
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text(
                            "What do you want to backup?",
                          ),
                          content: SizedBox(
                              width: mediaWidth(context, 0.8),
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
                                          color: primaryColor(context)),
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
                                          color: primaryColor(context)),
                                    )),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  });
            },
            title: const Text("Backup options"),
            subtitle: Text(
              "What information to include in the backup file",
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: secondaryColor(context),
                  ),
                ],
              ),
            ),
            subtitle: Text(
                "You should keep copies of backups in other places as well",
                style: TextStyle(fontSize: 11, color: secondaryColor(context))),
          )
        ],
      ),
    );
  }
}

List<String> _getList() {
  return [
    "Library entries",
    "Categories",
    "Chapters and episode",
    "Tracking",
    "History",
    "Settings",
    "Extensions"
  ];
}

List<String> _getBackupFrequencyList() {
  return [
    "Off",
    "Every 6 hours",
    "Every 12 hours",
    "Daily",
    "Every 2 days",
    "Weekly"
  ];
}
