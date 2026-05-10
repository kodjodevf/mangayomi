import 'dart:async';

import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MassMigrationSourceIcon(source: widget.destinationSource),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.mass_migration_finding_matches(
                    widget.destinationSource.name ?? '',
                    completeLanguageName(widget.destinationSource.lang ?? ''),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: (_currentIndex + 1) / total),
          const SizedBox(height: 8),
          Text(l10n.mass_migration_processing_item(_currentIndex + 1, total)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MassMigrationCover(
                    libraryItem: currentItem,
                    source: widget.sourceGroup.source,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentItem.name ?? l10n.mass_migration_unknown_title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          [
                            widget.sourceGroup.sourceName,
                            l10n.mass_migration_chapter_count(
                              currentItem.chapters.length,
                            ),
                          ].join(' • '),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isWaitingForNextItem) ...[
            const SizedBox(height: 12),
            Text(l10n.mass_migration_waiting_next_item),
          ],
          if (_resolvedItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.mass_migration_matched_so_far(
                _resolvedItems.where((item) => item.hasMatch).length,
              ),
            ),
            Text(
              l10n.mass_migration_no_match_count(
                _resolvedItems.where((item) => !item.hasMatch).length,
              ),
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
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MassMigrationSourceIcon(source: widget.destinationSource),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.mass_migration_review_matches(
                            widget.destinationSource.name ?? '',
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.mass_migration_found_matches(matchedCount)),
                  Text(l10n.mass_migration_no_matches(noMatchCount)),
                  Text(l10n.mass_migration_selected_to_migrate(selectedCount)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: _resolvedItems.length,
            itemBuilder: (context, index) {
              final item = _resolvedItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: _buildResolvedItemCard(context, item, index),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _startMigration,
              child: Text(
                selectedCount == 0
                    ? l10n.mass_migration_finish_review
                    : l10n.mass_migration_migrate_selected(selectedCount),
              ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mass_migration_migrating_selected(
              widget.destinationSource.name ?? '',
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: selectedItems.isEmpty ? 1 : (_currentIndex + 1) / total,
          ),
          const SizedBox(height: 8),
          Text(
            selectedItems.isEmpty
                ? l10n.mass_migration_no_items_selected
                : l10n.mass_migration_migrating_item(_currentIndex + 1, total),
          ),
          const SizedBox(height: 16),
          if (currentItem != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MassMigrationCover(
                      libraryItem: currentItem.sourceItem,
                      source: widget.sourceGroup.source,
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward_rounded),
                    const SizedBox(width: 12),
                    MassMigrationCover(
                      remoteItem: currentItem.selectedCandidate,
                      source: widget.destinationSource,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentItem.sourceItem.name ??
                                l10n.mass_migration_unknown_title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentItem.selectedCandidate?.name ??
                                l10n.mass_migration_unknown_match,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isWaitingForNextItem) ...[
            const SizedBox(height: 12),
            Text(l10n.mass_migration_waiting_next_migration),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryPhase(BuildContext context) {
    final l10n = context.l10n;
    final total = widget.sourceGroup.items.length;
    final matchedCount = _resolvedItems.where((item) => item.hasMatch).length;
    final successTone = _failedItems.isEmpty ? Colors.green : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: successTone.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _failedItems.isEmpty
                        ? Icons.task_alt_rounded
                        : Icons.done_all_rounded,
                    color: successTone,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.mass_migration_complete,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _failedItems.isEmpty
                            ? l10n.mass_migration_complete_success_message
                            : l10n.mass_migration_complete_partial_message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.mass_migration_route_summary(
                          widget.sourceGroup.sourceName,
                          widget.destinationSource.name ?? '',
                        ),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
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
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mass_migration_failed_items,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  for (final item in _failedItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _exitMassMigrationFlow,
            icon: const Icon(Icons.exit_to_app_rounded),
            label: Text(l10n.mass_migration_exit),
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
        padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded),
                const SizedBox(width: 12),
                MassMigrationCover(
                  remoteItem: item.selectedCandidate,
                  source: widget.destinationSource,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sourceItem.name ??
                            l10n.mass_migration_unknown_title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.hasMatch
                            ? (item.selectedCandidate?.name ??
                                  l10n.mass_migration_unknown_match)
                            : l10n.mass_migration_no_destination_match,
                      ),
                      const SizedBox(height: 6),
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
                        ].join(' • '),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ((item.errorMessage ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(item.errorMessage!),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: Text(l10n.mass_migration_skip),
                  selected: !item.shouldMigrate,
                  onSelected: (_) => _updateShouldMigrate(index, false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(l10n.migrate),
                  selected: item.shouldMigrate,
                  onSelected: item.canMigrate
                      ? (_) => _updateShouldMigrate(index, true)
                      : null,
                ),
                const Spacer(),
                if (item.searchResult.candidates.length > 1)
                  TextButton(
                    onPressed: _loadingCandidateIndexes.contains(index)
                        ? null
                        : () => _pickAnotherCandidate(index),
                    child: Text(
                      _loadingCandidateIndexes.contains(index)
                          ? l10n.mass_migration_loading
                          : l10n.mass_migration_choose_another_result,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
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
    final selected = await showModalBottomSheet<MManga>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            itemCount: item.searchResult.candidates.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, candidateIndex) {
              final l10n = context.l10n;
              final candidate = item.searchResult.candidates[candidateIndex];
              return ListTile(
                title: Text(
                  candidate.name ?? l10n.mass_migration_unknown_title,
                ),
                subtitle: Text(
                  [
                    if ((candidate.author ?? '').trim().isNotEmpty)
                      candidate.author!,
                    if ((candidate.artist ?? '').trim().isNotEmpty)
                      candidate.artist!,
                  ].join(' • '),
                ),
                onTap: () => Navigator.pop(context, candidate),
              );
            },
          ),
        );
      },
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

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
