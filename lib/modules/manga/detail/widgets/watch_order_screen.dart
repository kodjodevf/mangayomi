import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_watch_order.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class WatchOrderScreen extends StatefulWidget {
  final String name;

  const WatchOrderScreen({super.key, required this.name});

  @override
  State<WatchOrderScreen> createState() => _WatchOrderScreenState();
}

class _WatchOrderScreenState extends State<WatchOrderScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<WatchOrderSearch>? dataSearch;
  List<WatchOrderItem>? data;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _errorMessage = "";
      dataSearch = await searchWatchOrder(widget.name);
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
      appBar: AppBar(title: Text(l10n.watch_order)),
      body: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Builder(
                builder: (context) {
                  if (_errorMessage.isNotEmpty) {
                    return Center(child: Text(_errorMessage));
                  }
                  final isSearch = dataSearch != null && dataSearch!.isNotEmpty;
                  final isWatchOrder = data != null && data!.isNotEmpty;
                  if (isSearch || isWatchOrder) {
                    return SuperListView.builder(
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      itemCount: data?.length ?? dataSearch!.length,
                      itemBuilder: (context, index) {
                        final search = !isWatchOrder && isSearch
                            ? dataSearch![index]
                            : null;
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
                              _thumbnailPreview(
                                context,
                                watchOrder?.image ?? search!.image,
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTitle(
                                      watchOrder?.name ?? search!.name,
                                      context,
                                    ),
                                    if (watchOrder?.nameEnglish != null &&
                                        watchOrder?.nameEnglish !=
                                            watchOrder?.text)
                                      Text(
                                        watchOrder!.nameEnglish!,
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.clip,
                                      ),
                                    Text(
                                      watchOrder?.text ??
                                          "${search!.type} - ${search.year}",
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
                  return Center(child: Text(l10n.no_result));
                },
              ),
      ),
    );
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

  Widget _thumbnailPreview(BuildContext context, String? imageUrl) {
    final imageProvider = CustomExtendedNetworkImageProvider(
      toImgUrl(imageUrl ?? ""),
    );
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          _openImage(context, imageProvider);
        },
        child: SizedBox(
          width: 100,
          height: 150,
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
