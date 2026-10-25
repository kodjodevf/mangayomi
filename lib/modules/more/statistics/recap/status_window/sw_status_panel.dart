import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/statistics_recap_state_provider.dart';
import 'package:shiori/shiori.dart';

String readerClassName(AppLocalizations l10n, ReaderClass readerClass) =>
    switch (readerClass) {
      ReaderClass.regressor => l10n.recapClassRegressor,
      ReaderClass.murimMaster => l10n.recapClassMurimMaster,
      ReaderClass.hunter => l10n.recapClassHunter,
      ReaderClass.archmage => l10n.recapClassArchmage,
      ReaderClass.romantic => l10n.recapClassRomantic,
      ReaderClass.villain => l10n.recapClassVillain,
      ReaderClass.wanderer => l10n.recapClassWanderer,
    };

String epithetText(AppLocalizations l10n, Epithet epithet) => epithet.disciple
    ? l10n.recapEpithetDisciple(epithet.source!)
    : l10n.recapEpithetWanderer(epithet.sourceCount);

/// Level, EXP, who you are, and the four headline numbers.
class SwStatusPanel extends ConsumerWidget {
  const SwStatusPanel({
    super.key,
    required this.data,
    required this.itemType,
    required this.text,
  });

  final StatusWindowData data;
  final ItemType itemType;
  final SwText text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final type = itemType.name;
    final name =
        ref.watch(statisticsReaderNameStateProvider) ?? l10n.recapDefaultName;
    final span = data.nextLevelAt - data.prevLevelAt;
    final progress = span > 0 ? (data.units - data.prevLevelAt) / span : 0.0;
    final toNext = data.nextLevelAt - data.units;
    final locale = Localizations.localeOf(context).toString();
    String count(int v) => formatCount(context, v);

    return SwWindow(
      title: l10n.recapStatusTitle,
      text: text,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LevelRing(level: data.level, text: text),
              const SizedBox(width: ShioriSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KeyValue(
                      label: l10n.recapName,
                      value: name,
                      text: text,
                      onTap: () => _editName(context, ref, name),
                    ),
                    _KeyValue(
                      label: l10n.recapClass,
                      value: readerClassName(l10n, data.readerClass),
                      text: text,
                    ),
                    _KeyValue(
                      label: l10n.recapEpithet,
                      value: epithetText(l10n, data.epithet),
                      text: text,
                    ),
                    if (data.since != null)
                      _KeyValue(
                        label: l10n.recapSince,
                        value: DateFormat.yMMM(locale).format(data.since!),
                        text: text,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ShioriSpace.s12),
          SwBar(value: progress, height: 8, border: true),
          const SizedBox(height: ShioriSpace.s4),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.recapExp(count(data.units)),
                  style: text.small,
                ),
              ),
              Text(
                l10n.recapToNextLevel(
                  count(toNext),
                  data.level + 1,
                  l10n.recapUnits(toNext, type),
                ),
                style: text.small,
              ),
            ],
          ),
          const SizedBox(height: ShioriSpace.s12),
          _StatGrid(
            text: text,
            stats: [
              (l10n.recapUnitsLabel(type), data.units, null),
              (
                l10n.recapHoursLabel,
                wholeHours(data.totalSeconds),
                data.totalSeconds >= 86400
                    ? l10n.recapHoursNote(data.totalSeconds ~/ 86400)
                    : null,
              ),
              (
                l10n.recapLibraryLabel,
                data.libraryCount,
                l10n.recapLibraryNote,
              ),
              (
                l10n.recapClearedLabel,
                data.clearedCount,
                l10n.recapClearedNote,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController(
      text: ref.read(statisticsReaderNameStateProvider) ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recapEditName),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          decoration: InputDecoration(hintText: l10n.recapDefaultName),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      ref.read(statisticsReaderNameStateProvider.notifier).set(result);
    }
  }
}

class _LevelRing extends StatelessWidget {
  const _LevelRing({required this.level, required this.text});

  final int level;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SwColors.cyan, width: 2),
        boxShadow: const [BoxShadow(color: SwColors.glow, blurRadius: 16)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.recapLevel, style: text.label),
          SwCountUp(value: level, format: (v) => '$v', style: text.level),
        ],
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({
    required this.label,
    required this.value,
    required this.text,
    this.onTap,
  });

  final String label;
  final String value;
  final SwText text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(width: 56, child: Text(label, style: text.label)),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodyStrong,
          ),
        ),
        if (onTap != null) ...[
          const SizedBox(width: ShioriSpace.s4),
          const Icon(Symbols.edit_rounded, size: 12, color: SwColors.muted),
        ],
      ],
    );
    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats, required this.text});

  final List<(String, int, String?)> stats;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    Widget cell((String, int, String?) stat) => Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: ShioriSpace.s4),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: SwColors.hairline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stat.$1, style: text.label),
            SwCountUp(
              value: stat.$2,
              format: (v) => formatCount(context, v),
              style: text.stat,
            ),
            if (stat.$3 != null) Text(stat.$3!, style: text.accent),
          ],
        ),
      ),
    );
    return Column(
      spacing: ShioriSpace.s8,
      children: [
        for (var i = 0; i < stats.length; i += 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ShioriSpace.s8,
            children: [cell(stats[i]), cell(stats[i + 1])],
          ),
      ],
    );
  }
}
