import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_explore_sheet.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_genre_chip.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_header_action.dart';
import 'package:mangayomi/modules/manga/detail/widgets/edit_local_archive_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_viewer.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/manga/detail/widgets/split_chapters_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/modules/widgets/cover_hero.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:shiori/shiori.dart';

export 'package:mangayomi/modules/manga/detail/widgets/detail_explore_sheet.dart';
export 'package:mangayomi/modules/manga/detail/widgets/detail_genre_chip.dart';
export 'package:mangayomi/modules/manga/detail/widgets/edit_local_archive_dialog.dart';

/// The detail page's info block: cover, title, the quick actions (favourite,
/// update days, tracking, Explore, webview), description (collapsible) and
/// genre chips. A separate widget so it owns
/// its own "description expanded" state instead of that living on the whole
/// page's State.
class MangaInfoHeader extends ConsumerStatefulWidget {
  final Manga manga;
  final bool isLocalArchive;
  final Widget titleDescription;
  final Widget action;
  final int chapterLength;

  /// Scrolls the chapter list to the chapter being read; null when there is
  /// none to go to.
  final VoidCallback? onJumpToCurrent;

  /// The chapter filter chips, shown under the chapter count.
  final Widget? chapterFilters;

  const MangaInfoHeader({
    super.key,
    required this.manga,
    required this.isLocalArchive,
    required this.titleDescription,
    required this.action,
    required this.chapterLength,
    this.onJumpToCurrent,
    this.chapterFilters,
  });

  @override
  ConsumerState<MangaInfoHeader> createState() => _MangaInfoHeaderState();
}

