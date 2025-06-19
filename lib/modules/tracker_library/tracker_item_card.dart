import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class TrackerItemCard extends StatelessWidget {
  final TrackSearch track;
  final ItemType itemType;

  const TrackerItemCard({
    super.key,
    required this.track,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _cardContent(context),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            return Positioned(
              top: 0,
              child: Stack(
                children: [
                  cachedNetworkImage(
                    imageUrl: toImgUrl(track.coverUrl ?? ""),
                    width: context.width(1),
                    height: context.height(1),
                    fit: BoxFit.cover,
                  ),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: context.width(1),
                            height: AppBar().preferredSize.height,
                            color: Theme.of(
                              context,
                            ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                          ),
                          Container(
                            width: context.width(1),
                            height: context.height(1),
                            color: Theme.of(
                              context,
                            ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: AppBar(
              title: Text(track.title ?? ""),
              backgroundColor: Colors.transparent,
            ),
          ),
          body: SafeArea(
            child: Row(
              children: [
                SizedBox(
                  width: context.width(0.8),
                  height: context.height(1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: context.width(0.8),
                              child: Row(
                                children: [
                                  _coverCard(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SelectableText(
                                          track.summary ?? "",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            width: context.width(0.6),
                            child: context.isTablet
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: _infoRow(context),
                                  )
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    spacing: 5,
                                    children: _infoRow(context),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _infoRow(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return [
      Text.rich(
        TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.star, color: context.primaryColor)),
            TextSpan(text: " ${track.score ?? "?"}"),
          ],
        ),
      ),
      Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                itemType == ItemType.anime
                    ? Icons.video_library
                    : Icons.local_library,
                color: context.primaryColor,
              ),
            ),
            TextSpan(text: " ${track.totalChapter ?? "?"}"),
          ],
        ),
      ),
      TextButton.icon(
        onPressed: () async => await InAppBrowser.openWithSystemBrowser(
          url: WebUri(track.trackingUrl!),
        ),
        label: Text(l10n.open_in_browser),
        icon: Icon(Icons.public),
      ),
      TextButton.icon(
        onPressed: () => _pushMigrationScreen(context),
        label: Text(l10n.track_library_add),
        icon: Icon(Icons.add),
      ),
    ];
  }

  Widget _coverCard() {
    final imageProvider = CustomExtendedNetworkImageProvider(
      toImgUrl(track.coverUrl ?? ""),
    );
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 140,
        height: 220,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  void _pushMigrationScreen(BuildContext context) {
    context.push(
      "/migrate/tracker",
      extra: (
        Manga(
          name: track.title,
          itemType: itemType,
          source: null,
          author: "",
          artist: null,
          genre: [],
          imageUrl: null,
          lang: null,
          link: null,
          status: Status.unknown,
          description: null,
        ),
        track,
      ),
    );
  }
}
