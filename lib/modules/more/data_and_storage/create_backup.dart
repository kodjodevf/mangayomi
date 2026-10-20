import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';

class CreateBackup extends ConsumerStatefulWidget {
  const CreateBackup({super.key});

  @override
  ConsumerState<CreateBackup> createState() => _CreateBackupState();
}

class _CreateBackupState extends ConsumerState<CreateBackup> {
  late final List<(String, int)> _libraryList = _getLibraryList(context);
  late final List<(String, int)> _settingsList = _getSettingsList(context);
  late final List<(String, int)> _extensionList = _getExtensionsList(context);

  void _set(int index, List<int> indexList) {
    if (indexList.contains(index)) {
      ref
          .read(backupFrequencyOptionsStateProvider.notifier)
          .set(indexList.where((e) => e != index).toList());
    } else {
      ref.read(backupFrequencyOptionsStateProvider.notifier).set([
        ...indexList,
        index,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final indexList = ref.watch(backupFrequencyOptionsStateProvider);
    ShioriSettingsGroup group(String title, List<(String, int)> items) =>
        ShioriSettingsGroup(
          title: title,
          children: [
            for (final (label, idx) in items)
              ShioriSwitchRow(
                title: label,
                value: indexList.contains(idx),
                onChanged: (_) => _set(idx, indexList),
              ),
          ],
        );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.create_backup)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          group(l10n.library, _libraryList),
          group(l10n.settings, _settingsList),
          group(l10n.extensions, _extensionList),
        ],
      ),
      // The one action of the screen, in reach without scrolling to the end.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ShioriSpace.s16),
          child: ShioriButton(
            expand: true,
            icon: Symbols.save_rounded,
            label: l10n.create,
            onPressed: indexList.isEmpty
                ? null
                : () async {
                    String? result;
                    if (Platform.isIOS) {
                      result =
                          (await StorageProvider().getIosBackupDirectory())!
                              .path;
                    } else {
                      result = await FilePicker.getDirectoryPath(
                        linuxOptions: const LinuxOptions(
                          lockParentWindow: true,
                        ),
                      );
                    }
                    if (result != null && context.mounted) {
                      ref.read(
                        doBackUpProvider(
                          list: indexList,
                          path: result,
                          context: context,
                        ),
                      );
                    }
                  },
          ),
        ),
      ),
    );
  }
}

List<(String, int)> _getLibraryList(BuildContext context) {
  final l10n = context.l10n;
  return [
    (l10n.library_entries, 0),
    (l10n.categories, 1),
    (l10n.chapters_and_episode, 2),
    (l10n.tracking, 3),
    (l10n.history, 4),
    (l10n.updates, 5),
  ];
}

List<(String, int)> _getSettingsList(BuildContext context) {
  final l10n = context.l10n;
  return [
    (l10n.app_settings, 6),
    (l10n.custom_buttons, 10),
    (l10n.sources_settings, 7),
    (l10n.include_sensitive_settings, 8),
  ];
}

List<(String, int)> _getExtensionsList(BuildContext context) {
  final l10n = context.l10n;
  return [(l10n.extensions, 9)];
}
