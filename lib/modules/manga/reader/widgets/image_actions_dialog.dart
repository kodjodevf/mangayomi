import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:path/path.dart' as p;

/// Bottom sheet dialog for long-press actions on manga images.
///
/// Provides options to:
/// - Set image as cover
/// - Share image
/// - Save image to gallery
class ImageActionsDialog {
  /// Shows the image actions dialog.
  ///
  /// Parameters:
  /// - [context]: Build context
  /// - [data]: The page data containing the image
  /// - [manga]: The manga the image belongs to
  /// - [chapterName]: Name of the chapter (for file naming)
  static Future<void> show({
    required BuildContext context,
    required UChapDataPreload data,
    required Manga manga,
    required String chapterName,
  }) async {
    final imageBytes = await data.getImageBytes;
    if (imageBytes == null || !context.mounted) return;

    final name = "${manga.name} $chapterName - ${data.pageIndex}".replaceAll(
      RegExp(r'[^a-zA-Z0-9 .()\-\s]'),
      '_',
    );

    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxWidth: context.width(1)),
      builder: (context) => _ImageActionsSheet(
        imageBytes: imageBytes,
        manga: manga,
        fileName: name,
      ),
    );
  }
}

class _ImageActionsSheet extends StatelessWidget {
  final List<int> imageBytes;
  final Manga manga;
  final String fileName;

  const _ImageActionsSheet({
    required this.imageBytes,
    required this.manga,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return SuperListView(
      shrinkWrap: true,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: context.themeData.scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: context.secondaryColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
              // Action buttons
              Row(
                children: [
                  _ActionButton(
                    label: context.l10n.set_as_cover,
                    icon: Icons.image_outlined,
                    onPressed: () => _setAsCover(context),
                  ),
                  _ActionButton(
                    label: context.l10n.share,
                    icon: Icons.share_outlined,
                    onPressed: () => _shareImage(context),
                  ),
                  _ActionButton(
                    label: context.l10n.save,
                    icon: Icons.save_outlined,
                    onPressed: () => _saveImage(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setAsCover(BuildContext context) async {
    final res = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(context.l10n.use_this_as_cover_art),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel),
              ),
              const SizedBox(width: 15),
              TextButton(
                onPressed: () {
                  isar.writeTxnSync(() {
                    isar.mangas.putSync(
                      manga
                        ..customCoverImage = Uint8List.fromList(
                          imageBytes,
                        ).getCoverImage
                        ..updatedAt = DateTime.now().millisecondsSinceEpoch,
                    );
                  });
                  Navigator.pop(context, "ok");
                },
                child: Text(context.l10n.ok),
              ),
            ],
          ),
        ],
      ),
    );

    if (res == "ok" && context.mounted) {
      Navigator.pop(context);
      botToast(context.l10n.cover_updated, second: 3);
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    if (!context.mounted) return;

    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            Uint8List.fromList(imageBytes),
            name: fileName,
            mimeType: 'image/png',
          ),
        ],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final dir = await StorageProvider().getGalleryDirectory();
    if (dir == null) return;

    final file = File(p.join(dir.path, "$fileName.png"));
    file.writeAsBytesSync(imageBytes);

    if (context.mounted) {
      botToast(context.l10n.picture_saved, second: 3);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(4), child: Icon(icon)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
