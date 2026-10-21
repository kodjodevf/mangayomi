import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/in_library_badge.dart';
import 'package:shiori/shiori.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/discovery/media_catalog_resolver.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/western_watch_order.dart';
import 'package:mangayomi/services/fetch_watch_order.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Cover height over width, taken from the artwork itself: AniList serves
/// these at 230x320. Matching it means BoxFit.cover has nothing to crop, so
/// every cover shows its original framing rather than a trimmed version of it.
///
/// One value for the whole rail, so the current entry differs from the rest in
/// size only, never in shape.
const double _coverAspect = 320 / 230;

class WatchOrderScreen extends StatefulWidget {
  final MediaLookupContext media;
  final Track? track;

  const WatchOrderScreen({super.key, required this.media, required this.track});

  @override
  State<WatchOrderScreen> createState() => _WatchOrderScreenState();
}

class _WatchOrderScreenState extends State<WatchOrderScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<SequelItem>? sequels;
  WatchOrderPlan? plan;
  final WesternWatchOrderPlanner _westernPlanner = WesternWatchOrderPlanner();
  final MediaCatalogResolver _catalogResolver = MediaCatalogResolver();
  String? _requestedSourceKey;

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
      _didAnchorOnCurrent = false;
      if (isSequels) {
        final mediaId = widget.track?.mediaId;
        if (mediaId == null || mediaId <= 0) {
          sequels = const [];
        } else {
          final mal = await trackRepository.findPreferenceBySyncIdAsync(
            TrackerProviders.myAnimeList.syncId,
          );
          final anilist = await trackRepository.findPreferenceBySyncIdAsync(
            TrackerProviders.anilist.syncId,
          );
          // chiaki.site is sent `user=` and looks it up by handle, so AniList
          // has to pass its display name here. Its `username` is a numeric
          // viewer id, which the lookup silently answers nothing for.
          final data = await fetchSequels(mal?.username, anilist?.displayName);
          sequels = data
              .where((e) => e.reason.any((r) => r.id == mediaId.toString()))
              .toList();
        }
      } else {
        plan = await _fetchPlan(selectedSourceKey: _requestedSourceKey);
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
        padding: const EdgeInsets.all(ShioriSpace.s4),
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
                          _didAnchorOnCurrent = false;
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
        padding: tvPageInsets.add(pageBottomInsets(context)),
        extentPrecalculationPolicy: SuperPrecalculationPolicy(),
        itemCount: sequels!.length,
        itemBuilder: (context, index) {
          final sequel = sequels![index];
          return StreamBuilder(
            stream: trackRepository.watchByEitherMediaId(
              int.tryParse(sequel.id),
              int.tryParse(sequel.anilistId ?? ""),
            ),
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
                    const SizedBox(width: ShioriSpace.s16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(sequel.title, context),
                          Text(
                            "${sequel.period} · ${sequel.type} · ${sequel.episodes} ${context.l10n.episodes} · ★${sequel.score} (${sequel.scoreUsers})",
                            style: context.shiori.caption,
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
    return ShioriEmptyState(
      icon: Symbols.format_list_numbered_rounded,
      title: context.l10n.no_result,
      compact: true,
    );
  }

  Widget _buildWatchOrder() {
    final value = plan;
    if (value != null && value.items.isNotEmpty) {
      return Column(
        children: [
          _sourceSelector(value),
          Expanded(child: _timeline(value.items)),
        ],
      );
    }
    return ShioriEmptyState(
      icon: Symbols.format_list_numbered_rounded,
      title: context.l10n.no_result,
      compact: true,
    );
  }

  Future<WatchOrderPlan?> _fetchPlan({String? selectedSourceKey}) {
    return fetchWatchOrderForMedia(
      widget.media,
      selectedSourceKey: selectedSourceKey,
      planner: _westernPlanner,
      catalogResolver: _catalogResolver,
    );
  }

  Future<void> _selectSource(String key) async {
    if (key == plan?.selectedOptionKey) return;
    _requestedSourceKey = key;
    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _didAnchorOnCurrent = false;
    });
    try {
      final next = await _fetchPlan(selectedSourceKey: key);
      if (!mounted) return;
      setState(() {
        plan = next;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Widget _sourceSelector(WatchOrderPlan value) {
    final label = _sourceLabel(value.source);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            ShioriSpace.s16,
            ShioriSpace.s8,
            ShioriSpace.s16,
            ShioriSpace.s4,
          ),
          child: value.options.length < 2
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(label, style: context.shiori.caption),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.shiori.caption),
                    const SizedBox(height: ShioriSpace.s8),
                    DropdownButtonFormField<String>(
                      initialValue: value.selectedOptionKey,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: context.l10n.watch_order_select_source,
                        isDense: true,
                      ),
                      items: [
                        for (final option in value.options)
                          DropdownMenuItem(
                            value: option.key,
                            child: Text(
                              _optionLabel(option),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (key) {
                        if (key != null) _selectSource(key);
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _sourceLabel(WatchOrderSource source) {
    final l10n = context.l10n;
    return switch (source.kind) {
      WatchOrderSourceKind.animeReleaseOrder =>
        '${l10n.watch_order_source_release_order} · ${source.service}',
      WatchOrderSourceKind.traktOfficialList =>
        l10n.watch_order_source_official_collection(
          source.name ?? source.service,
        ),
      WatchOrderSourceKind.traktCommunityList when source.author != null =>
        l10n.watch_order_source_community_list(
          source.name ?? source.service,
          source.author!,
        ),
      WatchOrderSourceKind.traktCommunityList =>
        l10n.watch_order_source_trakt_collection(source.name ?? source.service),
      WatchOrderSourceKind.traktSeasons => l10n.watch_order_source_seasons(
        widget.media.title,
      ),
    };
  }

  String _optionLabel(WatchOrderOption option) {
    final l10n = context.l10n;
    if (option.isOfficial) {
      return l10n.watch_order_source_official_collection(option.name);
    }
    final author = option.author;
    return author == null
        ? l10n.watch_order_source_trakt_collection(option.name)
        : l10n.watch_order_source_community_list(option.name, author);
  }

  // A vertical franchise rail on every form factor. Movies, shows and anime
  // remain poster rows. Seasons and episodes are compact children so a long
  // show does not become a wall of repeated artwork.
  Widget _timeline(List<WatchOrderItem> items) {
    if (items.any((item) => item.role == WatchOrderRole.current)) {
      _anchorOnCurrent();
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: SingleChildScrollView(
          padding: tvPageInsets.add(pageBottomInsets(context)),
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++)
                if (items[index].depth == 0)
                  _topLevelRow(items, index)
                else
                  _childRow(items[index]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topLevelRow(List<WatchOrderItem> items, int index) {
    final item = items[index];
    final isCurrent = item.role == WatchOrderRole.current;
    final hasLaterTitle = items
        .skip(index + 1)
        .any((candidate) => candidate.depth == 0);
    return Column(
      children: [
        Material(
          key: isCurrent ? _currentRowKey : ValueKey(item.key),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ShioriShape.card),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            autofocus: isTv && isCurrent,
            borderRadius: BorderRadius.circular(ShioriShape.card),
            focusColor: context.shiori.color.accent.withValues(
              alpha: Alphas.focus,
            ),
            onTap: item.searchTarget == null
                ? null
                : () => _openWatchOrder(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s8,
                vertical: ShioriSpace.s4,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 132,
                    child: Center(
                      child: _cover(context, item.image, isCurrent: isCurrent),
                    ),
                  ),
                  const SizedBox(width: ShioriSpace.s12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: ShioriSpace.s8),
                      child: _timelineBody(context, item),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasLaterTitle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
            child: Row(
              children: [
                SizedBox(
                  width: 132,
                  child: Center(
                    child: Container(
                      width: 2,
                      height: 18,
                      color: context.shiori.color.hairline,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _childRow(WatchOrderItem item) {
    final depth = item.depth.clamp(1, 2);
    final metadata = _metadata(item);
    return Padding(
      key: ValueKey(item.key),
      padding: EdgeInsetsDirectional.fromSTEB(depth == 1 ? 52 : 76, 2, 8, 2),
      child: Material(
        color: context.shiori.color.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(ShioriShape.card),
          focusColor: context.shiori.color.accent.withValues(
            alpha: Alphas.focus,
          ),
          onTap: item.searchTarget == null ? null : () => _openWatchOrder(item),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              ShioriSpace.s12,
              ShioriSpace.s8,
              ShioriSpace.s12,
              ShioriSpace.s8,
            ),
            child: Row(
              children: [
                Icon(
                  item.kind == WatchOrderItemKind.episode
                      ? Symbols.play_circle_rounded
                      : Symbols.calendar_view_month_rounded,
                  size: 20,
                  color: context.shiori.color.accentInk,
                ),
                const SizedBox(width: ShioriSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.shiori.text.row.copyWith(
                          color: context.shiori.color.fg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (metadata.isNotEmpty)
                        Text(
                          metadata,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.shiori.caption,
                        ),
                    ],
                  ),
                ),
                Icon(
                  Symbols.chevron_forward_rounded,
                  size: 18,
                  color: context.shiori.color.fgMuted,
                ),
              ],
            ),
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
          style: context.shiori.text.row.copyWith(
            color: context.shiori.color.fg,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (item.nameEnglish != null &&
            item.nameEnglish!.isNotEmpty &&
            item.nameEnglish != item.name)
          Text(
            item.nameEnglish!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.shiori.caption,
          ),
        if (_metadata(item).isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              _metadata(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.shiori.caption,
            ),
          ),
        if (item.role != WatchOrderRole.neutral) ...[
          const SizedBox(height: ShioriSpace.s8),
          _roleBadge(context, item.role),
        ],
      ],
    );
  }

  String _metadata(WatchOrderItem item) {
    final parts = <String>[];
    if (item.format case String format when format.isNotEmpty) {
      parts.add(format);
    }
    if (item.seasonNumber case int season) {
      parts.add(context.l10n.watch_order_season(season));
    }
    if (item.episodeNumber case int episode) {
      parts.add(context.l10n.watch_order_episode(episode));
    }
    if (item.episodeCount case int count) {
      parts.add('$count ${context.l10n.episodes}');
    }
    if (item.year case int year) parts.add('$year');
    return parts.join(' · ');
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
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        border: isCurrent
            ? Border.all(color: context.shiori.color.accentInk, width: 3)
            : null,
        image: DecorationImage(
          image: CustomExtendedNetworkImageProvider(toImgUrl(imageUrl ?? "")),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _openWatchOrder(WatchOrderItem item) {
    final target = item.searchTarget;
    if (target == null) return;
    context.push('/globalSearch', extra: (target.query, target.itemType));
  }

  /// Where an entry stands against the one being watched: the current one
  /// filled in the accent, the next tinted with it, the earlier ones quiet.
  Widget _roleBadge(BuildContext context, WatchOrderRole role) {
    final c = context.shiori.color;
    final l10n = context.l10n;
    final (String label, Color background, Color foreground) = switch (role) {
      WatchOrderRole.current => (
        l10n.watch_order_role_current,
        c.accentInk,
        ShioriColors.onFill(c.accentInk),
      ),
      WatchOrderRole.next => (
        l10n.watch_order_role_next,
        c.accent.withValues(alpha: Alphas.accentTint),
        c.accentInk,
      ),
      WatchOrderRole.previous => (
        l10n.watch_order_role_previous,
        c.ink2,
        c.fgMuted,
      ),
      WatchOrderRole.neutral => ('', Colors.transparent, c.fg),
    };
    if (role == WatchOrderRole.neutral) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(ShioriShape.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s8,
          vertical: ShioriSpace.s4,
        ),
        child: Text(
          label,
          style: context.shiori.text.badge.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make sure that (constraints.maxWidth - (35 + 5)) is strictly positive.
        final double availableWidth = constraints.maxWidth - (35 + 5);
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: context.shiori.text.row),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: availableWidth > 0 ? availableWidth : 1.0); // - Download icon size (download_page_widget.dart, Widget Build SizedBox width: 35)

        final isOverflowing = textPainter.didExceedMaxLines;

        if (isOverflowing) {
          return SizedBox(
            height: 20,
            child: Marquee(
              text: text,
              style: context.shiori.text.row.copyWith(
                color: context.shiori.color.fg,
                fontWeight: FontWeight.w700,
              ),
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
            ),
          );
        } else {
          return Text(
            text,
            style: context.shiori.text.row.copyWith(
              color: context.shiori.color.fg,
              fontWeight: FontWeight.w700,
            ),
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
      padding: const EdgeInsets.all(ShioriSpace.s4),
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(ShioriShape.cover),
                  ),
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
              color: hasData ? inLibraryVeil : null,
            ),
            if (hasData)
              const PositionedDirectional(
                top: ShioriSpace.s4,
                start: ShioriSpace.s4,
                child: InLibraryBadge(),
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
