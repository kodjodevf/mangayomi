import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/in_library_badge.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/manga/widgets/manga_image_card_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  final String? search;
  final ItemType itemType;
  const GlobalSearchScreen({this.search, required this.itemType, super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

/// Caps how many source rows fetch at once.
///
/// Every row used to call getPopular/search in initState, so opening the
/// screen fired one isolate evaluation per installed source simultaneously —
/// the more extensions installed, the worse the stall. Gating it to a
/// handful in flight keeps the device's isolate pool from being flooded
/// while still finishing the full scan in the background.
class FetchGate {
  FetchGate(this._maxConcurrent);
  final int _maxConcurrent;
  int _active = 0;
  final _waiting = <Completer<void>>[];

  Future<void> acquire() async {
    if (_active < _maxConcurrent) {
      _active++;
      return;
    }
    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
    _active++;
  }

  void release() {
    _active--;
    if (_waiting.isNotEmpty) _waiting.removeAt(0).complete();
  }
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  String _query = "";
  final _textEditingController = TextEditingController();
  late final bool _showNSFW = ref.read(showNSFWStateProvider);
  final _fetchGate = FetchGate(3);

  /// Every installed source for this item type, before the pinned-only and
  /// NSFW settings are applied.
  ///
  /// Kept so an empty result can say which of the three reasons it is: none
  /// installed, none pinned, or all of them hidden as NSFW. They need
  /// different things done about them.
  late final List<Source> _installedSources = sourceRepository
      .getAddedByItemType(widget.itemType);

  late final List<Source> sourceList = () {
    final sources = ref.read(onlyIncludePinnedSourceStateProvider)
        ? sourceRepository.getPinnedByItemType(widget.itemType)
        : sourceRepository.getAddedByItemType(widget.itemType);
    if (_showNSFW) return sources;
    return sources.where((e) => !(e.isNsfw ?? false)).toList();
  }();

  /// Sources that finished with nothing to show, id to the reason.
  ///
  /// They are hidden from the list and gathered into one group at the bottom,
  /// so the results are not interleaved with a dozen dead extensions.
  final Map<int, String> _nothingToShow = {};

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.search ?? "";
  }

  void _reportNothingToShow(Source source, String reason) {
    final id = source.id;
    if (id == null || _nothingToShow[id] == reason) return;
    // Reported from the child's build, so defer the parent rebuild a frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _nothingToShow[id] = reason);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.isNotEmpty ? _query : widget.search ?? "";

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          SeachFormTextField(
            onChanged: (value) {},
            onPressed: () {
              Navigator.pop(context);
            },
            onFieldSubmitted: (value) async {
              if (!(_query == _textEditingController.text)) {
                setState(() {
                  _query = "";
                });
                // Yield a frame so the empty state is rendered before re-querying
                await WidgetsBinding.instance.endOfFrame;
                setState(() {
                  _query = value;
                });
              }
            },
            onSuffixPressed: () {
              _textEditingController.clear();
              setState(() {
                _query = "";
              });
            },
            controller: _textEditingController,
          ),
        ],
      ),
      body: sourceList.isEmpty
          // Without this the screen is a search field over a blank page, which
          // reads as "nothing matched" when the truth is that nothing was
          // searched.
          ? _noSources(context)
          // Every row is built rather than lazily. A source that fails or finds
          // nothing collapses to zero height, and a lazy list that estimates
          // extents cannot cope with that: scrolling up builds more rows, they
          // resolve, they collapse, and the content shrinks under the scroll
          // position, so the view fights the finger and never reaches the top.
          // Building all of them keeps the extent stable. There is one row per
          // installed source, and a global search queries all of them anyway.
          //
          // No query yet (fresh open, or cleared) shows each source's normal
          // Popular page instead of nothing — SourceSearchScreen picks
          // getPopular vs search based on whether query is empty, so this is
          // the same per-source request every source's own Popular tab makes,
          // not extra work invented just for this screen.
          : SingleChildScrollView(
              padding: pageBottomInsets(context),
              child: Column(
                children: [
                  for (final source in sourceList)
                    SourceSearchScreen(
                      // Keyed per source as well as per query. They previously
                      // all shared one key, which is not a valid sibling key.
                      key: ValueKey('$query#${source.id}'),
                      query: query,
                      source: source,
                      fetchGate: _fetchGate,
                      onNothingToShow: (reason) =>
                          _reportNothingToShow(source, reason),
                    ),
                  _nothingToShowGroup(context),
                ],
              ),
            ),
    );
  }

  /// Why a search over no sources found nothing.
  ///
  /// Three different situations reach here and only one of them is "install
  /// something": the other two are settings that filtered every source out,
  /// and saying "no sources installed" to someone who has ten of them is
  /// worse than saying nothing.
  Widget _noSources(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final pinnedOnly = ref.read(onlyIncludePinnedSourceStateProvider);

    final (String message, String hint) = switch (noSourcesReason(
      installed: _installedSources.length,
      pinnedOnly: pinnedOnly,
    )) {
      NoSourcesReason.noneInstalled => (
        l10n.global_search_no_sources(widget.itemType.localized(l10n)),
        l10n.global_search_no_sources_hint,
      ),
      NoSourcesReason.nonePinned => (
        l10n.global_search_only_pinned(_installedSources.length),
        l10n.global_search_only_pinned_hint,
      ),
      NoSourcesReason.allNsfw => (
        l10n.global_search_all_nsfw,
        l10n.global_search_all_nsfw_hint,
      ),
    };

    return ShioriEmptyState(
      icon: Symbols.extension_off_rounded,
      title: message,
      message: hint,
    );
  }

  /// Collapsed group of every source that failed or found nothing.
  ///
  /// Collapsed by default: it is the part of the screen nobody came for. The
  /// reason is kept on each row, since it is the only clue about which
  /// extension is broken.
  Widget _nothingToShowGroup(BuildContext context) {
    if (_nothingToShow.isEmpty) return const SizedBox.shrink();
    final byId = {for (final s in sourceList) s.id: s};
    final theme = Theme.of(context);
    return Theme(
      // Drop the divider lines ExpansionTile draws by default.
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(
          Symbols.error_rounded,
          size: 18,
          color: context.shiori.color.fgMuted,
        ),
        title: Text(
          l10nLocalizations(context)!
              .sources_with_no_results(_nothingToShow.length),
          style: context.shiori.caption,
        ),
        children: [
          for (final entry in _nothingToShow.entries)
            if (byId[entry.key] != null)
              ListTile(
                dense: true,
                onTap: () {
                  final q = _query.isNotEmpty ? _query : widget.search ?? "";
                  Navigator.push(
                    context,
                    createRoute(
                      page: MangaHomeScreen(
                        query: q,
                        source: byId[entry.key]!,
                        isSearch: q.trim().isNotEmpty,
                      ),
                    ),
                  );
                },
                title: Text(byId[entry.key]!.name!),
                subtitle: Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Symbols.chevron_forward_rounded, size: 18),
              ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class SourceSearchScreen extends ConsumerStatefulWidget {
  final String query;

  final Source source;

  final FetchGate fetchGate;

  /// Called when this source finishes with nothing to show, with the reason.
  /// The parent gathers these into one collapsed group at the bottom.
  final void Function(String reason)? onNothingToShow;

  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
    required this.fetchGate,
    this.onNothingToShow,
  });

  @override
  ConsumerState<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends ConsumerState<SourceSearchScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  String _errorMessage = "";
  bool _isLoading = true;
  MPages? pages;
  Future<void> _init() async {
    // Throttled: with many sources installed, letting every row fire its
    // isolate call the moment it's built is what made this screen laggy.
    await widget.fetchGate.acquire();
    try {
      _errorMessage = "";
      // No query: same "Popular" request the source's own tab makes, so an
      // empty global search reads as a discovery feed rather than a blank
      // page, without inventing a heavier request just for this screen.
      pages = widget.query.trim().isEmpty
          ? await ref.read(
              getPopularProvider(source: widget.source, page: 1).future,
            )
          : await ref.read(
              searchProvider(
                source: widget.source,
                page: 1,
                query: widget.query,
                filterList: const [],
              ).future,
            );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    } finally {
      widget.fetchGate.release();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    // A source with nothing to show should not hold a full height slot. Failed
    // and empty sources collapse to a single line, so the sources that did
    // return results stay on screen instead of being pushed off by errors.
    final hasResults =
        _errorMessage.isEmpty && (pages?.list.isNotEmpty ?? false);
    final collapsed = !_isLoading && !hasResults;

    // Nothing to show is nothing to show. A source that errored and a source
    // that returned no match are the same non-event to someone scanning
    // results, so both are handed to the parent and drawn once, together, at
    // the bottom rather than each taking a slot in the middle of the results.
    if (collapsed) {
      widget.onNothingToShow?.call(
        _errorMessage.isNotEmpty
            ? "${l10n.failed} ${_errorMessage.replaceAll(RegExp(r'\s+'), ' ').trim()}"
            : l10n.no_result,
      );
      return const SizedBox.shrink();
    }

    final header = ListTile(
      dense: true,
      onTap: () {
        Navigator.push(
          context,
          createRoute(
            page: MangaHomeScreen(
              query: widget.query,
              source: widget.source,
              // MangaHomeScreen's search tab assumes a non-empty query; an
              // empty one here means this row is showing Popular (our
              // empty-query behavior), so open it on Popular instead of a
              // search tab with nothing to search for.
              isSearch: widget.query.trim().isNotEmpty,
            ),
          ),
        );
      },
      // The source's icon, as in the sources list, so a row of results is
      // found by its look as well as its name.
      leading: SourceIcon(iconUrl: widget.source.iconUrl),
      title: Text(widget.source.name!),
      subtitle: Text(languageName(context, widget.source.lang!)),
      trailing: const Icon(Symbols.chevron_forward_rounded),
    );

    // A Scaffold per list row was never needed; it also forces the row to
    // expand, which would defeat the collapse.
    return SizedBox(
      height: 340,
      child: ClipRect(
        child: Column(
          children: [
            header,
            // Only loading or results reach here; failures and empty results
            // returned above as a single header row. No retry: these are almost
            // always a broken extension returning the same error every time, not
            // a transient blip, and the header still opens the source.
            Flexible(
              child: _isLoading
                  // The shape of what is coming: a row of covers.
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: ShioriSpace.s8,
                      ),
                      children: [
                        for (var i = 0; i < 6; i++)
                          const Padding(
                            padding: EdgeInsets.all(ShioriSpace.s4),
                            child: SizedBox(
                              width: _cardWidth - ShioriSpace.s8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: ShioriSpace.s8,
                                children: [
                                  ShioriSkeleton.box(
                                    height: _cardHeight - ShioriSpace.s16,
                                    radius: ShioriShape.cover,
                                  ),
                                  ShioriSkeleton.line(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  : SuperListView.builder(
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      scrollDirection: Axis.horizontal,
                      padding: isTv
                          ? const EdgeInsets.symmetric(
                              horizontal: ShioriSpace.s8,
                            )
                          : null,
                      itemCount: pages!.list.length,
                      itemBuilder: (context, index) {
                        return MangaGlobalImageCard(
                          manga: pages!.list[index],
                          source: widget.source,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MangaGlobalImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final Source source;

  const MangaGlobalImageCard({
    super.key,
    required this.manga,
    required this.source,
  });

  @override
  ConsumerState<MangaGlobalImageCard> createState() =>
      _MangaGlobalImageCardState();
}

const _cardWidth = 150.0;
const _cardHeight = 220.0;

class _MangaGlobalImageCardState extends ConsumerState<MangaGlobalImageCard>
    with AutomaticKeepAliveClientMixin<MangaGlobalImageCard> {
  bool _focused = false;

  void _open() {
    pushToMangaReaderDetail(
      ref: ref,
      context: context,
      getManga: widget.manga,
      lang: widget.source.lang!,
      itemType: widget.source.itemType,
      useMaterialRoute: true,
      source: widget.source.name!,
      sourceId: widget.source.id,
    );
  }

  // Matches the long-press-to-favorite convention already used by
  // MangaImageCardListTileWidget: a direct add, no duplicate-across-sources
  // check. That check belongs to the deliberate "Add to library" button on
  // the detail page; a long-press here is a quick action and should stay one.
  void _quickAddToLibrary() {
    pushToMangaReaderDetail(
      ref: ref,
      context: context,
      getManga: widget.manga,
      lang: widget.source.lang!,
      itemType: widget.source.itemType,
      source: widget.source.name!,
      sourceId: widget.source.id,
      addToFavourite: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final getMangaDetail = widget.manga;
    // A bare GestureDetector never takes focus, so on a remote these covers
    // were unreachable: the only focusable things on the screen were the source
    // headers, and the d-pad could never get down into the results. Focus also
    // scrolls the card into view, and ensureVisible walks every enclosing
    // scrollable, so it moves the horizontal strip and the source list both.
    return Focus(
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
          _open();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      // The padding sits outside the scale deliberately: it is the room the
      // focused cover grows into. Inside, it would scale along with the card
      // and buy nothing, which is why the block had to be stretched before.
      child: Padding(
        padding: isTv
            ? const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s8,
                vertical: ShioriSpace.s8,
              )
            : const EdgeInsets.only(left: ShioriSpace.s12),
        child: AnimatedContainer(
          duration: ShioriMotion.fast,
          curve: Curves.easeOut,
          // Matches the library cover: accent ring plus a slight lift.
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ShioriShape.cover),
            border: Border.all(
              color: _focused
                  ? context.shiori.color.accentInk
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: _open,
            onLongPress: _quickAddToLibrary,
            child: StreamBuilder(
              stream: mangaRepository.watchFavoritesByItemTypeAndName(
                widget.source.itemType,
                getMangaDetail.name,
              ),
              builder: (context, snapshot) {
                final favorites = snapshot.data ?? const <Manga>[];
                final sameSource = favorites.where(
                  (m) =>
                      m.lang == widget.source.lang &&
                      m.source == widget.source.name,
                );
                final matched = sameSource.isNotEmpty
                    ? sameSource.first
                    : (favorites.isNotEmpty ? favorites.first : null);
                final hasData = matched != null;
                return Stack(
                  children: [
                    SizedBox(
                      width: _cardWidth,
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (hasData && matched.customCoverImage != null) {
                                return Image.memory(
                                  matched.customCoverImage as Uint8List,
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ShioriShape.cover,
                                ),
                                child: cachedNetworkImage(
                                  headers: ref.watch(
                                    headersProvider(
                                      source: widget.source.name!,
                                      lang: widget.source.lang!,
                                      sourceId: widget.source.id,
                                    ),
                                  ),
                                  imageUrl: toImgUrl(
                                    hasData
                                        ? matched.customCoverFromTracker ??
                                              matched.imageUrl ??
                                              ""
                                        : getMangaDetail.imageUrl ?? "",
                                  ),
                                  width: _cardWidth,
                                  height: _cardHeight,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          BottomTextWidget(
                            fontSize: context.shiori.text.meta.fontSize,
                            text: widget.manga.name!,
                            isLoading: true,
                            textColor: context.shiori.color.fg,
                            isComfortableGrid: true,
                          ),
                        ],
                      ),
                    ),
                    // Already in the library: a light veil and a label, so the
                    // cover stays recognisable. A near-black veil hid it.
                    Container(
                      width: _cardWidth,
                      height: _cardHeight,
                      color: hasData && matched.favorite!
                          ? inLibraryVeil
                          : null,
                    ),
                    if (hasData && matched.favorite!)
                      PositionedDirectional(
                        top: ShioriSpace.s8,
                        start: ShioriSpace.s8,
                        child: const InLibraryBadge(),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Why a global search has nothing to search.
///
/// Only one of these means "install something". The other two are settings
/// that filtered every source out, and telling someone with ten sources that
/// they have none is worse than saying nothing at all.
enum NoSourcesReason {
  /// Nothing installed for this item type. The novel library on a device that
  /// only ever installed manga extensions, for instance.
  noneInstalled,

  /// Sources exist, but "Only include pinned sources" is on and none of them
  /// are pinned.
  nonePinned,

  /// Sources exist and are not excluded by the pinned setting, so the NSFW
  /// filter is what removed them.
  allNsfw,
}

/// Decides which of the three it is.
///
/// Called only once the searchable list is already known to be empty, so
/// something removed every source and this works out what.
NoSourcesReason noSourcesReason({
  required int installed,
  required bool pinnedOnly,
}) {
  if (installed == 0) return NoSourcesReason.noneInstalled;
  if (pinnedOnly) return NoSourcesReason.nonePinned;
  return NoSourcesReason.allNsfw;
}
