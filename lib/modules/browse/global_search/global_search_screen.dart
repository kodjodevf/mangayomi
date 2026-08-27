import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
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

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  String _query = "";
  final _textEditingController = TextEditingController();
  late final bool _showNSFW = ref.read(showNSFWStateProvider);

  /// Every installed source for this item type, before the pinned-only and
  /// NSFW settings are applied.
  ///
  /// Kept so an empty result can say which of the three reasons it is: none
  /// installed, none pinned, or all of them hidden as NSFW. They need
  /// different things done about them.
  late final List<Source> _installedSources = isar.sources
      .where()
      .itemTypeIsAddedEqualTo(widget.itemType, true)
      .findAllSync();

  late final List<Source> sourceList = () {
    final sources = ref.read(onlyIncludePinnedSourceStateProvider)
        ? _installedSources.where((e) => e.isPinned ?? false).toList()
        : _installedSources;
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
          : _query.isNotEmpty || widget.search != null
          // Every row is built rather than lazily. A source that fails or finds
          // nothing collapses to zero height, and a lazy list that estimates
          // extents cannot cope with that: scrolling up builds more rows, they
          // resolve, they collapse, and the content shrinks under the scroll
          // position, so the view fights the finger and never reaches the top.
          // Building all of them keeps the extent stable. There is one row per
          // installed source, and a global search queries all of them anyway.
          ? SingleChildScrollView(
              child: Column(
                children: [
                  for (final source in sourceList)
                    SourceSearchScreen(
                      // Keyed per source as well as per query. They previously
                      // all shared one key, which is not a valid sibling key.
                      key: ValueKey('$query#${source.id}'),
                      query: query,
                      source: source,
                      onNothingToShow: (reason) =>
                          _reportNothingToShow(source, reason),
                    ),
                  _nothingToShowGroup(context),
                ],
              ),
            )
          : Container(),
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.extension_off_outlined,
              size: 44,
              color: context.textColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: context.textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
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
          Icons.error_outline,
          size: 18,
          color: context.textColor.withValues(alpha: 0.7),
        ),
        title: Text(
          l10nLocalizations(context)!
              .sources_with_no_results(_nothingToShow.length),
          style: TextStyle(
            fontSize: 13,
            color: context.textColor.withValues(alpha: 0.7),
          ),
        ),
        children: [
          for (final entry in _nothingToShow.entries)
            if (byId[entry.key] != null)
              ListTile(
                dense: true,
                onTap: () => Navigator.push(
                  context,
                  createRoute(
                    page: MangaHomeScreen(
                      query: _query.isNotEmpty ? _query : widget.search ?? "",
                      source: byId[entry.key]!,
                      isSearch: true,
                    ),
                  ),
                ),
                title: Text(
                  byId[entry.key]!.name!,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: context.textColor.withValues(alpha: 0.7),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_sharp, size: 18),
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

  /// Called when this source finishes with nothing to show, with the reason.
  /// The parent gathers these into one collapsed group at the bottom.
  final void Function(String reason)? onNothingToShow;

  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
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
    try {
      _errorMessage = "";
      pages = await ref.read(
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
              isSearch: true,
            ),
          ),
        );
      },
      title: Text(widget.source.name!),
      subtitle: Text(
        completeLanguageName(widget.source.lang!),
        style: const TextStyle(fontSize: 10),
      ),
      trailing: const Icon(Icons.arrow_forward_sharp),
    );

    // A Scaffold per list row was never needed; it also forces the row to
    // expand, which would defeat the collapse.
    return SizedBox(
      height: 300,
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
                  ? const Center(child: CircularProgressIndicator())
                  : SuperListView.builder(
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      scrollDirection: Axis.horizontal,
                      padding: isTv
                          ? const EdgeInsets.symmetric(horizontal: 8)
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
            duration: const Duration(milliseconds: 200),
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
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
            : const EdgeInsets.only(left: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focused ? context.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: _open,
            child: StreamBuilder(
              stream: isar.mangas
                  .filter()
                  .langEqualTo(widget.source.lang)
                  .nameEqualTo(getMangaDetail.name)
                  .sourceEqualTo(widget.source.name)
                  .watch(fireImmediately: true),
              builder: (context, snapshot) {
                final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
                return Stack(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (hasData &&
                                  snapshot.data!.first.customCoverImage !=
                                      null) {
                                return Image.memory(
                                  snapshot.data!.first.customCoverImage
                                      as Uint8List,
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
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
                                        ? snapshot
                                                  .data!
                                                  .first
                                                  .customCoverFromTracker ??
                                              snapshot.data!.first.imageUrl ??
                                              ""
                                        : getMangaDetail.imageUrl ?? "",
                                  ),
                                  width: 110,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          BottomTextWidget(
                            fontSize: 12.0,
                            text: widget.manga.name!,
                            isLoading: true,
                            textColor: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color,
                            isComfortableGrid: true,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 150,
                      color: hasData && snapshot.data!.first.favorite!
                          ? Colors.black.withValues(alpha: 0.7)
                          : null,
                    ),
                    if (hasData && snapshot.data!.first.favorite!)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.collections_bookmark,
                            color: context.primaryColor,
                          ),
                        ),
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
