import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/library/widgets/base_library_tab_screen.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/updates/providers/updates_last_seen_provider.dart';
import 'package:mangayomi/modules/updates/widgets/series_updates.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/updates/update_errors_screen.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/widgets/library_update_runner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:shiori/shiori.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends BaseLibraryTabScreenState<UpdatesScreen> {
  bool _isLoading = false;

  @override
  String get title => l10nLocalizations(context)!.updates;

  @override
  String? get navRoute => '/updates';

  @override
  void initState() {
    super.initState();
    // The shell keeps a visited tab mounted, so initState and dispose do not
    // mark entering and leaving Updates: the route does. Either one clears the
    // nav badge, as in Mihon, so what was found while here is not new later.
    ref.listenManual<String?>(routerCurrentLocationStateProvider, (
      previous,
      next,
    ) {
      if (isUpdatesLocation(previous) || isUpdatesLocation(next)) {
        ref.read(updatesLastSeenStateProvider.notifier).markSeen();
      }
    });
    // Already on Updates when first built (opened straight onto it).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          isUpdatesLocation(ref.read(routerCurrentLocationStateProvider))) {
        ref.read(updatesLastSeenStateProvider.notifier).markSeen();
      }
    });
  }

  @override
  Widget buildTab(ItemType type) {
    return Padding(
      padding: const EdgeInsets.only(top: ShioriSpace.s12),
      child: UpdateTab(
        itemType: type,
        query: textEditingController.text,
        isLoading: _isLoading,
      ),
    );
  }

  @override
  Widget buildTabLabel(ItemType type, String label) {
    return Row(
      // Shrink to the label: filling the tab would stretch the indicator
      // pill across its whole width.
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(text: label),
        _updateNumbers(ref, type),
      ],
    );
  }

  @override
  List<Widget> buildExtraActions(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return [
      if (ref.watch(updateErrorsProvider.select((e) => e.isNotEmpty)))
        IconButton(
          splashRadius: 20,
          tooltip: context.l10n.update_errors,
          icon: Icon(
            Symbols.error_rounded,
            color: context.shiori.color.error.foreground,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UpdateErrorsScreen()),
          ),
        ),
      // While an update is running this is the way to stop it, the same as on
      // the library screen. Watching the provider rather than this screen's own
      // flag means the button is also correct for an update started elsewhere.
      if (ref.watch(libraryUpdateProvider.select((s) => s.running)))
        IconButton(
          splashRadius: 20,
          tooltip: l10n.cancel,
          icon: const Icon(Symbols.stop_circle_rounded),
          onPressed: () =>
              ref.read(libraryUpdateProvider.notifier).requestCancel(),
        )
      else
        IconButton(
          splashRadius: 20,
          tooltip: l10n.refresh,
          icon: const Icon(Symbols.refresh_rounded),
          onPressed: _updateLibrary,
        ),
      IconButton(
        splashRadius: 20,
        tooltip: l10n.remove_everything,
        icon: const Icon(Symbols.delete_sweep_rounded),
        onPressed: () async {
          final confirmed = await showShioriConfirm(
            context,
            title: l10n.remove_everything,
            message: l10n.remove_all_update_msg,
            confirmLabel: l10n.ok,
            cancelLabel: l10n.cancel,
            destructive: true,
          );
          if (confirmed) await _clearUpdates();
        },
      ),
    ];
  }

  Future<void> _updateLibrary() async {
    if (visibleTabTypes.isEmpty) return;
    try {
      setState(() => _isLoading = true);
      final itemType = getCurrentItemType();
      final mangaList = await mangaRepository
          .getFavoritesNonLocalArchiveByItemType(itemType);
      if (!mounted) return;
      await updateLibrary(
        ref: ref,
        context: context,
        mangaList: mangaList,
        itemType: itemType,
        wholeLibrary: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _clearUpdates() async {
    if (visibleTabTypes.isEmpty) return;
    final idsToDelete = await updateRepository.getIdsByItemType(
      getCurrentItemType(),
    );
    if (idsToDelete.isEmpty) return;
    await updateRepository.deleteAll(idsToDelete);
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  final bool isLoading;
  const UpdateTab({
    required this.itemType,
    required this.query,
    required this.isLoading,
    super.key,
  });

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// Queues every chapter of a day that is not downloaded yet, as the
  /// detail page does for a selection, and says how many.
  Future<void> _downloadDay(List<Chapter> chapters) async {
    final l10n = l10nLocalizations(context)!;
    final pending = chapters.where((chapter) {
      final entry = downloadRepository.getByChapterId(chapter.id);
      return entry == null || !(entry.isDownload ?? false);
    }).toList();
    if (pending.isEmpty) return;
    for (final chapter in pending) {
      await downloadRepository.enqueue(chapter);
    }
    if (!mounted) return;
    ref.invalidate(processDownloadsProvider());
    ref.read(processDownloadsProvider());
    botToast(
      l10n.n_chapters_queued(pending.length),
      second: 3,
      tone: ShioriToastTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final update = ref.watch(
      getAllUpdateStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );
    return Stack(
      children: [
        update.when(
          data: (entries) {
            // Resolve chapter/manga once here instead of per row in itemBuilder.
            final chapterByUpdateId = <int, Chapter>{};
            for (final e in entries) {
              if (!e.chapter.isLoaded) e.chapter.loadSync();
              final c = e.chapter.value;
              if (c != null) chapterByUpdateId[e.id!] = c;
            }
            final mangaIds = chapterByUpdateId.values
                .map((c) => c.mangaId)
                .whereType<int>()
                .toSet()
                .toList();
            final mangaById = {
              for (final m in mangaRepository.getAllByIds(mangaIds)) m?.id!: m!,
            };

            // Both maps above skip an entry that no longer resolves, and the
            // itemBuilder below then asserted it was there. An update whose
            // chapter has been deleted (a refresh cleaning up duplicates) or
            // whose manga has left the library therefore threw mid-build, and
            // in a release build a throwing child is replaced by a plain grey
            // box, leaving the list ending in scrollable grey. Drop those
            // updates instead: the row has nothing left to show anyway.
            final resolved = entries.where((e) {
              final chapter = chapterByUpdateId[e.id];
              return chapter != null && mangaById.containsKey(chapter.mangaId);
            }).toList();

            int? lastUpdated;
            for (final c in chapterByUpdateId.values) {
              final value = mangaById[c.mangaId]?.lastUpdate;
              if (value != null &&
                  (lastUpdated == null || value > lastUpdated)) {
                lastUpdated = value;
              }
            }
            final groups = groupUpdatesBySeries(
              resolved,
              mangaIdOf: (u) => chapterByUpdateId[u.id]?.mangaId,
              dayOf: (u) => dateFormat(
                u.date!,
                context: context,
                ref: ref,
                forHistoryValue: true,
                useRelativeTimesTamps: false,
              ),
            );
            if (resolved.isNotEmpty) {
              return CustomScrollView(
                slivers: [
                  if (lastUpdated != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          ShioriSpace.s16,
                          ShioriSpace.s8,
                          ShioriSpace.s16,
                          ShioriSpace.s8,
                        ),
                        child: Text(
                          l10n.library_last_updated(
                            dateFormat(
                              lastUpdated.toString(),
                              ref: ref,
                              context: context,
                              showHOURorMINUTE: true,
                            ),
                          ),
                          style: context.shiori.text.meta.copyWith(
                            color: context.shiori.color.fgMuted,
                          ),
                        ),
                      ),
                    ),
                  CustomSliverGroupedListView<SeriesDayUpdates, String>(
                    // One row per series and day: a batch of chapters from
                    // one series no longer floods the day.
                    elements: groups,
                    groupBy: (element) => element.day,
                    groupSeparatorBuilder: (String groupByValue) {
                      final day = [
                        for (final g in groups)
                          if (g.day == groupByValue)
                            for (final u in g.updates) chapterByUpdateId[u.id]!,
                      ];
                      // Downloads are hidden on a TV, so is this.
                      final canDownload =
                          !isTv &&
                          day.any((c) {
                            final entry = downloadRepository.getByChapterId(
                              c.id,
                            );
                            return entry == null ||
                                !(entry.isDownload ?? false);
                          });
                      return ShioriSectionHeader(
                        overline: true,
                        title: dateFormat(
                          null,
                          context: context,
                          stringDate: groupByValue,
                          ref: ref,
                        ),
                        actionLabel: canDownload ? l10n.download_all : null,
                        onAction: canDownload ? () => _downloadDay(day) : null,
                      );
                    },
                    itemBuilder: (context, element) {
                      final manga = mangaById[element.mangaId]!;
                      final chapters = [
                        for (final u in element.updates)
                          chapterByUpdateId[u.id]!,
                      ];
                      if (chapters.length == 1) {
                        return UpdateChapterListTileWidget(
                          chapter: chapters.single,
                          manga: manga,
                          sourceExist: true,
                        );
                      }
                      return SeriesUpdatesTile(
                        key: ValueKey('${element.mangaId}-${element.day}'),
                        manga: manga,
                        chapters: chapters,
                      );
                    },
                    itemComparator: (item1, item2) =>
                        item1.latest.compareTo(item2.latest),
                    order: GroupedListOrder.DESC,
                  ),
                ],
              );
            }
            return ShioriEmptyState(
              icon: Symbols.new_releases_rounded,
              title: l10n.no_recent_updates,
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorState(detail: error.toString());
          },
          loading: () {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [for (var i = 0; i < 8; i++) const ShioriSkeletonRow()],
            );
          },
        ),
        if (widget.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: ShioriSpace.s32),
              child: Center(child: RefreshProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

Widget _updateNumbers(WidgetRef ref, ItemType itemType) {
  return StreamBuilder(
    stream: updateRepository.watchUnreadByItemType(itemType),
    builder: (context, snapshot) {
      final count = snapshot.data?.length ?? 0;
      if (count == 0) return const SizedBox.shrink();
      // The gap lives here so a tab with no badge keeps no trailing space.
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: ShioriSpace.s8),
        child: EntryBadgeChip(label: count.toString()),
      );
    },
  );
}
