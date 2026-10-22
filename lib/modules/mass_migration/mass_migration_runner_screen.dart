import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/services/mass_migration_service.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_applying_phase.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_matching_phase.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_resolved_item_card.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_summary_phase.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:shiori/shiori.dart';

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
        _MassMigrationPhase.matching => MassMigrationMatchingPhase(
          sourceGroup: widget.sourceGroup,
          destinationSource: widget.destinationSource,
          currentIndex: _currentIndex,
          resolvedItems: _resolvedItems,
          isWaitingForNextItem: _isWaitingForNextItem,
        ),
        _MassMigrationPhase.review => _buildReviewPhase(context),
        _MassMigrationPhase.applying => MassMigrationApplyingPhase(
          destinationSource: widget.destinationSource,
          sourceGroup: widget.sourceGroup,
          selectedItems: _resolvedItems
              .where((item) => item.shouldMigrate)
              .toList(),
          currentIndex: _currentIndex,
          isWaitingForNextItem: _isWaitingForNextItem,
        ),
        _MassMigrationPhase.summary => MassMigrationSummaryPhase(
          sourceGroup: widget.sourceGroup,
          destinationSource: widget.destinationSource,
          resolvedItems: _resolvedItems,
          migratedCount: _migratedCount,
          skippedCount: _skippedCount,
          failedItems: _failedItems,
          onExit: _exitMassMigrationFlow,
        ),
      },
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
                child: MassMigrationResolvedItemCard(
                  item: item,
                  index: index,
                  sourceGroup: widget.sourceGroup,
                  destinationSource: widget.destinationSource,
                  isLoadingCandidate: _loadingCandidateIndexes.contains(index),
                  onShouldMigrateChanged: (v) => _updateShouldMigrate(index, v),
                  onPickAnotherCandidate: () => _pickAnotherCandidate(index),
                ),
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
