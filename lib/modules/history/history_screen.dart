import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/widgets/base_library_tab_screen.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';

import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/widgets/deferred_cover_image.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:shiori/shiori.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends BaseLibraryTabScreenState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _syncActiveItemType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncActiveItemType();
  }

  void _syncActiveItemType() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(activeHistoryItemTypeStateProvider.notifier)
            .set(getCurrentItemType());
      }
    });
  }

  @override
  void onTabChanged(ItemType type) {
    ref.read(activeHistoryItemTypeStateProvider.notifier).set(type);
  }

  @override
  String get title => l10nLocalizations(context)!.history;

  @override
  String? get navRoute => '/history';

  @override
  Widget buildTab(ItemType type) {
    return HistoryTab(itemType: type, query: textEditingController.text);
  }

  @override
  List<Widget> buildExtraActions(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return [
      IconButton(
        splashRadius: 20,
        focusColor: tvIconFocusColor(context),
        tooltip: l10n.remove_everything,
        icon: const Icon(Symbols.delete_sweep_rounded),
        onPressed: () async {
          final confirmed = await showShioriConfirm(
            context,
            title: l10n.remove_everything,
            message: l10n.remove_everything_msg,
            confirmLabel: l10n.ok,
            cancelLabel: l10n.cancel,
            destructive: true,
          );
          if (confirmed) await _clearHistory();
        },
      ),
    ];
  }

  Future<void> _clearHistory() async {
    final idsToDelete = await historyRepository.getIdsByItemType(
      getCurrentItemType(),
    );
    await historyRepository.deleteAll(idsToDelete);
  }
}

class HistoryTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  const HistoryTab({required this.itemType, required this.query, super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// Rows removed but not yet deleted, so "Undo" can bring them back: the
  /// deletion is only written once the toast has gone, or the screen has.
  final _pendingRemoval = <int>{};
  final _removalTimers = <int, Timer>{};

  @override
  void dispose() {
    for (final MapEntry(key: id, value: timer) in _removalTimers.entries) {
      timer.cancel();
      historyRepository.delete(id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final history = ref.watch(
      getAllHistoryStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );
    return history.when(
      data: (allEntries) {
        // Batch-resolve chapter/manga for every entry in one multi-get each,
        // instead of each row's IsarLink.value doing its own blocking sync
        // DB read — that was firing per row as it scrolled into view (every
        // unloaded IsarLink.value synchronously calls loadSync()).
        final chapterIds = allEntries
            .map((e) => e.chapterId)
            .whereType<int>()
            .toSet()
            .toList();
        final chapterById = {
          for (final c in chapterRepository.getAllByIds(chapterIds)) c?.id!: c!,
        };
        final mangaIds = chapterById.values
            .map((c) => c.mangaId)
            .whereType<int>()
            .toSet()
            .toList();
        final mangaById = {
          for (final m in mangaRepository.getAllByIds(mangaIds)) m?.id!: m!,
        };
        final entries = allEntries.where((e) {
          if (_pendingRemoval.contains(e.id)) return false;
          final c = chapterById[e.chapterId];
          return c != null && mangaById[c.mangaId] != null;
        }).toList();
        if (entries.isNotEmpty) {
          return CustomScrollView(
            slivers: [
              CustomSliverGroupedListView<History, String>(
                elements: entries,
                groupBy: (element) => dateFormat(
                  element.date!,
                  context: context,
                  ref: ref,
                  forHistoryValue: true,
                  useRelativeTimesTamps: false,
                ),
                groupSeparatorBuilder: (String groupByValue) =>
                    ShioriSectionHeader(
                      overline: true,
                      title: dateFormat(
                        null,
                        context: context,
                        stringDate: groupByValue,
                        ref: ref,
                      ),
                    ),
                itemBuilder: (context, History element) {
                  final chapter = chapterById[element.chapterId]!;
                  final manga = mangaById[chapter.mangaId]!;
                  final remove = l10n.remove;
                  // Two focusable targets on TV, matching the Browse source
                  // rows: the entry itself, and remove. The cover's own
                  // tap-to-detail folds into the entry rather than becoming a
                  // third stop for the remote to pass through.
                  if (isTv) {
                    return TvListRow(
                      children: [
                        Expanded(
                          child: TvRowButton(
                            onTap: () => chapter.pushToReaderView(context),
                            child: _row(manga, chapter.name!, element.date!),
                          ),
                        ),
                        TvRowButton(
                          onTap: () => _remove(l10n, element.id),
                          child: Padding(
                            padding: const EdgeInsets.all(ShioriSpace.s12),
                            child: Icon(
                              Symbols.delete_rounded,
                              semanticLabel: remove,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return _row(
                    manga,
                    chapter.name!,
                    element.date!,
                    openDetail: true,
                    onTap: () => chapter.pushToReaderView(context),
                    trailing: IconButton(
                      tooltip: remove,
                      onPressed: () => _remove(l10n, element.id),
                      icon: const Icon(Symbols.delete_rounded),
                    ),
                  );
                },
                itemComparator: (item1, item2) =>
                    item1.date!.compareTo(item2.date!),
                order: GroupedListOrder.DESC,
              ),
            ],
          );
        }
        return ShioriEmptyState(
          icon: Symbols.history_rounded,
          title: l10n.nothing_read_recently,
          actionLabel: l10n.library,
          onAction: () => context.go(libraryRouteFor(widget.itemType)),
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
    );
  }

  /// History rows carry a larger cover than other lists: the series is
  /// what a reader scans this screen for.
  static const _thumbHeight = 72.0;

  Widget _row(
    Manga manga,
    String chapterName,
    String date, {
    bool openDetail = false,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ShioriListRow(
      leading: ShioriThumbnail(
        height: _thumbHeight,
        semanticLabel: openDetail ? manga.name : null,
        onTap: openDetail
            ? () => context.push('/manga-reader/detail', extra: manga.id)
            : null,
        child: _getCoverImage(manga),
      ),
      title: manga.name!,
      titleMaxLines: 2,
      subtitle: '$chapterName · ${dateFormatHour(date, context)}',
      onTap: onTap,
      trailing: trailing,
    );
  }

  Widget _getCoverImage(Manga manga) {
    const width = _thumbHeight * coverAspect;
    return DeferredCoverImage(
      width: width,
      height: _thumbHeight,
      builder: (context) => manga.customCoverImage != null
          ? Image.memory(
              manga.customCoverImage as Uint8List,
              fit: BoxFit.cover,
            )
          : cachedCompressedNetworkImage(
              headers: ref.watch(
                headersProvider(
                  source: manga.source!,
                  lang: manga.lang!,
                  sourceId: manga.sourceId,
                ),
              ),
              imageUrl: toImgUrl(
                manga.customCoverFromTracker ?? manga.imageUrl ?? "",
              ),
              width: width,
              height: _thumbHeight,
              fit: BoxFit.cover,
            ),
    );
  }

  /// Removes one row at once, with "Undo" in the toast. Removing a line of
  /// history is easy to take back, so it no longer asks first.
  void _remove(AppLocalizations l10n, int? id) {
    if (id == null) return;
    const window = Duration(seconds: 5);
    setState(() => _pendingRemoval.add(id));
    _removalTimers[id] = Timer(window, () {
      _removalTimers.remove(id);
      historyRepository.delete(id);
    });
    botToast(
      l10n.removed_from_history,
      second: window.inSeconds,
      tone: ShioriToastTone.success,
      actions: [
        ShioriToastAction(l10n.undo, () {
          _removalTimers.remove(id)?.cancel();
          if (mounted) setState(() => _pendingRemoval.remove(id));
        }),
      ],
    );
  }
}
