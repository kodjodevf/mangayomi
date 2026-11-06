import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

/// Public metadata images must not use the source client's cookies or settings.
/// Decode at twice the card size rather than retaining full-resolution covers.
ImageProvider discoveryCover(String url) => ResizeImage(
  NetworkImage(url, headers: const {'User-Agent': metadataApiUserAgent}),
  width: 288,
  height: 432,
  allowUpscaling: false,
);

typedef DiscoveryFeedLoader = Future<List<DiscoveryMedia>> Function({
  required ItemType itemType,
  bool popular,
  bool includeAdult,
});

/// Visible entry point from Browse; never searches or writes the library itself.
class DiscoverButton extends StatelessWidget {
  const DiscoverButton({super.key, required this.itemType});
  final ItemType itemType;
  @override
  Widget build(BuildContext context) => ShioriButton.quiet(
    onPressed: () => context.push('/discover', extra: itemType),
    icon: Symbols.explore_rounded,
    label: context.l10n.discover_title,
  );
}

/// Preferences stay at the route boundary; the catalog never reads the library.
class DiscoverRoute extends ConsumerWidget {
  const DiscoverRoute({super.key, required this.initialType});
  final ItemType initialType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(hideItemsStateProvider);
    final animeOnly = ref.watch(animeOnlyTvModeProvider);
    final includeAdult = ref.watch(showNSFWStateProvider);
    return DiscoverScreen(
      initialType: initialType,
      includeAdult: includeAdult,
      availableTypes: [
        if (!animeOnly && !hidden.contains('/MangaLibrary')) ItemType.manga,
        if (!hidden.contains('/AnimeLibrary')) ItemType.anime,
        if (!animeOnly && !hidden.contains('/NovelLibrary')) ItemType.novel,
      ],
    );
  }
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    this.loadFeed = fetchDiscoveryFeed,
    this.availableTypes = const [
      ItemType.manga,
      ItemType.anime,
      ItemType.novel,
    ],
    this.initialType = ItemType.manga,
    this.includeAdult = false,
  });
  final DiscoveryFeedLoader loadFeed;
  final List<ItemType> availableTypes;
  final ItemType initialType;
  final bool includeAdult;
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late ItemType _type = widget.initialType;
  final _pages = <(ItemType, bool), Future<List<DiscoveryMedia>>>{};

  @override
  void didUpdateWidget(covariant DiscoverScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.includeAdult != widget.includeAdult ||
        oldWidget.loadFeed != widget.loadFeed) {
      _pages.clear();
    }
  }

  Future<List<DiscoveryMedia>> _page(bool popular) => _pages.putIfAbsent(
    (_type, popular),
    () => widget.loadFeed(
      itemType: _type,
      popular: popular,
      includeAdult: widget.includeAdult,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final types = widget.availableTypes.toSet();
    if (types.isNotEmpty && !types.contains(_type)) _type = types.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discover_title),
        actions: [
          if (types.isNotEmpty)
            IconButton(
              tooltip: l10n.refresh,
              icon: const Icon(Symbols.refresh_rounded),
              onPressed: () => setState(_pages.clear),
            ),
        ],
      ),
      body: SafeArea(
        child: types.isEmpty
            ? Center(child: Text(l10n.discover_hidden))
            : ListView(
                padding: const EdgeInsets.all(ShioriSpace.s16),
                children: [
                  ShioriSegmentedControl<ItemType>(
                    segments: [
                      for (final type in types)
                        ShioriSegment(value: type, label: type.localized(l10n)),
                    ],
                    selected: _type,
                    onSelected: (type) => setState(() => _type = type),
                  ),
                  const SizedBox(height: ShioriSpace.s16),
                  Text(l10n.discover_attribution, style: tokens.caption),
                  const SizedBox(height: ShioriSpace.s24),
                  _shelf(false),
                  const SizedBox(height: ShioriSpace.s24),
                  _shelf(true),
                ],
              ),
      ),
    );
  }

  Widget _shelf(bool popular) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final type = _type;
    // shiori: discovery uses a compact horizontal shelf, not a library grid.
    final cardWidth = tokens.scaled(144);
    final titleStyle = tokens.text.card;
    final titleHeight =
        MediaQuery.textScalerOf(context).scale(titleStyle.fontSize!) *
        (titleStyle.height ?? 1.5) *
        2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          popular ? l10n.discover_popular : l10n.discover_trending,
          style: tokens.text.seriesTitle,
        ),
        const SizedBox(height: ShioriSpace.s12),
        SizedBox(
          height:
              cardWidth / coverAspect +
              ShioriSpace.s4 +
              titleHeight +
              ShioriSpace.s12,
          child: FutureBuilder<List<DiscoveryMedia>>(
            key: ValueKey((type, popular, widget.includeAdult)),
            future: _page(popular),
            builder: (context, snapshot) {
              // Do not display the old shelf while a new type is loading.
              if (snapshot.connectionState != ConnectionState.done) {
                return const ShioriLoading();
              }
              if (snapshot.hasError) {
                return ErrorState(
                  compact: true,
                  message: l10n.discover_unavailable,
                  detail: snapshot.error.toString(),
                  autofocusRetry: false,
                  onRetry: () => setState(() {
                    _pages.remove((type, popular));
                  }),
                );
              }
              final works = snapshot.data ?? const <DiscoveryMedia>[];
              if (works.isEmpty) {
                return Center(child: Text(l10n.discover_empty));
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: works.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: ShioriSpace.s12),
                itemBuilder: (context, index) {
                  final work = works[index];
                  return SizedBox(
                    width: cardWidth,
                    child: ShioriCoverTile(
                      cover: ShioriCover(
                        image: work.coverImage?.isNotEmpty == true
                            ? discoveryCover(work.coverImage!)
                            : null,
                        title: work.title,
                        onTap: () => _details(work, type),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _details(DiscoveryMedia work, ItemType type) async {
    final l10n = context.l10n;
    final router = GoRouter.of(context);
    await showShioriSheet<void>(
      context,
      title: work.title,
      builder: (sheetContext) => SingleChildScrollView(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ShioriSpace.s16,
          children: [
            if (work.genres.isNotEmpty)
              Text(work.genres.join(' · '), style: context.shiori.caption),
            Text(
              (work.description?.trim().isNotEmpty ?? false)
                  ? work.description!
                  : l10n.discover_no_description,
            ),
            ShioriButton(
              label: l10n.discover_search,
              icon: Symbols.search_rounded,
              onPressed: work.searchTitle.trim().isEmpty
                  ? null
                  : () {
                      Navigator.of(sheetContext).pop();
                      router.push(
                        '/globalSearch',
                        extra: (work.searchTitle, type),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
