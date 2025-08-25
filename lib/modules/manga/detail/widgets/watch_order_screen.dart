import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_watch_order.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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
        final data = await fetchSequels(mal?.username, anilist?.username);
        sequels = data
            .where((e) => e.reason.any((r) => r.id == mediaId))
            .toList();
      } else {
        dataSearch = await searchWatchOrder(widget.name);
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
            ? const Center(child: CircularProgressIndicator())
            : Builder(
                builder: (context) {
                  if (_errorMessage.isNotEmpty) {
                    return Center(child: Text(_errorMessage));
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
    final isSearch = dataSearch != null && dataSearch!.isNotEmpty;
    final isWatchOrder = data != null && data!.isNotEmpty;
    if (isSearch || isWatchOrder) {
      return SuperListView.builder(
        extentPrecalculationPolicy: SuperPrecalculationPolicy(),
        itemCount: data?.length ?? dataSearch!.length,
        itemBuilder: (context, index) {
          final search = !isWatchOrder && isSearch ? dataSearch![index] : null;
          final watchOrder = isWatchOrder ? data![index] : null;
          return ListTile(
            onTap: () async {
              if (isWatchOrder) {
                context.push(
                  '/globalSearch',
                  extra: (
                    watchOrder!.nameEnglish ?? watchOrder.name,
                    ItemType.anime,
                  ),
                );
              } else {
                if (mounted) {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = "";
                  });
                  data = await fetchWatchOrder(search!.id);
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            title: Row(
              children: [
                _thumbnailPreview(context, watchOrder?.image ?? search!.image),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(watchOrder?.name ?? search!.name, context),
                      if (watchOrder?.nameEnglish != null &&
                          watchOrder?.nameEnglish != watchOrder?.text)
                        Text(
                          watchOrder!.nameEnglish!,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.clip,
                        ),
                      Text(
                        watchOrder?.text ?? "${search!.type} - ${search.year}",
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
    return Center(child: Text(context.l10n.no_result));
  }

  Widget _buildTitle(String text, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make sure that (constraints.maxWidth - (35 + 5)) is strictly positive.
        final double availableWidth = constraints.maxWidth - (35 + 5);
        final textPainter =
            TextPainter(
              text: TextSpan(text: text, style: const TextStyle(fontSize: 13)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout(
              maxWidth: availableWidth > 0 ? availableWidth : 1.0,
            ); // - Download icon size (download_page_widget.dart, Widget Build SizedBox width: 35)

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
