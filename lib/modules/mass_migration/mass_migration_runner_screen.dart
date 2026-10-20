import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/services/mass_migration_service.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/language.dart';

enum _MassMigrationPhase { matching, review, applying, summary }

class MassMigrationRunnerScreen extends ConsumerStatefulWidget {
  const MassMigrationRunnerScreen({
    required this.sourceGroup,
    required this.destinationSource,
    super.key,
  });

  final MassMigrationSourceGroup sourceGroup;
  final Source destinationSource;

  @override
  ConsumerState<MassMigrationRunnerScreen> createState() =>
      _MassMigrationRunnerScreenState();
}

class _MassMigrationRunnerScreenState
    extends ConsumerState<MassMigrationRunnerScreen> {
  _MassMigrationPhase _phase = _MassMigrationPhase.matching;
  int _currentIndex = 0;
  int _migratedCount = 0;
  int _skippedCount = 0;
  final List<String> _failedItems = [];
  final Set<int> _loadingCandidateIndexes = {};
  final List<MassMigrationResolvedItem> _resolvedItems = [];
  bool _isWaitingForNextItem = false;

  @override
  void initState() {
    super.initState();
    unawaited(_processAllItems());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mass_migration_title)),
      body: switch (_phase) {
        _MassMigrationPhase.matching => _buildMatchingPhase(context),
        _MassMigrationPhase.review => _buildReviewPhase(context),
        _MassMigrationPhase.applying => _buildApplyingPhase(context),
        _MassMigrationPhase.summary => _buildSummaryPhase(context),
      },
    );
  }

  Widget _buildMatchingPhase(BuildContext context) {
    final l10n = context.l10n;
    final total = widget.sourceGroup.items.length;
    final currentItem = widget.sourceGroup.items[_currentIndex];
    return Padding(
      padding: const EdgeInsets.all(ShioriSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MassMigrationSourceIcon(source: widget.destinationSource),
              const SizedBox(width: ShioriSpace.s12),
              Expanded(
                child: Text(
                  l10n.mass_migration_finding_matches(
                    widget.destinationSource.name ?? '',
                    languageName(context, widget.destinationSource.lang ?? ''),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ShioriSpace.s16),
          ShioriProgressBar(value: (_currentIndex + 1) / total),
          const SizedBox(height: ShioriSpace.s8),
          Text(
            l10n.mass_migration_processing_item(_currentIndex + 1, total),
            style: context.shiori.caption,
          ),
          const SizedBox(height: ShioriSpace.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MassMigrationCover(
                    libraryItem: currentItem,
                    source: widget.sourceGroup.source,
                  ),
                  const SizedBox(width: ShioriSpace.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentItem.name ?? l10n.mass_migration_unknown_title,
                          style: context.shiori.text.section.copyWith(
                            color: context.shiori.color.fg,
                          ),
                        ),
                        const SizedBox(height: ShioriSpace.s8),
                        Text(
                          [
                            widget.sourceGroup.sourceName,
                            l10n.mass_migration_chapter_count(
                              currentItem.chapters.length,
                            ),
                          ].join(' · '),
                          style: context.shiori.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isWaitingForNextItem) ...[
            const SizedBox(height: ShioriSpace.s12),
            Text(
              l10n.mass_migration_waiting_next_item,
              style: context.shiori.caption,
            ),
          ],
          if (_resolvedItems.isNotEmpty) ...[
            const SizedBox(height: ShioriSpace.s16),
            Text(
              l10n.mass_migration_matched_so_far(
                _resolvedItems.where((item) => item.hasMatch).length,
              ),
              style: context.shiori.caption,
            ),
            Text(
              l10n.mass_migration_no_match_count(
                _resolvedItems.where((item) => !item.hasMatch).length,
              ),
              style: context.shiori.caption,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewPhase(BuildContext context) {
    final l10n = context.l10n;
    final matchedCount = _resolvedItems.where((item) => item.hasMatch).length;
    final selectedCount = _resolvedItems
        .where((item) => item.shouldMigrate)
        .length;
    final noMatchCount = _resolvedItems.where((item) => !item.hasMatch).length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(ShioriSpace.s16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MassMigrationSourceIcon(source: widget.destinationSource),
                      const SizedBox(width: ShioriSpace.s12),
                      Expanded(
                        child: Text(
                          l10n.mass_migration_review_matches(
                            widget.destinationSource.name ?? '',
                          ),
                          style: context.shiori.text.section.copyWith(
                            color: context.shiori.color.fg,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ShioriSpace.s12),
                  Text(
                    l10n.mass_migration_found_matches(matchedCount),
                    style: context.shiori.caption,
                  ),
                  Text(
                    l10n.mass_migration_no_matches(noMatchCount),
                    style: context.shiori.caption,
                  ),
                  Text(
                    l10n.mass_migration_selected_to_migrate(selectedCount),
                    style: context.shiori.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s16),
            itemCount: _resolvedItems.length,
            itemBuilder: (context, index) {
              final item = _resolvedItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s16,
                  vertical: ShioriSpace.s8,
                ),
                child: _buildResolvedItemCard(context, item, index),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            0,
            ShioriSpace.s16,
            ShioriSpace.s16,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ShioriButton(
              expand: true,
              onPressed: _startMigration,
              label: selectedCount == 0
                  ? l10n.mass_migration_finish_review
                  : l10n.mass_migration_migrate_selected(selectedCount),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyingPhase(BuildContext context) {
    final l10n = context.l10n;
    final selectedItems = _resolvedItems
        .where((item) => item.shouldMigrate)
        .toList();
    final total = selectedItems.isEmpty ? 1 : selectedItems.length;
    final currentItem = selectedItems.isEmpty
        ? null
        : selectedItems[_currentIndex.clamp(0, selectedItems.length - 1)];

    return Padding(
      padding: const EdgeInsets.all(ShioriSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mass_migration_migrating_selected(
              widget.destinationSource.name ?? '',
            ),
            style: context.shiori.text.section.copyWith(
              color: context.shiori.color.fg,
            ),
          ),
          const SizedBox(height: ShioriSpace.s16),
          ShioriProgressBar(
            value: selectedItems.isEmpty ? 1 : (_currentIndex + 1) / total,
          ),
          const SizedBox(height: ShioriSpace.s8),
          Text(
            selectedItems.isEmpty
                ? l10n.mass_migration_no_items_selected
                : l10n.mass_migration_migrating_item(_currentIndex + 1, total),
            style: context.shiori.caption,
          ),
          const SizedBox(height: ShioriSpace.s16),
          if (currentItem != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(ShioriSpace.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MassMigrationCover(
                      libraryItem: currentItem.sourceItem,
                      source: widget.sourceGroup.source,
                    ),
                    const SizedBox(width: ShioriSpace.s12),
                    const Icon(Symbols.arrow_forward_rounded, fill: 1),
                    const SizedBox(width: ShioriSpace.s12),
                    MassMigrationCover(
                      remoteItem: currentItem.selectedCandidate,
                      source: widget.destinationSource,
                    ),
                    const SizedBox(width: ShioriSpace.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentItem.sourceItem.name ??
                                l10n.mass_migration_unknown_title,
                            style: context.shiori.text.section.copyWith(
                              color: context.shiori.color.fg,
                            ),
                          ),
                          const SizedBox(height: ShioriSpace.s8),
                          Text(
                            currentItem.selectedCandidate?.name ??
                                l10n.mass_migration_unknown_match,
                            style: context.shiori.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isWaitingForNextItem) ...[
            const SizedBox(height: ShioriSpace.s12),
            Text(
              l10n.mass_migration_waiting_next_migration,
              style: context.shiori.caption,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryPhase(BuildContext context) {
    final l10n = context.l10n;
    final total = widget.sourceGroup.items.length;
    final matchedCount = _resolvedItems.where((item) => item.hasMatch).length;
    final tone = _failedItems.isEmpty
        ? context.shiori.color.completed
        : context.shiori.color.offline;
    final successTone = tone.foreground;

    return Container(
      decoration: BoxDecoration(color: context.shiori.color.ink0),
      child: ListView(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        children: [
          Container(
            padding: const EdgeInsets.all(ShioriSpace.s24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ShioriShape.card),
              color: context.shiori.color.ink1,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: tone.background,
                    borderRadius: BorderRadius.circular(ShioriShape.card),
                  ),
                  child: Icon(
                    _failedItems.isEmpty
                        ? Symbols.task_alt_rounded
                        : Symbols.done_all_rounded,
                    color: successTone,
                    size: 30,
                  ),
                ),
                const SizedBox(width: ShioriSpace.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.mass_migration_complete,
                        style: context.shiori.text.seriesTitle.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        _failedItems.isEmpty
                            ? l10n.mass_migration_complete_success_message
                            : l10n.mass_migration_complete_partial_message,
                        style: context.shiori.text.body.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s12),
                      Text(
                        l10n.mass_migration_route_summary(
                          widget.sourceGroup.sourceName,
                          widget.destinationSource.name ?? '',
                        ),
                        style: context.shiori.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ShioriSpace.s16),
          Wrap(
            spacing: ShioriSpace.s12,
            runSpacing: ShioriSpace.s12,
            children: [
              _SummaryStatCard(
                label: l10n.mass_migration_processed,
                value: '$total',
              ),
              _SummaryStatCard(
                label: l10n.mass_migration_matched,
                value: '$matchedCount',
              ),
              _SummaryStatCard(
                label: l10n.mass_migration_migrated,
                value: '$_migratedCount',
              ),
              _SummaryStatCard(
                label: l10n.mass_migration_skipped,
                value: '$_skippedCount',
              ),
              _SummaryStatCard(
                label: l10n.mass_migration_failed,
                value: '${_failedItems.length}',
              ),
            ],
          ),
          if (_failedItems.isNotEmpty) ...[
            const SizedBox(height: ShioriSpace.s24),
            Container(
              padding: const EdgeInsets.all(ShioriSpace.s16),
              decoration: BoxDecoration(
                color: context.shiori.color.ink1,
                borderRadius: BorderRadius.circular(ShioriShape.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mass_migration_failed_items,
                    style: context.shiori.text.section.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                  const SizedBox(height: ShioriSpace.s12),
                  for (final item in _failedItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.error_outline_rounded,
                            fill: 1,
                            size: 18,
                            color: context.shiori.color.offline.foreground,
                          ),
                          const SizedBox(width: ShioriSpace.s8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: ShioriSpace.s24),
          ShioriButton(
            onPressed: _exitMassMigrationFlow,
            icon: Symbols.exit_to_app_rounded,
            label: l10n.mass_migration_exit,
          ),
        ],
      ),
    );
  }

  Widget _buildResolvedItemCard(
    BuildContext context,
    MassMigrationResolvedItem item,
    int index,
  ) {
    final l10n = context.l10n;
    final destinationChapterNames =
        item.destinationPreview?.chapters
            ?.map(
              (chapter) => chapter.name ?? l10n.mass_migration_unknown_chapter,
            )
            .toList() ??
        const <String>[];
    final sourceChapterNames = item.sourceItem.chapters
        .map((chapter) => chapter.name ?? l10n.mass_migration_unknown_chapter)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MassMigrationCover(
                  libraryItem: item.sourceItem,
                  source: widget.sourceGroup.source,
                ),
                const SizedBox(width: ShioriSpace.s12),
                const Icon(Symbols.arrow_forward_rounded, fill: 1),
                const SizedBox(width: ShioriSpace.s12),
                MassMigrationCover(
                  remoteItem: item.selectedCandidate,
                  source: widget.destinationSource,
                ),
                const SizedBox(width: ShioriSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sourceItem.name ??
                            l10n.mass_migration_unknown_title,
                        style: context.shiori.text.section.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        item.hasMatch
                            ? (item.selectedCandidate?.name ??
                                  l10n.mass_migration_unknown_match)
                            : l10n.mass_migration_no_destination_match,
                        style: context.shiori.text.row.copyWith(
                          color: item.hasMatch
                              ? context.shiori.color.fg
                              : context.shiori.color.fgMuted,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        [
                          l10n.mass_migration_source_chapter_count(
                            item.sourceItem.chapters.length,
                          ),
                          l10n.mass_migration_destination_chapter_count(
                            destinationChapterNames.length,
                          ),
                          if ((item.searchResult.usedQuery ?? '').isNotEmpty)
                            l10n.mass_migration_query(
                              item.searchResult.usedQuery!,
                            ),
                        ].join(' · '),
                        style: context.shiori.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ((item.errorMessage ?? '').isNotEmpty) ...[
              const SizedBox(height: ShioriSpace.s8),
              Text(
                item.errorMessage!,
                style: context.shiori.text.meta.copyWith(
                  color: context.shiori.color.error.foreground,
                ),
              ),
            ],
            const SizedBox(height: ShioriSpace.s12),
            Row(
              children: [
                if (item.canMigrate)
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: ShioriSegmentedControl<bool>(
                        segments: [
                          ShioriSegment(
                            value: false,
                            label: l10n.mass_migration_skip,
                          ),
                          ShioriSegment(value: true, label: l10n.migrate),
                        ],
                        selected: item.shouldMigrate,
                        onSelected: (v) => _updateShouldMigrate(index, v),
                      ),
                    ),
                  ),
                const Spacer(),
                if (item.searchResult.candidates.length > 1)
                  ShioriButton.quiet(
                    onPressed: _loadingCandidateIndexes.contains(index)
                        ? null
                        : () => _pickAnotherCandidate(index),
                    label: _loadingCandidateIndexes.contains(index)
                        ? l10n.mass_migration_loading
                        : l10n.mass_migration_choose_another_result,
                  ),
              ],
            ),
            const SizedBox(height: ShioriSpace.s8),
            MassMigrationChapterSection(
              title: l10n.mass_migration_source_chapters,
              chapters: sourceChapterNames,
            ),
            MassMigrationChapterSection(
              title: l10n.mass_migration_destination_chapters,
              chapters: destinationChapterNames,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processAllItems() async {
    for (var i = 0; i < widget.sourceGroup.items.length; i++) {
      if (!mounted) return;
      setState(() {
        _currentIndex = i;
      });
      final resolvedItem = await resolveMassMigrationItem(
        ref: ref,
        manga: widget.sourceGroup.items[i],
        destinationSource: widget.destinationSource,
      );
      if (!mounted) return;
      setState(() {
        _resolvedItems.add(resolvedItem);
      });
      if (i < widget.sourceGroup.items.length - 1) {
        setState(() {
          _isWaitingForNextItem = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        setState(() {
          _isWaitingForNextItem = false;
        });
      }
    }

    if (!mounted) return;
    setState(() {
      _phase = _MassMigrationPhase.review;
      _currentIndex = 0;
    });
  }

  void _updateShouldMigrate(int index, bool shouldMigrate) {
    setState(() {
      _resolvedItems[index] = _resolvedItems[index].copyWith(
        shouldMigrate: shouldMigrate && _resolvedItems[index].canMigrate,
      );
    });
  }

  Future<void> _pickAnotherCandidate(int index) async {
    final item = _resolvedItems[index];
    final l10n = context.l10n;
    final selected = await showShioriChoice<MManga>(
      context,
      title: l10n.mass_migration_choose_another_result,
      selected: item.selectedCandidate,
      options: [
        for (final candidate in item.searchResult.candidates)
          ShioriChoice(
            candidate,
            candidate.name ?? l10n.mass_migration_unknown_title,
            subtitle: [
              if ((candidate.author ?? '').trim().isNotEmpty) candidate.author!,
              if ((candidate.artist ?? '').trim().isNotEmpty) candidate.artist!,
            ].join(' · '),
          ),
      ],
    );

    if (selected == null || !mounted) return;

    setState(() {
      _loadingCandidateIndexes.add(index);
    });

    try {
      final preview = await ref.read(
        getDetailProvider(
          url: selected.link!,
          source: widget.destinationSource,
        ).future,
      );
      if (!mounted) return;
      setState(() {
        _resolvedItems[index] = item.copyWith(
          selectedCandidate: selected,
          destinationPreview: preview,
          errorMessage: null,
          shouldMigrate: true,
          keepErrorMessage: false,
        );
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _resolvedItems[index] = item.copyWith(
          selectedCandidate: selected,
          destinationPreview: null,
          errorMessage: error.toString(),
          shouldMigrate: false,
          keepDestinationPreview: false,
          keepErrorMessage: false,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingCandidateIndexes.remove(index);
        });
      }
    }
  }

  Future<void> _startMigration() async {
    final selectedItems = _resolvedItems
        .where((item) => item.shouldMigrate)
        .toList();
    if (selectedItems.isEmpty) {
      setState(() {
        _skippedCount = widget.sourceGroup.items.length;
        _phase = _MassMigrationPhase.summary;
      });
      return;
    }

    setState(() {
      _phase = _MassMigrationPhase.applying;
      _migratedCount = 0;
      _skippedCount = widget.sourceGroup.items.length - selectedItems.length;
      _failedItems.clear();
      _currentIndex = 0;
    });

    for (var i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      if (!mounted) return;
      setState(() {
        _currentIndex = i;
      });

      try {
        await migrateLibraryItem(
          ref: ref,
          oldManga: item.sourceItem,
          selectedManga: item.selectedCandidate!,
          preview: item.destinationPreview!,
          destinationSource: widget.destinationSource,
        );
        if (!mounted) return;
        setState(() {
          _migratedCount += 1;
        });
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _failedItems.add(
            item.sourceItem.name ?? context.l10n.mass_migration_unknown_title,
          );
        });
      }
    }

    if (!mounted) return;
    setState(() {
      _phase = _MassMigrationPhase.summary;
    });
  }

  void _exitMassMigrationFlow() {
    final navigator = Navigator.of(context);
    var pops = 0;
    while (navigator.canPop() && pops < 4) {
      navigator.pop();
      pops++;
    }
  }
}

/// One figure of the summary: the number large and tabular, its label
/// under it, as on the statistics screen.
class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Container(
      width: 156,
      padding: const EdgeInsets.all(ShioriSpace.s16),
      decoration: BoxDecoration(
        color: tokens.color.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ShioriSpace.s4,
        children: [
          Text(
            value,
            style: tokens.text.seriesTitle.copyWith(
              color: tokens.color.fg,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(label, style: tokens.caption),
        ],
      ),
    );
  }
}
