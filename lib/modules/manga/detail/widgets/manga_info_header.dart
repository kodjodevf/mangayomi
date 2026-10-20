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
import 'package:mangayomi/modules/manga/detail/widgets/detail_header_action.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_viewer.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/manga/detail/widgets/split_chapters_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/cover_hero.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:shiori/shiori.dart';

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
                        _editLocalArchiveInfos();
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
          Expanded(child: _ExploreAction(manga: widget.manga)),
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

  void _editLocalArchiveInfos() {
    final l10n = l10nLocalizations(context)!;
    TextEditingController? name = TextEditingController(
      text: widget.manga.name!,
    );
    TextEditingController? description = TextEditingController(
      text: widget.manga.description!,
    );
    showDialog(
      context: context,
      builder: (context) => ShioriDialog(
        title: l10n.edit,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: ShioriSpace.s16,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: l10n.name),
            ),
            TextField(
              controller: description,
              minLines: 2,
              maxLines: 6,
              decoration: InputDecoration(labelText: l10n.description),
            ),
          ],
        ),
        actions: [
          ShioriButton.quiet(
            label: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          ShioriButton(
            label: l10n.save,
            onPressed: () {
              final manga = widget.manga;
              manga.description = description.text;
              manga.name = name.text;
              mangaRepository.save(manga);
              Navigator.pop(context);
            },
          ),
        ],
      ),
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

/// A genre chip that exposes the same search menu in every detail layout.
class DetailGenreChip extends StatelessWidget {
  const DetailGenreChip({
    super.key,
    required this.label,
    required this.libraryLabel,
    required this.sourceLabel,
    required this.onSelected,
  });

  final String label;
  final String libraryLabel;
  final String sourceLabel;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: ShioriSpace.s4,
        bottom: ShioriSpace.s4,
      ),
      child: SizedBox(
        height: 32,
        child: MenuAnchor(
          style: shioriMenuStyle(context),
          menuChildren: [
            ShioriMenuEntry(
              ShioriMenuItem(
                label: libraryLabel,
                icon: Symbols.collections_bookmark_rounded,
                onSelected: () => onSelected(0),
              ),
            ),
            ShioriMenuEntry(
              ShioriMenuItem(
                label: sourceLabel,
                icon: Symbols.travel_explore_rounded,
                onSelected: () => onSelected(1),
              ),
            ),
          ],
          builder: (context, controller, _) => Material(
            color: context.shiori.color.ink2,
            shape: StadiumBorder(
              side: BorderSide(color: context.shiori.color.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s12,
                ),
                child: Align(
                  widthFactor: 1,
                  child: Text(
                    label,
                    style: context.shiori.text.meta.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A place a title leads to from its detail page.
class DetailExploreAction {
  const DetailExploreAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.onPressed,
  });

  final IconData icon;
  final String label;

  /// What is found there, under its name.
  final String description;
  final VoidCallback onPressed;
}

/// Explore, among the quick actions under the cover: where the title leads
/// (what is like it, what it is related to, the order to watch it in, what
/// comes after), in a sheet.
///
/// These places were first a bordered strip of segments, then a row of
/// cards down the page: either way a section of their own for what is
/// secondary on a detail page, which is read and managed first. They are
/// one action now, beside the others, and a tap opens a sheet where each
/// place is a full row with a line saying what is there.
class _ExploreAction extends StatelessWidget {
  const _ExploreAction({required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailHeaderAction(
      icon: Symbols.explore_rounded,
      label: l10n.group_explore,
      onPressed: () => showShioriSheet<void>(
        context,
        title: l10n.group_explore,
        builder: (_) => _ExplorePlaces(manga: manga),
      ),
    );
  }
}

/// The places [manga] leads to, worked out when the sheet opens: sequels
/// need a MyAnimeList or AniList track to look anything up, so they appear
/// once there is one.
class _ExplorePlaces extends ConsumerWidget {
  const _ExplorePlaces({required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Captured now: the sheet closes before the place opens.
    final router = GoRouter.of(context);
    DetailExploreAction recommendations(MediaLookupContext media) =>
        DetailExploreAction(
          icon: Symbols.auto_awesome_rounded,
          label: l10n.recommendations,
          description: l10n.explore_recommendations_subtitle,
          onPressed: () => router.push(
            "/recommendations",
            extra: (media, ref.read(algorithmWeightsStateProvider)),
          ),
        );
    // Everything this title is related to, including the one thing that
    // cannot be reached any other way from in here: its adaptation in the
    // other medium.
    final related = DetailExploreAction(
      icon: Symbols.account_tree_rounded,
      label: l10n.related_titles,
      description: l10n.explore_related_subtitle,
      onPressed: () =>
          router.push("/related", extra: (manga.name!, manga.itemType)),
    );

    if (manga.itemType != ItemType.anime) {
      return DetailExploreList(
        actions: [
          recommendations(MediaLookupContext.fromManga(manga)),
          related,
        ],
      );
    }
    return StreamBuilder(
      stream: trackRepository.watchByMangaId(manga.id!),
      builder: (context, snapshot) {
        final tracks = snapshot.data ?? const <Track>[];
        Track? sequelTrack;
        for (final track in tracks) {
          final mediaId = track.mediaId;
          if (mediaId != null &&
              mediaId > 0 &&
              (track.syncId == TrackerProviders.myAnimeList.syncId ||
                  track.syncId == TrackerProviders.anilist.syncId)) {
            sequelTrack ??= track;
          }
        }
        final media = MediaLookupContext.fromManga(manga, tracks: tracks);
        return DetailExploreList(
          actions: [
            recommendations(media),
            related,
            DetailExploreAction(
              icon: Symbols.format_list_numbered_rounded,
              label: l10n.watch_order,
              description: l10n.explore_watch_order_subtitle,
              onPressed: () =>
                  router.push("/watchOrder", extra: (media, null as Track?)),
            ),
            if (sequelTrack != null)
              DetailExploreAction(
                icon: Symbols.playlist_play_rounded,
                label: l10n.sequels,
                description: l10n.explore_sequels_subtitle,
                onPressed: () =>
                    router.push("/watchOrder", extra: (media, sequelTrack)),
              ),
          ],
        );
      },
    );
  }
}

/// The places to go, each a full row: its icon, its name, what is there, and
/// a chevron. A tap closes the sheet, then opens the place.
class DetailExploreList extends StatelessWidget {
  const DetailExploreList({super.key, required this.actions});

  final List<DetailExploreAction> actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              ShioriSettingRow(
                icon: action.icon,
                title: action.label,
                subtitle: action.description,
                trailing: const Icon(Symbols.chevron_forward_rounded),
                onTap: () {
                  Navigator.pop(context);
                  action.onPressed();
                },
              ),
          ],
        ),
      ),
    );
  }
}
