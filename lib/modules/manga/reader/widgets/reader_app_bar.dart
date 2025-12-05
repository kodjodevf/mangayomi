import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/utils.dart';

/// The app bar for the manga reader.
///
/// Displays:
/// - Back button
/// - Manga name and chapter title
/// - Chapter list button
/// - Bookmark button
/// - Web view button (for non-local sources)
///
/// This widget is designed to be used directly in reader_view.dart
/// as a drop-in replacement for the _appBar() method.
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

  /// Background color getter
  final Color Function(BuildContext) backgroundColor;

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
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final isDesktop =
        Platform.isMacOS || Platform.isLinux || Platform.isWindows;
    final isLocalArchive = chapter.manga.value?.isLocalArchive ?? false;

    double height = isVisible
        ? Platform.isIOS
              ? 120.0
              : !fullScreenReader && !isDesktop
              ? 55.0
              : 80.0
        : 0.0;

    return Positioned(
      top: 0,
      child: AnimatedContainer(
        width: context.width(1),
        height: height,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
        child: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: BackButton(onPressed: onBackPressed),
            title: _buildTitle(context),
            actions: _buildActions(context, isLocalArchive),
            backgroundColor: backgroundColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return ListTile(
      dense: true,
      title: SizedBox(
        width: context.width(0.8),
        child: Text(
          '$mangaName ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: SizedBox(
        width: context.width(0.8),
        child: Text(
          chapterTitle,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isLocalArchive) {
    return [
      // Chapter list button
      btnToShowChapterListDialog(context, context.l10n.chapters, chapter),

      // Bookmark button
      IconButton(
        onPressed: onBookmarkPressed,
        icon: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
        ),
      ),

      // Web view button (only for non-local sources)
      if (!isLocalArchive && onWebViewPressed != null)
        IconButton(onPressed: onWebViewPressed, icon: const Icon(Icons.public)),
    ];
  }
}

/// Builds the web view navigation data.
Map<String, dynamic>? buildWebViewData(Chapter chapter) {
  final manga = chapter.manga.value;
  if (manga == null) return null;

  final source = getSource(manga.lang!, manga.source!, manga.sourceId);
  if (source == null) return null;

  final url = "${source.baseUrl}${chapter.url!.getUrlWithoutDomain}";

  return {'url': url, 'sourceId': source.id.toString(), 'title': chapter.name!};
}
