import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:shiori/shiori.dart';

class ContinueReaderButton extends ConsumerWidget {
  final Manga entry;
  final Settings settings;

  const ContinueReaderButton({
    super.key,
    required this.entry,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nothing left to read (caught up, or no chapters yet): no button. Uses
    // the same scanlator-aware count as the unread badge, so the two agree.
    if (entry.unreadChaptersCount(settings) == 0) {
      return const SizedBox.shrink();
    }
    // The button looks the same regardless of history, so the last-read
    // chapter is resolved on tap — a live watch per grid cell made scrolling
    // large libraries churn dozens of query subscriptions.
    final tokens = context.shiori;
    final c = tokens.color;
    final size = tokens.scaled(32);
    return Semantics(
      button: true,
      label: context.l10n.resume,
      child: Material(
        color: c.accent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _resume(context, ref),
          child: SizedBox.square(
            dimension: size,
            child: Icon(
              Symbols.play_arrow_rounded,
              fill: 1,
              size: size * 0.6,
              color: c.onAccent,
            ),
          ),
        ),
      ),
    );
  }

  void _resume(BuildContext context, WidgetRef ref) {
    final lastRead = resumeChapterFor(
      entry,
      incognito: ref.read(incognitoModeStateProvider),
    );
    // Reopen the chapter in progress; once it is finished, move on to the
    // first unread one instead of landing on the last page of a read chapter.
    final chapter = lastRead != null && !(lastRead.isRead ?? false)
        ? lastRead
        : firstUnreadChapterFor(entry);
    (chapter ?? entry.chapters.first).pushToReaderView(context);
  }
}
