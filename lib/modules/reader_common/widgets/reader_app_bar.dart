import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/reader_common/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:shiori/shiori.dart';

/// The reader's top bar: back, where you are (the series, then the
/// chapter), the bookmark, and a menu for what is seldom needed (reload the
/// chapter, open it on the web).
///
/// It slides in from the top edge and back out rather than growing from
/// nothing, and it is as tall as a toolbar plus the status bar when the
/// reader is full screen, instead of a height guessed per platform. The
/// chapter list moved to the bottom panel in the manga reader, within
/// reach of a thumb; [showChapterList] keeps it here for the novel reader.
class ReaderAppBar extends ConsumerWidget {
  /// The chapter being read
  final Chapter chapter;

  /// The manga name to display
  final String mangaName;

  /// The chapter title to display
  final String chapterTitle;

  /// Whether the app bar is visible
  final bool isVisible;

  /// Whether the chapter is bookmarked
  final bool isBookmarked;

  /// Callback when back button is pressed
  final VoidCallback onBackPressed;

  /// Callback when bookmark button is pressed
  final VoidCallback onBookmarkPressed;

  /// Callback when web view button is pressed
  final VoidCallback? onWebViewPressed;

  /// Callback when refresh button is pressed
  final VoidCallback? onRefreshPressed;

  /// Background color getter
  final Color Function(BuildContext) backgroundColor;

  /// Whether the chapter list button sits here (the novel reader) or in the
  /// bottom panel (the manga reader).
  final bool showChapterList;

  const ReaderAppBar({
    super.key,
    required this.chapter,
    required this.mangaName,
    required this.chapterTitle,
    required this.isVisible,
    required this.isBookmarked,
    required this.onBackPressed,
    required this.onBookmarkPressed,
    this.onWebViewPressed,
    this.onRefreshPressed,
    required this.backgroundColor,
    this.showChapterList = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final isLocalArchive = chapter.manga.value?.isLocalArchive ?? false;
    final tokens = context.shiori;
    final duration = ShioriMotion.of(context, ShioriMotion.enter);
    final curve = isVisible ? ShioriMotion.enterCurve : ShioriMotion.exitCurve;
    // Out of a safe area when full screen: the bar reaches under the status
    // bar and keeps its content clear of it.
    final topInset = fullScreenReader ? MediaQuery.paddingOf(context).top : 0.0;
    final refresh = !isLocalArchive ? onRefreshPressed : null;
    final webView = !isLocalArchive ? onWebViewPressed : null;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ReaderChromeGate(
        shown: isVisible,
        child: AnimatedSlide(
          offset: isVisible ? Offset.zero : const Offset(0, -1),
          duration: duration,
          curve: curve,
          child: AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: duration,
            curve: curve,
            child: Material(
              color: backgroundColor(context),
              child: Padding(
                padding: EdgeInsets.only(top: topInset),
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      BackButton(onPressed: onBackPressed),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mangaName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.text.row.copyWith(
                                color: tokens.color.fg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              chapterTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.caption,
                            ),
                          ],
                        ),
                      ),
                      if (showChapterList)
                        btnToShowChapterListDialog(
                          context,
                          context.l10n.chapters,
                          chapter,
                        ),
                      IconButton(
                        onPressed: onBookmarkPressed,
                        tooltip: isBookmarked
                            ? context.l10n.remove_bookmark
                            : context.l10n.bookmark,
                        icon: Icon(
                          Symbols.bookmark_rounded,
                          fill: isBookmarked ? 1 : 0,
                          color: isBookmarked ? tokens.color.accentInk : null,
                        ),
                      ),
                      if (refresh != null || webView != null)
                        ShioriMenuButton(
                          tooltip: MaterialLocalizations.of(context)
                              .moreButtonTooltip,
                          items: [
                            if (refresh != null)
                              ShioriMenuItem(
                                label: context.l10n.refresh,
                                icon: Symbols.refresh_rounded,
                                onSelected: refresh,
                              ),
                            if (webView != null)
                              ShioriMenuItem(
                                label: context.l10n.webview,
                                icon: Symbols.public_rounded,
                                onSelected: webView,
                              ),
                          ],
                        )
                      else
                        const SizedBox(width: ShioriSpace.s8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The readers' bars while they are hidden: out of reach of taps and of
/// focus, so a remote or a keyboard cannot land on a button that has slid
/// off the screen.
class ReaderChromeGate extends StatelessWidget {
  const ReaderChromeGate({super.key, required this.shown, required this.child});

  final bool shown;
  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeFocus(
    excluding: !shown,
    child: IgnorePointer(ignoring: !shown, child: child),
  );
}

/// Builds the web view navigation data.
Map<String, dynamic>? buildWebViewData(Chapter chapter) {
  final manga = chapter.manga.value;
  if (manga == null) return null;

  final source = getSource(
    manga.lang!,
    manga.source!,
    manga.sourceId,
    installedOnly: true,
  );
  if (source == null) return null;

  final url = "${source.baseUrl}${chapter.url!.getUrlWithoutDomain}";

  return {'url': url, 'sourceId': source.id.toString(), 'title': chapter.name!};
}
