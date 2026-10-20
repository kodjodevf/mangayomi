import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/library_cleanup_rows.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_compression.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_encryption.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/backup_encryption_password_dialog.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/rollback_last_change_tile.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/source_management_tiles.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/unified_restore.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/backup_password_storage.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
    final compression = ref.watch(backupCompressionLevelProvider);
    final backupEncryptionEnabled = ref.watch(backupEncryptionEnabledProvider);
    final downloadPath = downloadLocationState.$2.isEmpty
        ? downloadLocationState.$1
        : downloadLocationState.$2;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.data_and_storage)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            footer: l10n.download_location_info,
            children: [
              ShioriSettingRow(
                autofocus: isTv,
                icon: Symbols.folder_open_rounded,
                title: l10n.download_location,
                subtitle: downloadPath,
                onTap: () =>
                    _pickDownloadLocation(context, ref, downloadLocationState),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.backup_and_restore,
            footer: l10n.backup_and_restore_warning_info,
            children: [
              // Two actions, not a choice: they were drawn as a segmented
              // control with nothing selected, which a screen reader reads
              // as a pair of toggles.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s16,
                  vertical: ShioriSpace.s8,
                ),
                // Side by side where both labels fit; stacked on a phone,
                // where long labels (French, German…) were cut.
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final create = ShioriButton(
                      expand: true,
                      icon: Symbols.save_rounded,
                      label: l10n.create_backup,
                      onPressed: () => context.push('/createBackup'),
                    );
                    final restore = ShioriButton.secondary(
                      expand: true,
                      icon: Symbols.settings_backup_restore_rounded,
                      label: l10n.restore_backup,
                      onPressed: () => performRestore(context, ref),
                    );
                    if (constraints.maxWidth < 520) {
                      return Column(
                        spacing: ShioriSpace.s8,
                        children: [create, restore],
                      );
                    }
                    return Row(
                      spacing: ShioriSpace.s12,
                      children: [
                        Expanded(child: create),
                        Expanded(child: restore),
                      ],
                    );
                  },
                ),
              ),
              const RollbackLastChangeTile(),
              ShioriValueRow<int>(
                icon: Symbols.schedule_rounded,
                title: l10n.backup_frequency,
                value: backupFrequency,
                options: [
                  for (final (i, name) in _getBackupFrequencyList(
                    context,
                  ).indexed)
                    ShioriChoice(i, name),
                ],
                onChanged: (v) =>
                    ref.read(backupFrequencyStateProvider.notifier).set(v),
              ),
              if (!Platform.isIOS)
                ShioriSettingRow(
                  icon: Symbols.folder_rounded,
                  title: l10n.backup_location,
                  subtitle: autoBackupLocation.$2.isEmpty
                      ? autoBackupLocation.$1
                      : autoBackupLocation.$2,
                  onTap: () async {
                    final result = await FilePicker.getDirectoryPath(
                      linuxOptions: const LinuxOptions(lockParentWindow: true),
                    );
                    if (result != null) {
                      ref
                          .read(autoBackupLocationStateProvider.notifier)
                          .set(result);
                    }
                  },
                ),
              ShioriSwitchRow(
                icon: Symbols.lock_rounded,
                title: l10n.encrypt_backups,
                subtitle: l10n.encrypt_backups_info,
                value: backupEncryptionEnabled,
                onChanged: (value) async {
                  if (!value) {
                    await ref
                        .read(backupEncryptionEnabledProvider.notifier)
                        .set(false);
                    await BackupPasswordStorage.clear();
                    return;
                  }
                  final saved = await showBackupEncryptionPasswordDialog(
                    context,
                  );
                  if (saved == true) {
                    await ref
                        .read(backupEncryptionEnabledProvider.notifier)
                        .set(true);
                  }
                },
              ),
              ShioriSliderRow(
                icon: Symbols.compress_rounded,
                title: l10n.compression_level,
                subtitle: l10n.compression_info(
                  DeflateLevel.defaultCompression,
                ),
                value: compression.toDouble(),
                min: 0,
                max: 9,
                divisions: 9,
                defaultValue: DeflateLevel.defaultCompression.toDouble(),
                onReset: () => ref
                    .read(backupCompressionLevelProvider.notifier)
                    .set(DeflateLevel.defaultCompression),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(backupCompressionLevelProvider.notifier)
                    .update(v.round()),
                onChangeEnd: (v) => ref
                    .read(backupCompressionLevelProvider.notifier)
                    .set(v.round()),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_library_maintenance,
            children: const [
              MissingSourceCheckTile(),
              MergeDuplicateMangaTile(),
              DeleteSourceTile(),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_cleanup,
            children: const [LibraryCleanupRows()],
          ),
          ShioriSettingsGroup(
            title: l10n.storage,
            children: [
              ShioriSettingRow(
                icon: Symbols.cleaning_services_rounded,
                title: l10n.clear_chapter_and_episode_cache,
                subtitle: totalChapterCacheSize,
                onTap: () => ref
                    .read(totalChapterCacheSizeStateProvider.notifier)
                    .clearCache(),
              ),
              ShioriSwitchRow(
                title: l10n.clear_chapter_or_episode_cache_on_app_launch,
                value: clearChapterCacheOnAppLaunch,
                onChanged: (v) => ref
                    .read(clearChapterCacheOnAppLaunchStateProvider.notifier)
                    .set(v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The app's own folder, or one picked on the device.
  Future<void> _pickDownloadLocation(
    BuildContext context,
    WidgetRef ref,
    (String, String) location,
  ) async {
    final l10n = context.l10n;
    final pickCustom = await showShioriChoice<bool>(
      context,
      title: l10n.download_location,
      selected: location.$2.isNotEmpty,
      options: [
        ShioriChoice(false, l10n.default0, subtitle: location.$1),
        ShioriChoice(
          true,
          l10n.custom_location,
          subtitle: location.$2.isEmpty ? null : location.$2,
        ),
      ],
    );
    if (pickCustom == null) return;
    if (!pickCustom) {
      ref.read(downloadLocationStateProvider.notifier).set("");
      return;
    }
    final result = await FilePicker.getDirectoryPath(
      linuxOptions: const LinuxOptions(lockParentWindow: true),
    );
    if (result != null) {
      ref.read(downloadLocationStateProvider.notifier).set(result);
    }
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
