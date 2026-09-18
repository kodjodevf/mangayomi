import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_viewer.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/manga/detail/widgets/split_chapters_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/utils.dart';

/// The detail page's info block: cover, title, favourite/webview/tracker
/// actions, description (collapsible), genre chips and the
/// recommendations/related/watch-order strip. A separate widget so it owns
/// its own "description expanded" state instead of that living on the whole
/// page's State.
class MangaInfoHeader extends ConsumerStatefulWidget {
  final Manga manga;
  final bool isLocalArchive;
  final Widget titleDescription;
  final Widget action;
  final int chapterLength;

  const MangaInfoHeader({
    super.key,
    required this.manga,
    required this.isLocalArchive,
    required this.titleDescription,
    required this.action,
    required this.chapterLength,
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
                Theme.of(context).scaffoldBackgroundColor
                    .withValues(alpha: 0.05),
                Theme.of(context).scaffoldBackgroundColor,
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
                    child: IconButton(
                      onPressed: () {
                        _editLocalArchiveInfos();
                      },
                      icon: const CircleAvatar(
                        child: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ),
              ],
            ),
            _actionFavouriteAndWebview(),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.manga.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: widget.manga.genre!.isEmpty
                        ? const SizedBox(height: 30)
                        : _expanded || context.isTablet
                        ? Wrap(
                            children: [
                              for (
                                var i = 0;
                                i < widget.manga.genre!.length;
                                i++
                              )
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                    bottom: 5,
                                  ),
                                  child: SizedBox(
                                    height: 30,
                                    child: PopupMenuButton(
                                      popUpAnimationStyle: popupAnimationStyle,
                                      itemBuilder: (context) {
                                        return [
                                          // 48 rather than 40: these are the
                                          // only two menu rows in the app that
                                          // set their own height, and 40 is
                                          // under the minimum target on both
                                          // Material and Apple.
                                          PopupMenuItem<int>(
                                            height: 48,
                                            value: 0,
                                            child: Text(
                                              context.l10n.genre_search_library,
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            height: 48,
                                            value: 1,
                                            child: Text(
                                              context.l10n.genre_search_source,
                                            ),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) async {
                                        final source = getSource(
                                          widget.manga.lang!,
                                          widget.manga.source!,
                                          widget.manga.sourceId,
                                        );
                                        if (source == null) {
                                          botToast(l10n.source_not_added);
                                          return;
                                        }
                                        if (value == 0) {
                                          final genre = widget.manga.genre![i];
                                          switch (widget.manga.itemType) {
                                            case ItemType.manga:
                                              context.pushReplacement(
                                                '/MangaLibrary',
                                                extra: genre,
                                              );
                                              break;
                                            case ItemType.anime:
                                              context.pushReplacement(
                                                '/AnimeLibrary',
                                                extra: genre,
                                              );
                                              break;
                                            case ItemType.novel:
                                              context.pushReplacement(
                                                '/NovelLibrary',
                                                extra: genre,
                                              );
                                              break;
                                          }
                                        } else {
                                          context.pushReplacement(
                                            '/mangaHome',
                                            extra: (source, false),
                                          );
                                        }
                                      },
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.grey
                                              .withValues(alpha: 0.2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        onPressed: null,
                                        child: Text(
                                          widget.manga.genre![i],
                                          style: TextStyle(
                                            // 11 is the chip step. 11.5 is not
                                            // on the scale and renders
                                            // inconsistently across platforms.
                                            fontSize: 11,
                                            // The theme already answers this;
                                            // picking black or white by hand
                                            // ignores the palette.
                                            color: context.textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 2,
                                      right: 2,
                                      bottom: 5,
                                    ),
                                    child: SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.grey
                                              .withValues(alpha: 0.2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          widget.manga.genre![i],
                                          style: TextStyle(
                                            // 11 is the chip step. 11.5 is not
                                            // on the scale and renders
                                            // inconsistently across platforms.
                                            fontSize: 11,
                                            // The theme already answers this;
                                            // picking black or white by hand
                                            // ignores the palette.
                                            color: context.textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),
                  _DetailActions(manga: widget.manga),
                  const SizedBox(height: 15),
                  if (!context.isTablet)
                    Column(
                      children: [
                        //Description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: widget.isLocalArchive
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red[400],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.isLocalArchive)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    color: context.secondaryColor,
                                  ),
                                  label: Text(
                                    widget.manga.itemType != ItemType.anime
                                        ? l10n.add_chapters
                                        : l10n.add_episodes,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: context.secondaryColor,
                                    ),
                                  ),
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
                      ],
                    ),
                ],
              ),
            ),
            if (widget.chapterLength == 0)
              Container(
                width: context.width(1),
                height: context.height(1),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
          ],
        ),
      ],
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      child: GestureDetector(
        onTap: () {
          _openImage(imageProvider);
        },
        child: SizedBox(
          width: 65 * 1.5,
          height: 65 * 2.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
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
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            final name = widget.manga.name;
            if (name != null && name.trim().isNotEmpty) {
              context.push('/globalSearch', extra: (name, widget.manga.itemType));
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
            style: const TextStyle(fontSize: 20),
          ),
        ),
        widget.titleDescription,
      ],
    );
  }

