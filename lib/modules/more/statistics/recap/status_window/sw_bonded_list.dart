import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

const _path = '/statistics/bonded';

String bondedListLocation(ItemType itemType) => '$_path?type=${itemType.name}';

final bondedListRoute = GoRoute(
  path: _path,
  pageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: SwBondedListScreen(
      itemType:
          ItemType.values.asNameMap()[state.uri.queryParameters['type']] ??
          ItemType.manga,
    ),
  ),
);

/// Every series you've read, longest bond first.
class SwBondedListScreen extends ConsumerWidget {
  const SwBondedListScreen({super.key, required this.itemType});

  final ItemType itemType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = SwText(ref.watch(recapFontsProvider));
    final data = ref.watch(statusWindowProvider(itemType: itemType));
    return Scaffold(
      backgroundColor: SwColors.bg,
      appBar: AppBar(
        backgroundColor: SwColors.bg,
        foregroundColor: SwColors.text,
        surfaceTintColor: SwColors.bg,
        title: Text(context.l10n.recapBondedTitle, style: text.windowTitle),
      ),
      body: data.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: SwColors.cyan),
        ),
        error: (err, _) => ErrorState(detail: err.toString()),
        data: (data) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            ShioriSpace.s8,
            ShioriSpace.s16,
            ShioriSpace.s48,
          ),
          itemCount: data.bonded.length,
          separatorBuilder: (_, _) =>
              const Divider(height: ShioriSpace.s16, color: SwColors.hairline),
          itemBuilder: (context, i) => _BondedRow(
            rank: i + 1,
            series: data.bonded[i],
            itemType: itemType,
            text: text,
          ),
        ),
      ),
    );
  }
}

class _BondedRow extends StatelessWidget {
  const _BondedRow({
    required this.rank,
    required this.series,
    required this.itemType,
    required this.text,
  });

  static const _rankWidth = 44.0;
  static const _coverWidth = 48.0;

  final int rank;
  final RecapSeries series;
  final ItemType itemType;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: SwShape.window,
      onTap: () => openSeries(context, series.id),
      child: Row(
        children: [
          SizedBox(
            width: _rankWidth,
            child: Text(
              '#$rank',
              style: rank == 1
                  ? text.rank.copyWith(color: SwColors.gold)
                  : text.rank,
            ),
          ),
          ClipRRect(
            borderRadius: SwShape.window,
            child: RecapCover(
              mangaId: series.id,
              placeholder: SwColors.coverPlaceholder,
              width: _coverWidth,
              height: _coverWidth * 3 / 2,
            ),
          ),
          const SizedBox(width: ShioriSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ShioriSpace.s4,
              children: [
                Text(
                  series.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyStrong,
                ),
                Text(
                  bondDetail(context, series, itemType),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
