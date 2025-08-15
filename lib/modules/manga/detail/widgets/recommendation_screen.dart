import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/recommendation.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class RecommendationScreen extends StatefulWidget {
  final String name;
  final ItemType itemType;
  final AlgorithmWeights algorithmWeights;

  const RecommendationScreen({
    super.key,
    required this.name,
    required this.itemType,
    required this.algorithmWeights,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<RecommendationResult>? data;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _errorMessage = "";
      data = await getRecommendations(
        widget.name,
        widget.itemType,
        widget.algorithmWeights,
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recommendations)),
      body: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Builder(
                builder: (context) {
                  if (_errorMessage.isNotEmpty) {
                    return Center(child: Text(_errorMessage));
                  }
                  if (data != null && data!.isNotEmpty) {
                    return SuperListView.builder(
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        final recommendation = data![index];
                        return ListTile(
                          onTap: () => context.push(
                            '/globalSearch',
                            extra: (
                              recommendation.titleEnglish ??
                                  recommendation.titleRomaji ??
                                  recommendation.titleNative,
                              widget.itemType,
                            ),
                          ),
                          title: Row(
                            children: [
                              if (recommendation.imgURLs.isNotEmpty)
                                _thumbnailPreview(
                                  context,
                                  recommendation.imgURLs.first,
                                ),
                              const SizedBox(width: 15),
                              recommendation.description != null
                                  ? Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildTitle(
                                            recommendation.titleEnglish ??
                                                recommendation.titleRomaji ??
                                                recommendation.titleNative ??
                                                "",
                                            context,
                                          ),
                                          Text(
                                            recommendation.description!,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Flexible(
                                      child: _buildTitle(
                                        recommendation.titleEnglish ??
                                            recommendation.titleRomaji ??
                                            recommendation.titleNative ??
                                            "",
                                        context,
                                      ),
                                    ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: recommendation.genres.isEmpty
                                      ? const SizedBox(height: 15)
                                      : context.isTablet
                                      ? Wrap(
                                          children: [
                                            for (
                                              var i = 0;
                                              i < recommendation.genres.length;
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
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: null,
                                                    child: Text(
                                                      recommendation.genres[i],
                                                      style: TextStyle(
                                                        fontSize: 11.5,
                                                        color: context.isLight
                                                            ? Colors.black
                                                            : Colors.white,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              for (
                                                var i = 0;
                                                i <
                                                    recommendation
                                                        .genres
                                                        .length;
                                                i++
                                              )
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 2,
                                                        right: 2,
                                                        bottom: 5,
                                                      ),
                                                  child: SizedBox(
                                                    height: 30,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        recommendation
                                                            .genres[i],
                                                        style: TextStyle(
                                                          fontSize: 11.5,
                                                          color: context.isLight
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "${recommendation.score}% ${l10n.recommendations_similar}",
                                  style: TextStyle(
                                    background: Paint()
                                      ..color = Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withValues(alpha: 0.75)
                                      ..strokeWidth = 30.0
                                      ..strokeJoin = StrokeJoin.round
                                      ..style = PaintingStyle.stroke,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
