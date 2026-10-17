import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:path/path.dart' as p;

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final saveAsCBZArchiveState = ref.watch(saveAsCBZArchiveStateProvider);
    final deleteDownloadAfterReading = ref.watch(
      deleteDownloadAfterReadingStateProvider,
    );
    final onlyOnWifiState = ref.watch(onlyOnWifiStateProvider);
    final concurrentDownloads = ref.watch(concurrentDownloadsStateProvider);
    final allowConcurrentDownloads = ref.watch(
      allowConcurrentDownloadsStateProvider,
    );
    final downloadDelaySeconds = ref.watch(downloadDelaySecondsStateProvider);
    final localFolders = ref.watch(localFoldersStateProvider);
    final downloadLocation = ref.watch(downloadLocationStateProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.downloads)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          // Where downloads go and how they are kept; the screen's title
          // already names them.
          ShioriSettingsGroup(
            children: [
              ShioriSettingRow(
                autofocus: isTv,
                icon: Symbols.folder_open_rounded,
                title: l10n.download_location,
                subtitle: downloadLocation.$2.isEmpty
                    ? downloadLocation.$1
                    : downloadLocation.$2,
                onTap: () async {
                  final result = await _pickDirectory();
                  if (result != null) {
                    ref
                        .read(downloadLocationStateProvider.notifier)
                        .set(result);
                  }
                },
              ),
              ShioriSwitchRow(
                title: l10n.only_on_wifi,
                value: onlyOnWifiState,
                onChanged: (v) =>
                    ref.read(onlyOnWifiStateProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.save_as_cbz_archive,
                value: saveAsCBZArchiveState,
                onChanged: (v) =>
                    ref.read(saveAsCBZArchiveStateProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.delete_download_after_reading,
                value: deleteDownloadAfterReading,
                onChanged: (v) => ref
                    .read(deleteDownloadAfterReadingStateProvider.notifier)
                    .set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.download_queue,
            children: [
              ShioriSwitchRow(
                title: l10n.allow_concurrent_downloads,
                subtitle: l10n.allow_concurrent_downloads_subtitle,
                value: allowConcurrentDownloads,
                onChanged: (v) => ref
                    .read(allowConcurrentDownloadsStateProvider.notifier)
                    .set(v),
              ),
              if (allowConcurrentDownloads)
                ShioriSliderRow(
                  title: l10n.concurrent_downloads,
                  value: concurrentDownloads.toDouble(),
                  min: 1,
                  // Room for a value set higher before this was a slider.
                  max: concurrentDownloads > 20
                      ? concurrentDownloads.toDouble()
                      : 20,
                  divisions: concurrentDownloads > 20
                      ? concurrentDownloads - 1
                      : 19,
                  onChanged: (v) => ref
                      .read(concurrentDownloadsStateProvider.notifier)
                      .set(v.round()),
                ),
              ShioriSliderRow(
                title: l10n.download_delay,
                subtitle: downloadDelaySeconds == 0
                    ? l10n.download_delay_subtitle
                    : null,
                value: downloadDelaySeconds.toDouble(),
                min: 0,
                max: 120,
                divisions: 120,
                valueLabel: (v) => l10n.seconds_short(v.round()),
                defaultValue: 0,
                onReset: () =>
                    ref.read(downloadDelaySecondsStateProvider.notifier).set(0),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(downloadDelaySecondsStateProvider.notifier)
                    .set(v.round()),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.local_folder,
            children: [
              FutureBuilder<LocalFolder?>(
                future: getDefaultLocalFolder(),
                builder: (context, snapshot) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (snapshot.data?.path != null)
                      _localFolderRow(
                        l10n,
                        localFolders,
                        snapshot.data!,
                        isDefault: true,
                      ),
                    for (final folder in localFolders)
                      _localFolderRow(l10n, localFolders, folder),
                  ],
                ),
              ),
              ShioriSettingRow(
                icon: Symbols.create_new_folder_rounded,
                title: l10n.add_local_folder,
                onTap: () => _addLocalFolder(localFolders),
              ),
              ShioriSettingRow(
                icon: Symbols.refresh_rounded,
                title: l10n.rescan_local_folder,
                onTap: () async => ref.read(scanLocalLibraryProvider.future),
              ),
              ShioriSettingRow(
                icon: Symbols.help_rounded,
                title: l10n.local_folder_structure,
                onTap: () => _showHelpDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _pickDirectory() async =>
      await LocalDirectoryAccess.pickDirectory() ??
      await FilePicker.getDirectoryPath(
        linuxOptions: const LinuxOptions(lockParentWindow: true),
      );

  Future<void> _addLocalFolder(List<LocalFolder> localFolders) async {
    final result = await _pickDirectory();
    if (result == null || !mounted) return;
    final name = await showShioriPrompt(
      context,
      title: context.l10n.name,
      label: context.l10n.name,
      confirmLabel: context.l10n.add,
      initialValue:
          LocalFolder.fromPath(path: result).name ?? p.basename(result),
    );
    if (name == null || name.trim().isEmpty) return;
    ref.read(localFoldersStateProvider.notifier).set([
      ...localFolders,
      LocalFolder(name: name.trim(), path: result),
    ]);
  }

  /// One folder the library is read from: the app's own, then the ones
  /// added here, which can be removed.
  Widget _localFolderRow(
    AppLocalizations l10n,
    List<LocalFolder> localFolders,
    LocalFolder folder, {
    bool isDefault = false,
  }) {
    final folderName = folder.name ?? "";
    final folderPath = folder.path ?? "";
    return ShioriSettingRow(
      key: Key('folder_${folderName}_${folderPath.hashCode}'),
      icon: isDefault ? Symbols.home_rounded : Symbols.folder_rounded,
      title: isDefault ? '$folderName · ${l10n.default0}' : folderName,
      subtitle: folderPath,
      trailing: isDefault
          ? null
          : IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Symbols.delete_rounded),
              onPressed: () async {
                final confirmed = await showShioriConfirm(
                  context,
                  title: l10n.delete,
                  message: '$folderName\n$folderPath',
                  confirmLabel: l10n.delete,
                  destructive: true,
                );
                if (!confirmed) return;
                ref
                    .read(localFoldersStateProvider.notifier)
                    .set(
                      localFolders
                          .where(
                            (e) =>
                                e.name != folder.name || e.path != folder.path,
                          )
                          .toList(),
                    );
              },
            ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final data = (
      "LocalFolder",
      [
        (
          "MangaName",
          [
            ("cover.jpg", Symbols.image_rounded),
            (
              "Chapter1",
              [
                ("Page1.jpg", Symbols.image_rounded),
                ("Page2.jpeg", Symbols.image_rounded),
                ("Page3.png", Symbols.image_rounded),
                ("Page4.webp", Symbols.image_rounded),
              ],
            ),
            ("Chapter2.cbz", Symbols.folder_zip_rounded),
            ("Chapter3.zip", Symbols.folder_zip_rounded),
            ("Chapter4.cbt", Symbols.folder_zip_rounded),
            ("Chapter5.tar", Symbols.folder_zip_rounded),
          ],
        ),
        (
          "AnimeName",
          [
            ("cover.jpg", Symbols.image_rounded),
            ("Episode1.mp4", Symbols.video_file_rounded),
            (
              "Episode1_subtitles",
              [
                ("en.srt", Symbols.subtitles_rounded),
                ("de.srt", Symbols.subtitles_rounded),
              ],
            ),
            ("Episode2.mov", Symbols.video_file_rounded),
            ("Episode3.avi", Symbols.video_file_rounded),
            ("Episode4.flv", Symbols.video_file_rounded),
            ("Episode5.wmv", Symbols.video_file_rounded),
            ("Episode6.mpeg", Symbols.video_file_rounded),
            ("Episode7.mkv", Symbols.video_file_rounded),
          ],
        ),
        (
          "NovelName",
          [
            ("cover.jpg", Symbols.image_rounded),
            ("NovelName.epub", Symbols.book_rounded),
          ],
        ),
      ],
    );

    Widget buildSubFolder((String, dynamic) data, int level) {
      if (data.$2 is List) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  for (int i = 1; i < level; i++)
                    const WidgetSpan(child: SizedBox(width: ShioriSpace.s24)),
                  if (level > 0)
                    WidgetSpan(
                      child: Icon(
                        Symbols.subdirectory_arrow_right_rounded,
                        fill: 1,
                      ),
                    ),
                  WidgetSpan(child: Icon(Symbols.folder_rounded, fill: 1)),
                  const WidgetSpan(child: SizedBox(width: ShioriSpace.s4)),
                  TextSpan(text: data.$1),
                ],
              ),
            ),
            ...(data.$2 as List<(String, dynamic)>).map(
              (e) => buildSubFolder(e, level + 1),
            ),
          ],
        );
      }
      return Text.rich(
        TextSpan(
          children: [
            for (int i = 1; i < level; i++)
              const WidgetSpan(child: SizedBox(width: ShioriSpace.s24)),
            if (level > 0)
              WidgetSpan(
                child: Icon(Symbols.subdirectory_arrow_right_rounded, fill: 1),
              ),
            WidgetSpan(child: Icon(data.$2 as IconData)),
            const WidgetSpan(child: SizedBox(width: ShioriSpace.s4)),
            TextSpan(text: data.$1),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => ShioriDialog(
        title: context.l10n.local_folder_structure,
        // As tall as the tree, up to six tenths of the screen.
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.width(0.6),
            maxHeight: context.height(0.6),
          ),
          child: SingleChildScrollView(child: buildSubFolder(data, 0)),
        ),
        actions: [
          ShioriButton.quiet(
            label: MaterialLocalizations.of(context).closeButtonLabel,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
