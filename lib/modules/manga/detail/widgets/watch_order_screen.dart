import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_watch_order.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Tints are an alpha over the theme foreground or the accent, never a fixed
/// colour, because the palette is chosen at runtime. Shared with
/// recommendation_screen so the two sibling screens cannot drift apart.
const double _alphaTint = 0.08;
const double _alphaHairline = 0.16;
const double _alphaFocus = 0.14;
const double _alphaAccentTint = 0.16;
const double _alphaSecondary = 0.70;

/// Cover height over width, taken from the artwork itself: AniList serves
/// these at 230x320. Matching it means BoxFit.cover has nothing to crop, so
/// every cover shows its original framing rather than a trimmed version of it.
///
/// One value for the whole rail, so the current entry differs from the rest in
/// size only, never in shape.
const double _coverAspect = 320 / 230;

class WatchOrderScreen extends StatefulWidget {
  final String name;
  final Track? track;

  const WatchOrderScreen({super.key, required this.name, required this.track});

  @override
  State<WatchOrderScreen> createState() => _WatchOrderScreenState();
}

class _WatchOrderScreenState extends State<WatchOrderScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<SequelItem>? sequels;
  List<WatchOrderSearch>? dataSearch;
  List<WatchOrderItem>? data;

  bool get isSequels => widget.track != null;

  /// Marks the current entry so the framework can scroll it into view.
  final GlobalKey _currentRowKey = GlobalKey();
  bool _didAnchorOnCurrent = false;

  /// Opens the timeline on the entry the user is actually watching.
  ///
  /// Starting at the top of a long franchise hides where you are in it. The
  /// alignment leaves the previous entry partly visible, so it reads as "there
  /// is more in both directions" rather than as the start of the list.
  ///
  /// No offsets are computed here. [Scrollable.ensureVisible] does the
  /// positioning, and it is a no-op both when the current entry is already
  /// first and when the list is too short to scroll at all.
  ///
  /// It retries across a few frames rather than trying once. The row has to be
  /// laid out and the scroll view has to know its extent before this can do
  /// anything, and neither is guaranteed on the first frame after the data
  /// arrives: the route may still be animating in. Giving up after one silent
  /// miss is why this worked on one platform and not another.
  void _anchorOnCurrent() {
    if (_didAnchorOnCurrent) return;
    _didAnchorOnCurrent = true;
    _tryAnchor(0);
  }

  void _tryAnchor(int attempt) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final rowContext = _currentRowKey.currentContext;
      final position = rowContext == null
          ? null
          : Scrollable.maybeOf(rowContext)?.position;
      if (position == null || !position.hasContentDimensions) {
        // Not ready yet. Frames are cheap and this stops within ~10 of them.
        if (attempt < 10) _tryAnchor(attempt + 1);
        return;
      }
      Scrollable.ensureVisible(rowContext!, alignment: 0.3);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _errorMessage = "";
      if (isSequels) {
        final mediaId = widget.track!.mediaId!.toString();
        final mal = await isar.trackPreferences
            .filter()
            .syncIdEqualTo(TrackerProviders.myAnimeList.syncId)
            .findFirst();
        final anilist = await isar.trackPreferences
            .filter()
            .syncIdEqualTo(TrackerProviders.anilist.syncId)
            .findFirst();
        // chiaki.site is sent `user=` and looks it up by handle, so AniList
        // has to pass its display name here. Its `username` is a numeric
        // viewer id, which the lookup silently answers nothing for.
        final data = await fetchSequels(mal?.username, anilist?.displayName);
        sequels = data
            .where((e) => e.reason.any((r) => r.id == mediaId))
            .toList();
      } else {
        // Auto-build: resolve the anime and show its chronological franchise
        // directly (no pick step); the opened title is marked "current".
        data = await fetchWatchOrderByName(widget.name);
      }
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(isSequels ? l10n.sequels : l10n.watch_order)),
      body: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: _isLoading
            ? const ProgressCenter()
            : Builder(
                builder: (context) {
                  if (_errorMessage.isNotEmpty) {
                    return ErrorState(
                      detail: _errorMessage,
                      onRetry: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = "";
                        });
                        _init();
                      },
                    );
                  }
                  return isSequels ? _buildSequels() : _buildWatchOrder();
                },
              ),
      ),
    );
  }

  Widget _buildSequels() {
    if (sequels != null && sequels!.isNotEmpty) {
      return SuperListView.builder(
        padding: tvPageInsets,
        extentPrecalculationPolicy: SuperPrecalculationPolicy(),
        itemCount: sequels!.length,
        itemBuilder: (context, index) {
          final sequel = sequels![index];
          return StreamBuilder(
            stream: isar.tracks
                .filter()
                .idIsNotNull()
                .mediaIdEqualTo(int.tryParse(sequel.id))
                .or()
                .mediaIdEqualTo(int.tryParse(sequel.anilistId ?? ""))
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
              return ListTile(
                onTap: () async {
                  context.push(
                    '/globalSearch',
                    extra: (sequel.title, ItemType.anime),
                  );
                },
                title: Row(
                  children: [
                    _thumbnailPreview(context, sequel.image, hasData: hasData),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(sequel.title, context),
                          Text(
                            "${sequel.period} | ${sequel.type} | ${sequel.episodes} episodes | ★${sequel.score} (${sequel.scoreUsers})",
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }
    return Center(child: Text(context.l10n.no_result));
  }

  Widget _buildWatchOrder() {
    if (data != null && data!.isNotEmpty) return _timeline(data!);
    if (dataSearch != null && dataSearch!.isNotEmpty) {
      return _searchList(dataSearch!);
    }
    return Center(child: Text(context.l10n.no_result));
  }

  // Chronological franchise as a rail: a vertical timeline on phones, and a
  // horizontal one on TV/desktop where a single stretched column would leave the
  // width empty. "Current" is the anchor (enlarged cover + accent ring + a filled
  // badge); position carries previous vs up next.
  Widget _timeline(List<WatchOrderItem> items) {
    // One layout on every form factor: a vertical rail. On a wide TV/desktop
    // window it centres at a comfortable width with side padding rather than
    // stretching a single column across the whole panel.
    _anchorOnCurrent();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        // Every row is built rather than lazily: a franchise timeline is
        // short, and the current entry needs a laid out context for
        // ensureVisible to reach it while it is still off screen.
        child: SingleChildScrollView(
          padding: tvPageInsets,
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++)
                Builder(
                  builder: (context) {
                    final item = items[index];
                    final isLast = index == items.length - 1;
                    final isCurrent = item.role == WatchOrderRole.current;
                    // The focus tint belongs to the entry, not to the rail.
                    // The connector stub is drawn after the ink surface rather
                    // than inside it, so the highlight stops at the entry, the
                    // gap between rows stays readable, and the tint does not
                    // paint a block over the connector.
                    return Column(
                      children: [
                        Material(
                          // The anchor the timeline opens on, and on TV the row
                          // the remote lands on. Row 0 would make a mid
                          // franchise position look like the beginning.
                          key: isCurrent ? _currentRowKey : null,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            autofocus: isTv && isCurrent,
                            borderRadius: BorderRadius.circular(12),
                            focusColor: context.primaryColor.withValues(
                              alpha: _alphaFocus,
                            ),
                            onTap: () => _openWatchOrder(item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 132,
                                    // Centre it, or the rail's width is a
                                    // tight constraint and the cover is
                                    // stretched to 132 no matter what width it
                                    // asks for. That is what made every cover
                                    // near square and made width changes look
                                    // like they did nothing.
                                    child: Center(
                                      child: _cover(
                                        context,
                                        item.image,
                                        isCurrent: isCurrent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: _timelineBody(context, item),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Outside the ink surface, aligned under the cover by
                        // reusing the same padding and rail width.
                        if (!isLast)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 132,
                                  child: Center(
                                    child: Container(
                                      width: 2,
                                      height: 22,
                                      color: context.textColor.withValues(
                                        alpha: _alphaHairline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineBody(BuildContext context, WatchOrderItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        if (item.nameEnglish != null &&
            item.nameEnglish!.isNotEmpty &&
            item.nameEnglish != item.name)
          Text(
            item.nameEnglish!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: context.textColor.withValues(alpha: _alphaSecondary),
            ),
          ),
        if (item.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: context.textColor.withValues(alpha: _alphaSecondary),
              ),
            ),
          ),
        const SizedBox(height: 7),
        _roleBadge(context, item.role),
      ],
    );
  }

  Widget _cover(
    BuildContext context,
    String? imageUrl, {
    required bool isCurrent,
  }) {
    // Every cover keeps the same aspect, so none of them crops differently
    // from the rest. The two sizes used to be 120x174 and 100x146, which are
    // not quite the same ratio.
    //
    // The current entry is only a little larger. The accent ring already marks
    // it, so the size difference just has to be felt; at the previous 20% it
    // read as a jump in the rail.
    final width = isCurrent ? 110.0 : 100.0;
    final height = width * _coverAspect;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: isCurrent
            ? Border.all(color: context.primaryColor, width: 3)
            : null,
        image: DecorationImage(
          image: CustomExtendedNetworkImageProvider(toImgUrl(imageUrl ?? "")),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _openWatchOrder(WatchOrderItem item) {
    context.push(
      '/globalSearch',
      extra: (item.nameEnglish ?? item.name, ItemType.anime),
    );
  }

  Widget _searchList(List<WatchOrderSearch> results) {
    return SuperListView.builder(
      padding: tvPageInsets,
      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final search = results[index];
        return ListTile(
          onTap: () async {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _errorMessage = "";
              });
              data = await fetchWatchOrder(search.id);
              setState(() {
                _isLoading = false;
              });
            }
          },
          title: Row(
            children: [
              _thumbnailPreview(context, search.image),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(search.name, context),
                    Text(
                      "${search.type} - ${search.year}",
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roleBadge(BuildContext context, WatchOrderRole role) {
    final accent = context.primaryColor;
    switch (role) {
      case WatchOrderRole.current:
        // Filled accent + a label colour computed for contrast against the
        // accent (not the theme): legible on any accent hue and in either theme.
        // The old grey / blue-grey tags washed out on dark with a light accent.
        final onAccent = accent.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Currently watching",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: onAccent,
            ),
          ),
        );
      case WatchOrderRole.next:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: _alphaAccentTint),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Up next",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        );
      case WatchOrderRole.previous:
        final neutral = context.textColor;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: neutral.withValues(alpha: _alphaTint),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Previous",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: neutral.withValues(alpha: _alphaSecondary),
            ),
          ),
        );
    }
  }

  Widget _buildTitle(String text, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make sure that (constraints.maxWidth - (35 + 5)) is strictly positive.
        final double availableWidth = constraints.maxWidth - (35 + 5);
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: const TextStyle(fontSize: 13)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: availableWidth > 0 ? availableWidth : 1.0); // - Download icon size (download_page_widget.dart, Widget Build SizedBox width: 35)

        final isOverflowing = textPainter.didExceedMaxLines;

        if (isOverflowing) {
          return SizedBox(
            height: 20,
            child: Marquee(
              text: text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
            ),
          );
        } else {
          return Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }

  Widget _thumbnailPreview(
    BuildContext context,
    String? imageUrl, {
    bool hasData = false,
  }) {
    final imageProvider = CustomExtendedNetworkImageProvider(
      toImgUrl(imageUrl ?? ""),
    );
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          _openImage(context, imageProvider);
        },
        child: Stack(
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 150,
              color: hasData ? Colors.black.withValues(alpha: 0.7) : null,
            ),
            if (hasData)
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
        ),
      ),
    );
  }

  void _openImage(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: PhotoViewGallery.builder(
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  itemCount: 1,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: imageProvider,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: 2.0,
                    );
                  },
                  loadingBuilder: (context, event) {
                    return const ProgressCenter();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SuperPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) {
    return context.numberOfItems < 100;
  }
}
