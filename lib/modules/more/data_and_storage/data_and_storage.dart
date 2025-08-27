import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class DataAndStorage extends ConsumerWidget {
  const DataAndStorage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupFrequency = ref.watch(backupFrequencyStateProvider);
    final autoBackupLocation = ref.watch(autoBackupLocationStateProvider);
    final downloadLocationState = ref.watch(downloadLocationStateProvider);
    final totalChapterCacheSize = ref.watch(totalChapterCacheSizeStateProvider);
    final clearChapterCacheOnAppLaunch = ref.watch(
      clearChapterCacheOnAppLaunchStateProvider,
    );
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.data_and_storage)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.download_location),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: downloadLocationState.$2.isEmpty
                              ? downloadLocationState.$1
                              : downloadLocationState.$2,
                          onChanged: (value) async {
                            if (value == downloadLocationState.$1) {
                              ref
                                  .read(downloadLocationStateProvider.notifier)
                                  .set("");
                              Navigator.pop(context);
                            } else {
                              String? result = await FilePicker.platform
                                  .getDirectoryPath();

                              if (result != null) {
                                ref
                                    .read(
                                      downloadLocationStateProvider.notifier,
                                    )
                                    .set(result);
                              } else {}
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          child: SuperListView(
                            shrinkWrap: true,
                            children: [
                              RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: downloadLocationState.$1,
                                title: Text(downloadLocationState.$1),
                              ),
                              RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: downloadLocationState.$2,
                                title: Text(l10n.custom_location),
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
              },
              title: Text(l10n.download_location),
              subtitle: Text(
                downloadLocationState.$2.isEmpty
                    ? downloadLocationState.$1
                    : downloadLocationState.$2,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
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
                  ],
                ),
              ),
              subtitle: Text(
                l10n.download_location_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                children: [
                  Text(
                    l10n.backup_and_restore,
                    style: TextStyle(fontSize: 13, color: context.primaryColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton(
                      emptySelectionAllowed: true,
                      showSelectedIcon: false,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      segments: [
                        ButtonSegment(
                          value: 'create',
                          label: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(l10n.create_backup),
                          ),
                        ),
                        ButtonSegment(
                          value: 'restore',
                          label: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(l10n.restore_backup),
                          ),
                        ),
                      ],
                      selected: {},
                      onSelectionChanged: (newSelection) {
                        if (newSelection.contains('create')) {
                          context.push('/createBackup');
                        } else if (newSelection.contains('restore')) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(l10n.restore_backup),
                                content: SizedBox(
                                  width: context.width(0.8),
                                  child: SuperListView(
                                    shrinkWrap: true,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline_rounded,
                                            color: context.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          l10n.restore_backup_warning_title,
                                        ),
                                      ),
                                    ],
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
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                      allowMultiple: false,
                                                    );

                                            if (result != null &&
                                                context.mounted) {
                                              ref.watch(
                                                doRestoreProvider(
                                                  path:
                                                      result.files.first.path!,
                                                  context: context,
                                                ),
                                              );
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
                        }
                      },
                    ),
                  ),
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
                        child: RadioGroup(
                          groupValue: backupFrequency,
                          onChanged: (value) {
                            ref
                                .read(backupFrequencyStateProvider.notifier)
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: index,
                                title: Row(children: [Text(list[index])]),
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
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.secondaryColor,
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                l10n.backup_and_restore_warning_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                children: [
                  Text(
                    l10n.storage,
                    style: TextStyle(fontSize: 13, color: context.primaryColor),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(l10n.clear_chapter_and_episode_cache),
              onTap: () => ref
                  .read(totalChapterCacheSizeStateProvider.notifier)
                  .clearCache(),
              subtitle: Text(
                totalChapterCacheSize,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            SwitchListTile(
              value: clearChapterCacheOnAppLaunch,
              title: Text(
                context.l10n.clear_chapter_or_episode_cache_on_app_launch,
              ),
              onChanged: (value) {
                ref
                    .read(clearChapterCacheOnAppLaunchStateProvider.notifier)
                    .set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _getBackupFrequencyList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.off,
    l10n.every_6_hours,
    l10n.every_12_hours,
    l10n.daily,
    l10n.every_2_days,
    l10n.weekly,
  ];
}
