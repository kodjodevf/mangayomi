import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/library/tv_home/tv_home_layout.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_home_card.dart';

/// A titled horizontal row of cover cards, sized by the current density scale.
class TvHomeRow extends ConsumerWidget {
  const TvHomeRow({super.key, required this.title, required this.items});
  final String title;
  final List<Manga> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridSize = tvGridSize(ref);
    final width = tvCardWidth(context, gridSize);
    final height = tvRowHeight(context, gridSize);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: height,
            child: FocusTraversalGroup(
              child: SuperListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) => SizedBox(
                  width: width,
                  child: TvHomeCard(manga: items[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat grid of a Manga list (leaf view — a plain grid navigates predictably).
/// Shared by search results and a selected category.
class TvMangaGrid extends ConsumerWidget {
  const TvMangaGrid({super.key, required this.items, this.emptyLabel = ''});
  final List<Manga> items;

  /// Only reachable where [items] can legitimately be empty.
  final String emptyLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyLabel, textAlign: TextAlign.center),
        ),
      );
    }
    return GridView.builder(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      gridDelegate: tvGridDelegate(tvGridSize(ref)),
      itemCount: items.length,
      itemBuilder: (context, index) => TvHomeCard(manga: items[index]),
    );
  }
}
