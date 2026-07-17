import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final Set<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;
  const LibraryListViewWidget({
    super.key,
    required this.entriesManga,
    required this.language,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
  });

  @override
  Widget build(BuildContext context) {
    return SuperListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        final entry = entriesManga[index];
        return Consumer(
          builder: (context, ref, child) {
            final isLongPressed = ref.watch(isLongPressedStateProvider);
            return Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onTapEntry(
                  isLongPressed: isLongPressed,
                  ref: ref,
                  context: context,
                  entry: entry,
                ),
                onLongPress: () =>
                    handleLongOrSecondaryTap(isLongPressed, ref, entry),
                onSecondaryTap: () =>
                    handleLongOrSecondaryTap(isLongPressed, ref, entry),
                child: Container(
                  color: mangaIdsList.contains(entry.id)
                      ? context.primaryColor.withValues(alpha: 0.4)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ── Thumbnail + title ──
                          Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Material(
                                    child: Ink.image(
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 45,
                                      image: resolveCoverImage(entry, ref),
                                      child: InkWell(
                                        child: Container(
                                          color: mangaIdsList.contains(entry.id)
                                              ? context.primaryColor.withValues(
                                                  alpha: 0.4,
                                                )
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(entry.name!),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Right-side badge row ──
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LibraryBadgeWidget(
                                entry: entry,
                                showLocal: localSource,
                                showDownloaded: downloadedChapter,
                              ),
                              if (language && (entry.lang?.isNotEmpty ?? false))
                                Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: EntryBadgeChip(
                                    label: entry.lang!.toUpperCase(),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                            ],
                          ),
                          if (continueReaderBtn)
                            ContinueReaderButton(entry: entry),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