  Widget _actionFavouriteAndWebview() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: widget.action),
          if (!widget.isLocalArchive) Expanded(child: _smartUpdateDays()),
          _action(),
          if (!widget.isLocalArchive)
            Expanded(
              child: SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                  ),
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
                    } else if (!baseUrl.endsWith("/") &&
                        !link.startsWith("/")) {
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.public,
                        size: 20,
                        color: context.secondaryColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.webview,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _smartUpdateDays() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        onPressed: () =>
            context.push("/calendarScreen", extra: widget.manga.itemType),
        child: Column(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 20,
              color: context.secondaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              widget.manga.smartUpdateDays != null
                  ? context.l10n.n_days(widget.manga.smartUpdateDays!)
                  : "N/A",
              style: TextStyle(fontSize: 11, color: context.secondaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
            onPressed: () {
              _trackingDraggableMenu(entries);
            },
            child: StreamBuilder(
              stream: trackRepository.watchByMangaId(widget.manga.id!),
              builder: (context, snapshot) {
                final l10n = l10nLocalizations(context)!;
                List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
                bool isNotEmpty = trackRes!.isNotEmpty;
                Color color = isNotEmpty
                    ? context.primaryColor
                    : context.secondaryColor;
                return Column(
                  children: [
                    Icon(
                      isNotEmpty ? Icons.done_rounded : Icons.sync_outlined,
                      size: 20,
                      color: color,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isNotEmpty
                          ? trackRes.length == 1
                                ? l10n.one_tracker
                                : l10n.n_tracker(trackRes.length)
                          : l10n.tracking,
                      style: TextStyle(fontSize: 11, color: color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
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
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.edit),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(l10n.name),
                      ),
                      TextFormField(controller: name),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(l10n.description),
                      ),
                      TextFormField(controller: description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 15),
                TextButton(
                  onPressed: () {
                    final manga = widget.manga;
                    manga.description = description.text;
                    manga.name = name.text;
                    mangaRepository.save(manga);
                    Navigator.pop(context);
                  },
                  child: Text(l10n.edit),
                ),
              ],
            ),
          ],
        );
      },
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

/// One action on the detail page.
class _DetailAction {
  const _DetailAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
}

/// The things you can do with a title from its detail page, as one control.
///
/// These used to be up to three full-width buttons stacked down the page, each
/// carrying the same right-arrow icon, so the column said nothing about what
/// any of them did and grew a row every time an action was added.
///
/// One bordered strip of equal segments rather than loose buttons. Loose ones
/// size to their labels, so they sat ragged and adrift in the middle of a
/// desktop window and left an orphan on the second line of a phone. Segments
/// divide the width they are given, which means the strip looks deliberate at
/// any width and with two, three or four actions in it.
class _DetailActions extends ConsumerWidget {
  const _DetailActions({required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;

    final recommendations = _DetailAction(
      icon: Icons.auto_awesome_outlined,
      label: l10n.recommendations,
      onPressed: () => context.push(
        "/recommendations",
        extra: (
          manga.name,
          manga.itemType,
          ref.read(algorithmWeightsStateProvider),
        ),
      ),
    );

    // Everything this title is related to, including the one thing that
    // cannot be reached any other way from in here: its adaptation in the
    // other medium.
    final related = _DetailAction(
      icon: Icons.account_tree_outlined,
      label: l10n.related_titles,
      onPressed: () =>
          context.push("/related", extra: (manga.name!, manga.itemType)),
    );

    if (manga.itemType != ItemType.anime) {
      return _strip(context, [recommendations, related]);
    }

    final watchOrder = _DetailAction(
      icon: Icons.format_list_numbered_outlined,
      label: l10n.watch_order,
      onPressed: () => context.push("/watchOrder", extra: (manga.name, null)),
    );

    // Sequels needs a MyAnimeList or AniList track to look anything up, so it
    // only appears once there is one.
    return StreamBuilder(
      stream: trackRepository.watchByMangaId(manga.id!),
      builder: (context, snapshot) {
        final tracks = snapshot.data ?? const <Track>[];
        final syncId = tracks.firstOrNull?.syncId;
        final supported =
            syncId == TrackerProviders.myAnimeList.syncId ||
            syncId == TrackerProviders.anilist.syncId;

        return _strip(context, [
          recommendations,
          related,
          watchOrder,
          if (tracks.isNotEmpty && supported)
            _DetailAction(
              icon: Icons.playlist_play_outlined,
              label: l10n.sequels,
              onPressed: () => context.push(
                "/watchOrder",
                extra: (manga.name, tracks.firstOrNull),
              ),
            ),
        ]);
      },
    );
  }

  Widget _strip(BuildContext context, List<_DetailAction> actions) {
    // Tinted rather than the neutral outline, so the border belongs to the
    // accent the segments are drawn in. Kept faint: it frames the strip, it
    // is not another thing to look at.
    final outline = context.primaryColor.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: outline),
          borderRadius: BorderRadius.circular(16),
        ),
        // So a segment's ink and its focus highlight stay inside the border.
        clipBehavior: Clip.antiAlias,
        // Every segment as tall as the tallest, which is what keeps the
        // dividers full height when one label wraps to two lines.
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0)
                  VerticalDivider(width: 1, thickness: 1, color: outline),
                Expanded(child: _segment(context, actions[i])),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Icon above label rather than beside it. These labels are localised and
  /// some translations are long; stacked, a long one takes a second line
  /// instead of pushing the icon out or clipping.
  Widget _segment(BuildContext context, _DetailAction action) {
    // The accent, so the strip reads as something to press and follows
    // whichever colour the user picked rather than sitting in body-text grey.
    final accent = context.primaryColor;

    return InkWell(
      onTap: action.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: 20, color: accent),
            const SizedBox(height: 5),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