class _MangaInfoHeaderState extends ConsumerState<MangaInfoHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.shiori.color.ink0.withValues(alpha: 0.05),
                context.shiori.color.ink0,
              ],
              stops: const [0, .3],
            ),
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.width(1),
                  child: Row(
                    children: [
                      _coverCard(),
                      Expanded(child: _titles()),
                    ],
                  ),
                ),
                if (widget.isLocalArchive)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton.filledTonal(
                      tooltip: l10n.edit,
                      onPressed: () {
                        showEditLocalArchiveDialog(
                          context,
                          manga: widget.manga,
                          l10n: l10n,
                        );
                      },
                      icon: const Icon(Symbols.edit_rounded),
                    ),
                  ),
              ],
            ),
            _actionFavouriteAndWebview(),
            // The numbers, then the one thing to do with them.
            ReadActionButton(manga: widget.manga),
            Container(
              color: context.shiori.color.ink0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.manga.description != null)
                    Padding(
                      padding: const EdgeInsets.all(ShioriSpace.s8),
                      child: ReadMoreWidget(
                        text: widget.manga.description!,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ShioriSpace.s12,
                    ),
                    child: widget.manga.genre!.isEmpty
                        ? const SizedBox(height: ShioriSpace.s32)
                        : _expanded || context.isTablet
                        ? Wrap(
                            children: [
                              for (
                                var i = 0;
                                i < widget.manga.genre!.length;
                                i++
                              )
                                _genreChip(i, l10n),
                            ],
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (
                                  var i = 0;
                                  i < widget.manga.genre!.length;
                                  i++
                                )
                                  _genreChip(i, l10n),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: ShioriSpace.s16),
                  if (!context.isTablet)
                    Column(
                      children: [
                        //Description
                        Padding(
                          padding: const EdgeInsets.all(ShioriSpace.s8),
                          child: Row(
                            mainAxisAlignment: widget.isLocalArchive
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ShioriSpace.s8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.manga.itemType != ItemType.anime
                                          ? l10n.n_chapters(
                                              widget.chapterLength,
                                            )
                                          : l10n.n_episodes(
                                              widget.chapterLength,
                                            ),
                                      style: context.shiori.text.section
                                          .copyWith(
                                            color: context.shiori.color.fg,
                                          ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        final missing = widget.manga
                                            .missingChapterCount();
                                        if (missing <= 0) {
                                          return const SizedBox.shrink();
                                        }
                                        return Text(
                                          widget.manga.itemType !=
                                                  ItemType.anime
                                              ? l10n.missing_chapters(missing)
                                              : l10n.missing_episodes(missing),
                                          style: context.shiori.text.meta
                                              .copyWith(
                                                color: context
                                                    .shiori
                                                    .color
                                                    .error
                                                    .foreground,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (widget.onJumpToCurrent != null)
                                ShioriButton.quiet(
                                  icon: Symbols.my_location_rounded,
                                  label: l10n.current_chapter,
                                  onPressed: widget.onJumpToCurrent,
                                ),
                              if (widget.isLocalArchive)
                                ShioriButton.secondary(
                                  icon: Symbols.add_rounded,
                                  label: widget.manga.itemType != ItemType.anime
                                      ? l10n.add_chapters
                                      : l10n.add_episodes,
                                  onPressed: () async {
                                    final manga = widget.manga;
                                    if (manga.source == "torrent") {
                                      addTorrent(context, manga: manga);
                                    } else {
                                      final splitChapters =
                                          manga.itemType == ItemType.novel
                                          ? await showSplitChaptersDialog(
                                              context,
                                            )
                                          : true;
                                      if (!context.mounted) return;
                                      await ref.watch(
                                        importArchivesFromFileProvider(
                                          itemType: manga.itemType,
                                          manga,
                                          init: false,
                                          splitChapters: splitChapters,
                                        ).future,
                                      );
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                        ?widget.chapterFilters,
                      ],
                    ),
                ],
              ),
            ),
            if (widget.chapterLength == 0)
              Container(
                width: context.width(1),
                height: context.height(1),
                color: context.shiori.color.ink0,
              ),
          ],
        ),
      ],
    );
  }

  Widget _genreChip(int index, AppLocalizations l10n) {
    return DetailGenreChip(
      label: widget.manga.genre![index],
      libraryLabel: l10n.genre_search_library,
      sourceLabel: l10n.genre_search_source,
      onSelected: (value) => _selectGenre(index, value, l10n),
    );
  }

  void _selectGenre(int index, int value, AppLocalizations l10n) {
    if (value == 0) {
      final genre = widget.manga.genre![index];
      switch (widget.manga.itemType) {
        case ItemType.manga:
          context.pushReplacement('/MangaLibrary', extra: genre);
          break;
        case ItemType.anime:
          context.pushReplacement('/AnimeLibrary', extra: genre);
          break;
        case ItemType.novel:
          context.pushReplacement('/NovelLibrary', extra: genre);
          break;
      }
      return;
    }

    final source = getSource(
      widget.manga.lang!,
      widget.manga.source!,
      widget.manga.sourceId,
    );
    if (source == null) {
      botToast(l10n.source_not_added);
      return;
    }
    context.pushReplacement('/mangaHome', extra: (source, false));
  }

  Widget _coverCard() {
    final imageProvider = widget.manga.customCoverImage != null
        ? MemoryImage(widget.manga.customCoverImage as Uint8List)
              as ImageProvider
        : CustomExtendedNetworkImageProvider(
            toImgUrl(
              widget.manga.customCoverFromTracker ??
                  widget.manga.imageUrl ??
                  "",
            ),
            headers: widget.manga.isLocalArchive!
                ? null
                : ref.watch(
                    headersProvider(
                      source: widget.manga.source!,
                      lang: widget.manga.lang!,
                      sourceId: widget.manga.sourceId,
                    ),
                  ),
          );
    final id = widget.manga.id;
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(ShioriShape.cover),
      child: ColoredBox(
        color: context.shiori.color.ink2,
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s16,
      ),
      child: Semantics(
        button: true,
        label: widget.manga.name,
        child: GestureDetector(
          onTap: () {
            _openImage(imageProvider);
          },
          child: SizedBox(
            width: 100,
            height: 100 / coverAspect,
            // The library cover lands here when the page opens.
            child: id == null
                ? cover
                : Hero(tag: coverHeroTag(id), child: cover),
          ),
        ),
      ),
    );
  }

  Widget _titles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(ShioriShape.badge),
          onTap: () {
            final name = widget.manga.name;
            if (name != null && name.trim().isNotEmpty) {
              context.push(
                '/globalSearch',
                extra: (name, widget.manga.itemType),
              );
            }
          },
          onLongPress: () async {
            final name = widget.manga.name;
            if (name != null && name.isNotEmpty) {
              await Clipboard.setData(ClipboardData(text: name));
              if (mounted) {
                botToast(context.l10n.error_reports_copied, second: 2);
              }
            }
          },
          child: Text(
            widget.manga.name!,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: context.shiori.text.seriesTitle.copyWith(
              color: context.shiori.color.fg,
            ),
          ),
        ),
        widget.titleDescription,
      ],
    );
  }

  Widget _actionFavouriteAndWebview() {
    return Container(
      color: context.shiori.color.ink0,
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widget.action),
          if (!widget.isLocalArchive) Expanded(child: _smartUpdateDays()),
          _action(),
          Expanded(child: DetailExploreButton(manga: widget.manga)),
          if (!widget.isLocalArchive)
            Expanded(
              child: DetailHeaderAction(
                icon: Symbols.public_rounded,
                label: context.l10n.webview,
                onPressed: () async {
                  final manga = widget.manga;

                  final source = getSource(
                    widget.manga.lang!,
                    widget.manga.source!,
                    widget.manga.sourceId,
                  );
                  if (source == null) return;
                  String url = "";
                  final baseUrl = source.baseUrl;
                  final link = widget.manga.link!.getUrlWithoutDomain;
                  if (baseUrl == null) return;
                  if (baseUrl.endsWith("/") && link.startsWith("/")) {
                    url = baseUrl + link.substring(1);
                  } else if (!baseUrl.endsWith("/") && !link.startsWith("/")) {
                    url = "$baseUrl/$link";
                  } else {
                    url = "$baseUrl$link";
                  }

                  Map<String, dynamic> data = {
                    'url': url,
                    'sourceId': source.id.toString(),
                    'title': manga.name!,
                  };
                  context.push("/mangawebview", extra: data);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _smartUpdateDays() {
    return DetailHeaderAction(
      icon: Symbols.hourglass_rounded,
      // How often the series updates, as the calendar estimates it.
      label: widget.manga.smartUpdateDays != null
          ? context.l10n.every_n_days(widget.manga.smartUpdateDays!)
          : context.l10n.update_interval_unknown,
      onPressed: () =>
          context.push("/calendarScreen", extra: widget.manga.itemType),
    );
  }

  /// Tracker button
  Widget _action() {
    return StreamBuilder(
      stream: trackRepository.watchAllWithSyncId(),
      builder: (context, snapshot) {
        List<TrackPreference>? entries = snapshot.hasData ? snapshot.data! : [];
        if (entries.isEmpty) {
          return SizedBox.shrink();
        }
        return Expanded(
          child: StreamBuilder(
            stream: trackRepository.watchByMangaId(widget.manga.id!),
            builder: (context, snapshot) {
              final l10n = l10nLocalizations(context)!;
              List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
              bool isNotEmpty = trackRes!.isNotEmpty;
              return DetailHeaderAction(
                icon: isNotEmpty ? Symbols.done_rounded : Symbols.sync_rounded,
                active: isNotEmpty,
                label: isNotEmpty
                    ? trackRes.length == 1
                          ? l10n.one_tracker
                          : l10n.n_tracker(trackRes.length)
                    : l10n.tracking,
                onPressed: () {
                  _trackingDraggableMenu(entries);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openImage(ImageProvider imageProvider) {
    showMangaCoverViewer(
      context,
      manga: widget.manga,
      imageProvider: imageProvider,
    );
  }

  void _trackingDraggableMenu(List<TrackPreference>? entries) {
    openTrackingMenu(
      context: context,
      manga: widget.manga,
      entries: entries ?? const [],
    );
  }
}
