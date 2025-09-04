import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:numberpicker/numberpicker.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final saveAsCBZArchiveState = ref.watch(saveAsCBZArchiveStateProvider);
    final onlyOnWifiState = ref.watch(onlyOnWifiStateProvider);
    final concurrentDownloads = ref.watch(concurrentDownloadsStateProvider);
    final localFolders = ref.watch(localFoldersStateProvider);
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.downloads)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              value: onlyOnWifiState,
              title: Text(l10n.only_on_wifi),
              onChanged: (value) {
                ref.read(onlyOnWifiStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: saveAsCBZArchiveState,
              title: Text(l10n.save_as_cbz_archive),
              onChanged: (value) {
                ref.read(saveAsCBZArchiveStateProvider.notifier).set(value);
              },
            ),
            ListTile(
              onTap: () {
                int currentIntValue = concurrentDownloads;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.concurrent_downloads),
                      content: StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NumberPicker(
                                value: currentIntValue,
                                minValue: 1,
                                maxValue: 255,
                                step: 1,
                                haptics: true,
                                textMapper: (numberText) => numberText,
                                onChanged: (value) =>
                                    setState(() => currentIntValue = value),
                              ),
                            ],
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
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                ref
                                    .read(
                                      concurrentDownloadsStateProvider.notifier,
                                    )
                                    .set(currentIntValue);
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.ok,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.concurrent_downloads),
              subtitle: Text(
                "$concurrentDownloads",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () async => ref.read(scanLocalLibraryProvider.future),
              title: Text(context.l10n.rescan_local_folder),
            ),
            ListTile(
              onTap: () async {
                final result = await FilePicker.platform.getDirectoryPath();
                if (result != null) {
                  final temp = localFolders.toList();
                  temp.add(result);
                  ref.read(localFoldersStateProvider.notifier).set(temp);
                }
              },
              title: Text(context.l10n.add_local_folder),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      context.l10n.local_folder,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getLocalLibrary(),
                    builder: (context, snapshot) => snapshot.data?.path != null
                        ? _buildLocalFolder(
                            l10n,
                            localFolders,
                            snapshot.data!.path,
                            isDefault: true,
                          )
                        : Container(),
                  ),
                  ...localFolders.map(
                    (e) => _buildLocalFolder(l10n, localFolders, e),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalFolder(
    AppLocalizations l10n,
    List<String> localFolders,
    String folder, {
    bool isDefault = false,
  }) {
    return Padding(
      key: Key('folder_${folder.hashCode}'),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
              ),
              onPressed: null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.label_outline_rounded),
                  const SizedBox(width: 10),
                  Expanded(child: Text(folder)),
                ],
              ),
            ),
            if (!isDefault)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(l10n.delete),
                                    content: Text("${l10n.delete} $folder"),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(l10n.cancel),
                                          ),
                                          const SizedBox(width: 15),
                                          TextButton(
                                            onPressed: () {
                                              final temp = localFolders
                                                  .toList();
                                              temp.removeAt(
                                                temp.indexOf(folder),
                                              );
                                              ref
                                                  .read(
                                                    localFoldersStateProvider
                                                        .notifier,
                                                  )
                                                  .set(temp);
                                              Navigator.pop(context);
                                            },
                                            child: Text(l10n.ok),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
