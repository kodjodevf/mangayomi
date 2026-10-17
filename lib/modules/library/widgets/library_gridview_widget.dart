import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_hero.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:shiori/shiori.dart';

class LibraryGridViewWidget extends StatefulWidget {
  final bool isCoverOnlyGrid;
  final bool isComfortableGrid;
  final Set<int> mangaIdsList;
  final List<Manga> entriesManga;
  final bool language;
  final bool sourceBadge;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  final bool localSource;
  final ItemType itemType;
  final Settings settings;
  const LibraryGridViewWidget({
    super.key,
    required this.entriesManga,
    required this.isCoverOnlyGrid,
    this.isComfortableGrid = false,
    required this.language,
    this.sourceBadge = false,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
    required this.itemType,
    required this.settings,
  });

  @override
  State<LibraryGridViewWidget> createState() => _LibraryGridViewWidgetState();
}

class _LibraryGridViewWidgetState extends State<LibraryGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final gridSize = ref.watch(
          libraryGridSizeStateProvider(itemType: widget.itemType),
        );
        return GridViewWidget(
          gridSize: gridSize,
          childAspectRatio: widget.isComfortableGrid ? 0.642 : 0.69,
          itemCount: widget.entriesManga.length,
          itemBuilder: (context, index) {
            final entry = widget.entriesManga[index];
            return Consumer(
              builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: CoverViewWidget(
                    // On TV, make the first cover the content's focus target so the
                    // d-pad reliably lands on the grid (not the app bar).
                    autofocus: isTv && index == 0,
                    heroTag: entry.id == null ? null : coverHeroTag(entry.id!),
                    isLongPressed: widget.mangaIdsList.contains(entry.id),
                    isComfortableGrid: widget.isComfortableGrid,
                    bottomTextWidget: BottomTextWidget(
                      maxLines: 1,
                      text: entry.name!,
                      isComfortableGrid: widget.isComfortableGrid,
                    ),
                    image: resolveCoverImage(entry, ref),
                    onTap: () => onTapEntry(
                      isLongPressed: ref.read(isLongPressedStateProvider),
                      ref: ref,
                      context: context,
                      entry: entry,
                    ),
                    onLongPress: () => handleLongOrSecondaryTap(
                      ref.read(isLongPressedStateProvider),
                      ref,
                      entry,
                    ),
                    onSecondaryTap: () => handleLongOrSecondaryTap(
                      ref.read(isLongPressedStateProvider),
                      ref,
                      entry,
                    ),
                    children: [
                      Stack(
                        children: [
                          // ── Top-left: Local + download count + unread count ──
                          PositionedDirectional(
                            top: ShioriSpace.s4,
                            start: ShioriSpace.s4,
                            child: LibraryBadgeWidget(
                              entry: entry,
                              showLocal: widget.localSource,
                              showDownloaded: widget.downloadedChapter,
                              settings: widget.settings,
                            ),
                          ),

                          // ── Top-right: Language ──
                          if (widget.language &&
                              (entry.lang?.isNotEmpty ?? false))
                            PositionedDirectional(
                              top: ShioriSpace.s4,
                              end: ShioriSpace.s4,
                              child: EntryBadgeChip(
                                label: entry.lang!.toUpperCase(),
                              ),
                            ),
                        ],
                      ),

                      if (!widget.isComfortableGrid && !widget.isCoverOnlyGrid)
                        BottomTextWidget(text: entry.name!),

                      if (widget.continueReaderBtn)
                        PositionedDirectional(
                          bottom: ShioriSpace.s8,
                          end: ShioriSpace.s8,
                          child: ContinueReaderButton(entry: entry),
                        ),

                      // ── Bottom-left: Source ──
                      if (widget.sourceBadge && (entry.source ?? '').isNotEmpty)
                        PositionedDirectional(
                          bottom: ShioriSpace.s4,
                          start: ShioriSpace.s4,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 96),
                            child: EntryBadgeChip(label: entry.source!),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
