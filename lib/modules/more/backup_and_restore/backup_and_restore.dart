import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/backup.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/restore.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';

class BackupAndRestore extends ConsumerWidget {
  const BackupAndRestore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
