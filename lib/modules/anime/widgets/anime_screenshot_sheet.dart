import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/widgets/image_actions_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/manga_cover_actions.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:shiori/shiori.dart';

/// Opens the screenshot action sheet (save to gallery, share, or set as series
/// cover) for the current frame of [player].
Future<void> showAnimeShareScreenshotActions(
  BuildContext sheetContext, {
  required Player player,
  required Chapter episode,
  required Duration currentPosition,
  required bool Function() includeSubtitles,
  required ValueChanged<bool> onIncludeSubtitlesChanged,
  void Function(bool closed)? onChanged,
}) async {
  Future<Uint8List?> screenshot() => player.screenshot(
    format: "image/png",
    includeLibassSubtitles: includeSubtitles(),
  );
  onChanged?.call(false);
  final name =
      "${episode.manga.value!.name} ${episode.name} - ${currentPosition.toString()}"
          .replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_');
  await showShioriSheet<void>(
    sheetContext,
    builder: (context) => ImageActionsSheet(
      onSetCover: (context) async {
        final imageBytes = await screenshot();
        if (!context.mounted) return;
        final confirmed = await confirmUseAsMangaCover(context);
        if (!confirmed || !context.mounted) return;
        await applyMangaCover(context, episode.manga.value!, imageBytes);
        if (context.mounted) Navigator.pop(context);
      },
      onShare: (context) async {
        final imageBytes = await screenshot();
        if (context.mounted) {
          final box = context.findRenderObject() as RenderBox?;
          await shareOrCopy(
            ShareParams(
              files: [
                XFile.fromData(imageBytes!, name: name, mimeType: 'image/png'),
              ],
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            ),
            fallbackName: name,
          );
        }
      },
      onSave: (context) async {
        final imageBytes = await screenshot();
        final dir = await StorageProvider().getGalleryDirectory();
        final file = File(path.join(dir!.path, "$name.png"));
        file.writeAsBytesSync(imageBytes!);
        if (context.mounted) {
          botToast(context.l10n.picture_saved, second: 3);
        }
      },
      footer: StatefulBuilder(
        builder: (context, setSheetState) => ShioriSwitchRow(
          title: context.l10n.include_subtitles,
          value: includeSubtitles(),
          onChanged: (value) {
            onIncludeSubtitlesChanged(value);
            setSheetState(() {});
          },
        ),
      ),
    ),
  );
  onChanged?.call(true);
}
