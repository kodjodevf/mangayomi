import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:shiori/shiori.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final Set<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;
  final Settings settings;
  const LibraryListViewWidget({
    super.key,
    required this.entriesManga,
    required this.language,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
    required this.settings,
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
            final selected = mangaIdsList.contains(entry.id);
            final tokens = context.shiori;
            final c = tokens.color;
            return ShioriListRow(
              selected: selected,
              titleMaxLines: 2,
              title: entry.name!,
              // Where it comes from, as every other list of series says.
              subtitle: entry.source,
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
              leading: ShioriThumbnail(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: resolveCoverImage(entry, ref),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                    if (selected)
                      ColoredBox(
                        color: c.accent.withValues(alpha: Alphas.secondary),
                        child: Icon(
                          Symbols.check_rounded,
                          color: c.onAccent,
                          size: tokens.scaled(20),
                        ),
                      ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: ShioriSpace.s12,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2,
                    children: [
                      LibraryBadgeWidget(
                        entry: entry,
                        showLocal: localSource,
                        showDownloaded: downloadedChapter,
                        settings: settings,
                      ),
                      if (language && (entry.lang?.isNotEmpty ?? false))
                        EntryBadgeChip(label: entry.lang!.toUpperCase()),
                    ],
                  ),
                  if (continueReaderBtn) ContinueReaderButton(entry: entry),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
