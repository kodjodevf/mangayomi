import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/router/router.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => MoreScreenState();
}

class MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final hiddenItems = ref.watch(hideItemsStateProvider);
    // The tab stays mounted between visits; count again on each return so
    // the numbers include what was read meanwhile.
    ref.listen<String?>(routerCurrentLocationStateProvider, (_, location) {
      if (location == '/more') ref.invalidate(readingSummaryProvider);
    });
    return Scaffold(
      body: SingleChildScrollView(
        padding: tvPageInsets.add(pageBottomInsets(context)),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ShioriSpace.s16,
                ShioriSpace.s16,
                ShioriSpace.s16,
                ShioriSpace.s8,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.more,
                  style: context.shiori.text.screenTitle.copyWith(
                    color: context.shiori.color.fg,
                  ),
                ),
              ),
            ),
            const _ReadingSummary(),
            // What the whole app does for now: only what is downloaded, or
            // nothing kept in the history.
            ShioriSettingsGroup(
              title: l10n.group_modes,
              children: const [DownloadedOnlyWidget(), IncognitoModeWidget()],
            ),
            ShioriSettingsGroup(
              title: l10n.library,
              children: [
                if (hiddenItems.contains("/history"))
                  ListTileWidget(
                    onTap: () => context.push('/history'),
                    icon: Symbols.history_rounded,
                    title: l10n.history,
                  ),
                // Downloads are hidden on TV: no offline use case, and the
                // download buttons are hidden there too, so a queue entry
                // would just dangle.
                if (!isTv)
                  ListTileWidget(
                    onTap: () => context.push('/downloadQueue'),
                    icon: Symbols.download_rounded,
                    title: l10n.download_queue,
                  ),
                ListTileWidget(
                  onTap: () => context.push('/categories', extra: (false, 0)),
                  icon: Symbols.label_rounded,
                  title: l10n.categories,
                ),
                ListTileWidget(
                  onTap: () => context.push('/statistics'),
                  icon: Symbols.query_stats_rounded,
                  title: l10n.statistics,
                ),
                ListTileWidget(
                  onTap: () => context.push('/calendarScreen'),
                  icon: Symbols.calendar_month_rounded,
                  title: l10n.calendar,
                ),
                // Mass migration is otherwise only reachable from a series'
                // overflow menu, which the TV detail view lacks. It is a
                // library-wide tool (it lists every source in the library),
                // seeded with anime since the TV build is anime-first; the TV
                // detail's per-source shortcut covers the other libraries.
                if (isTv)
                  ListTileWidget(
                    onTap: () => context.push(
                      '/massMigration',
                      extra: (ItemType.anime, null),
                    ),
                    icon: Symbols.swap_horiz_rounded,
                    title: l10n.mass_migration_title,
                  ),
              ],
            ),
            ShioriSettingsGroup(
              title: l10n.group_app,
              children: [
                ListTileWidget(
                  onTap: () => context.push('/dataAndStorage'),
                  icon: Symbols.storage_rounded,
                  title: l10n.data_and_storage,
                ),
                ListTileWidget(
                  onTap: () => context.push('/settings'),
                  icon: Symbols.settings_rounded,
                  title: l10n.settings,
                ),
                ListTileWidget(
                  onTap: () => context.push('/about'),
                  icon: Symbols.info_rounded,
                  title: l10n.about,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The reader's library in three numbers, across the media they use:
/// series, chapters read, time spent. Counted in the database, never by
/// loading rows; a tap opens the full statistics.
final readingSummaryProvider = FutureProvider.autoDispose<(int, int, int)>((
  ref,
) async {
  final types = ref.watch(animeOnlyTvModeProvider)
      ? const [ItemType.anime]
      : hiddenItemTypes(ref.watch(hideItemsStateProvider));
  var series = 0, read = 0, seconds = 0;
  for (final type in types) {
    series += await mangaRepository.countFavoritesByItemType(type);
    read += await chapterRepository.countReadByFavoriteItemType(type);
    final times = await historyRepository.getReadingTimesByItemType(type);
    seconds += times.fold<int>(0, (sum, v) => sum + (v ?? 0));
  }
  return (series, read, seconds);
});

class _ReadingSummary extends ConsumerWidget {
  const _ReadingSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(readingSummaryProvider).asData?.value;
    if (summary == null) return const SizedBox.shrink();
    final (series, read, seconds) = summary;
    final l10n = context.l10n;
    final tokens = context.shiori;
    final hours = seconds ~/ 3600;
    final stats = [
      ('$series', l10n.series),
      ('$read', l10n.chapters_read),
      (hours > 0 ? '$hours h' : '${seconds ~/ 60} min', l10n.reading_time),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        0,
        ShioriSpace.s16,
        ShioriSpace.s8,
      ),
      child: Row(
        spacing: ShioriSpace.s8,
        children: [
          for (final (value, label) in stats)
            Expanded(
              child: Material(
                color: tokens.color.ink2,
                borderRadius: BorderRadius.circular(ShioriShape.card),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push('/statistics'),
                  child: Padding(
                    padding: const EdgeInsets.all(ShioriSpace.s12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: tokens.text.seriesTitle.copyWith(
                            color: tokens.color.fg,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tokens.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
