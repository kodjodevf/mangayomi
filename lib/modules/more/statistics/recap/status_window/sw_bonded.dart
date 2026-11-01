import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded_list.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

void openSeries(BuildContext context, int id) =>
    context.push('/manga-reader/detail', extra: id);

/// The series you've been reading the longest: #1 large over its own
/// blurred cover, then the next four, then a way to the full list.
class SwBonded extends StatelessWidget {
  const SwBonded({
    super.key,
    required this.bonded,
    required this.itemType,
    required this.text,
  });

  /// Every read series, longest bond first.
  final List<RecapSeries> bonded;
  final ItemType itemType;

  static const _shown = 5;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SwWindow(
      title: l10n.recapBondedTitle,
      text: text,
      child: bonded.isEmpty
          ? Text(l10n.recapBondedEmpty, style: text.body)
          : Column(
              spacing: ShioriSpace.s8,
              children: [
                _first(context, bonded.first),
                if (bonded.length > 1)
                  Row(
                    spacing: ShioriSpace.s8,
                    children: [
                      for (var i = 1; i < _shown; i++)
                        Expanded(
                          child: i < bonded.length
                              ? _small(context, bonded[i])
                              : const SizedBox(),
                        ),
                    ],
                  ),
                if (bonded.length > _shown)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.push(bondedListLocation(itemType)),
                      style: TextButton.styleFrom(
                        foregroundColor: SwColors.cyan,
                      ),
                      child: recapIconText(
                        l10n.recapBondedViewAll(
                          formatCount(context, bonded.length),
                        ),
                        Symbols.arrow_forward_rounded,
                        text.label.copyWith(color: SwColors.cyan),
                        trailing: true,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _first(BuildContext context, RecapSeries series) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => openSeries(context, series.id),
      child: ClipRRect(
        borderRadius: SwShape.window,
        child: SizedBox(
          height: 190,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    SwColors.windowBottom,
                    BlendMode.srcATop,
                  ),
                  child: RecapCover(
                    mangaId: series.id,
                    placeholder: SwColors.coverPlaceholder,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(ShioriSpace.s12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: SwShape.window,
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: RecapCover(
                          mangaId: series.id,
                          placeholder: SwColors.coverPlaceholder,
                          showTitle: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: ShioriSpace.s12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          recapIconText(
                            l10n.recapBondMax,
                            Symbols.star_rounded,
                            text.label.copyWith(color: SwColors.gold),
                          ),
                          const SizedBox(height: ShioriSpace.s4),
                          // The title yields height to the detail line on
                          // narrow phones.
                          Flexible(
                            child: Text(
                              series.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: text.bondTitle,
                            ),
                          ),
                          const SizedBox(height: ShioriSpace.s4),
                          Text(
                            bondDetail(context, series, itemType),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.body,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _small(BuildContext context, RecapSeries series) {
    return GestureDetector(
      onTap: () => openSeries(context, series.id),
      child: Semantics(
        label: series.name,
        child: ClipRRect(
          borderRadius: SwShape.window,
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                RecapCover(
                  mangaId: series.id,
                  placeholder: SwColors.coverPlaceholder,
                  showTitle: true,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      ShioriSpace.s4,
                      ShioriSpace.s12,
                      ShioriSpace.s4,
                      ShioriSpace.s4,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, SwColors.bg],
                      ),
                    ),
                    child: Text(
                      _short(context, series),
                      textAlign: TextAlign.center,
                      style: text.small.copyWith(color: SwColors.bright),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// How long you've been reading [series], or its hours when the dates to
/// tell are missing.
String bondDetail(BuildContext context, RecapSeries series, ItemType itemType) {
  final l10n = context.l10n;
  final count = formatCount(context, series.chaptersRead);
  final units = l10n.recapUnits(series.chaptersRead, itemType.name);
  if (bondMs(series) == 0) {
    return l10n.recapBondDetailHours(
      count,
      tenthHours(context, series.seconds),
      units,
    );
  }
  return l10n.recapBondDetail(count, bondSpan(context, series), units);
}

/// [bondDetail] for a small tile: "5y", "7mo", or "9.4h" without dates.
String _short(BuildContext context, RecapSeries series) {
  final l10n = context.l10n;
  if (bondMs(series) == 0) return '${tenthHours(context, series.seconds)}h';
  final span = bondLength(series);
  return switch (span.unit) {
    BondUnit.years => l10n.recapBondYearsShort(span.count),
    BondUnit.months => l10n.recapBondMonthsShort(span.count),
    BondUnit.days => l10n.recapBondDaysShort(span.count),
  };
}
