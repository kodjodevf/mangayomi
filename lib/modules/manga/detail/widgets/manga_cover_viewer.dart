import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/manga_cover_actions.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:path/path.dart' as p;
import 'package:mangayomi/utils/constant.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

/// Full-screen cover viewer: pinch-zoom the cover, plus - along the bottom -
/// a picker for any tracker's cover for this manga, and share/save/edit/
/// delete actions on the current one.
void showMangaCoverViewer(
  BuildContext context, {
  required Manga manga,
  required ImageProvider imageProvider,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: PhotoViewGallery.builder(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: imageProvider,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: 2.0,
                  );
                },
                loadingBuilder: (context, event) {
                  return const ProgressCenter();
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: StreamBuilder(
                      stream: trackRepository.watchAllWithSyncId(),
                      builder: (context, snapshot) {
                        List<TrackPreference>? entries = snapshot.hasData
                            ? snapshot.data!
                            : [];
                        if (entries.isEmpty) {
                          return Container();
                        }
                        return Column(
                          children: entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () async {
                                      final trackSearch =
                                          await trackersSearchDraggableMenu(
                                            context,
                                            itemType: manga.itemType,
                                            track: Track(
                                              status: TrackStatus.planToRead,
                                              syncId: e.syncId!,
                                              title: manga.name!,
                                            ),
                                          ) as TrackSearch?;
                                      if (trackSearch != null) {
                                        mangaRepository.save(
                                          manga
                                            ..customCoverImage = null
                                            ..customCoverFromTracker =
                                                trackSearch.coverUrl,
                                        );
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          botToast(
                                            context.l10n.cover_updated,
                                            second: 3,
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: trackInfos(e.syncId!).$3,
                                      ),
                                      width: 45,
                                      height: 50,
                                      child: Image.asset(
                                        trackInfos(e.syncId!).$1,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: context.width(1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: context.isLight
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.close),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: context.isLight
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final bytes = await imageProvider.getBytes(
                                      context,
                                    );
                                    if (bytes != null) {
                                      await shareOrCopy(
                                        ShareParams(
                                          files: [
                                            XFile.fromData(
                                              bytes,
                                              name: manga.name,
                                              mimeType: 'image/png',
                                            ),
                                          ],
                                        ),
                                        fallbackName: manga.name,
                                      );
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.share),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final dir = await StorageProvider()
                                        .getGalleryDirectory();
                                    if (context.mounted) {
                                      final bytes = await imageProvider
                                          .getBytes(context);
                                      if (bytes != null && context.mounted) {
                                        final file = File(
                                          p.join(
                                            dir!.path,
                                            "${manga.name}.png",
                                          ),
                                        );
                                        file.writeAsBytesSync(bytes);
                                        botToast(
                                          context.l10n.cover_saved,
                                          second: 3,
                                        );
                                      }
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.save_outlined),
                                  ),
                                ),
                                PopupMenuButton(
                                  popUpAnimationStyle: popupAnimationStyle,
                                  itemBuilder: (context) {
                                    return [
                                      if (manga.customCoverImage != null ||
                                          manga.customCoverFromTracker != null)
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Text(context.l10n.delete),
                                        ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: Text(context.l10n.edit),
                                      ),
                                    ];
                                  },
                                  onSelected: (value) async {
                                    if (value == 0) {
                                      mangaRepository.save(
                                        manga
                                          ..customCoverImage = null
                                          ..customCoverFromTracker = null,
                                      );
                                      Navigator.pop(context);
                                    } else if (value == 1) {
                                      final file = await FilePicker.pickFile(
                                        type: FileType.image,
                                        linuxOptions: const LinuxOptions(
                                          lockParentWindow: true,
                                        ),
                                      );
                                      if (file?.path != null &&
                                          context.mounted) {
                                        final bytes = File(file!.path!)
                                            .readAsBytesSync();
                                        await applyMangaCover(
                                          context,
                                          manga,
                                          bytes,
                                        );
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: !context.isLight
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
