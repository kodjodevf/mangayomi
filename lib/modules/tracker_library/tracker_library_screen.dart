// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

enum TrackerProviders {
  myAnimeList(syncId: 1, name: "MAL"),
  anilist(syncId: 2, name: "AL"),
  kitsu(syncId: 3, name: "Kitsu"),
  trakt(syncId: 4, name: "Trakt");

  const TrackerProviders({required this.syncId, required this.name});

  final int syncId;
  final String name;
}

class TrackLibrarySection {
  String name;
  Future<List<TrackSearch>?> Function() func;
  ItemType itemType;

  TrackLibrarySection({
    required this.name,
    required this.func,
    this.itemType = ItemType.manga,
  });
}

class TrackerLibraryScreen extends ConsumerStatefulWidget {
  final TrackerProviders trackerProvider;
  final String? presetInput;
  const TrackerLibraryScreen({
    required this.trackerProvider,
    required this.presetInput,
    super.key,
  });

  @override
  ConsumerState<TrackerLibraryScreen> createState() =>
      _TrackerLibraryScreenState();
}

class _TrackerLibraryScreenState extends ConsumerState<TrackerLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final sections = [
      TrackLibrarySection(
        name: "Airing Anime",
        func: fetchGeneralData(ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: "Popular Anime",
        func: fetchGeneralData(ItemType.anime, rankingType: "bypopularity"),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: "Upcoming Anime",
        func: fetchGeneralData(ItemType.anime, rankingType: "upcoming"),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: "Continue watching",
        func: fetchUserData(ItemType.anime),
        itemType: ItemType.anime,
      ),
      TrackLibrarySection(
        name: "Popular Manga",
        func: fetchGeneralData(ItemType.manga, rankingType: "bypopularity"),
      ),
      TrackLibrarySection(
        name: "Top Manga",
        func: fetchGeneralData(ItemType.manga, rankingType: "manga"),
      ),
      TrackLibrarySection(
        name: "Top Manhwa",
        func: fetchGeneralData(ItemType.manga, rankingType: "manhwa"),
      ),
      TrackLibrarySection(
        name: "Top Manhua	",
        func: fetchGeneralData(ItemType.manga, rankingType: "manhua"),
      ),
      TrackLibrarySection(
        name: "Continue reading",
        func: fetchUserData(ItemType.manga),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.trackerProvider.name)),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SuperListView.builder(
          itemCount: sections.length,
          extentPrecalculationPolicy: SuperPrecalculationPolicy(),
          itemBuilder: (context, index) {
            final section = sections[index];
            return SizedBox(
              height: 260,
              child: TrackerSectionScreen(section: section),
            );
          },
        ),
      ),
    );
  }

  Future<List<TrackSearch>?> Function() fetchGeneralData(
    ItemType itemType, {
    String rankingType = "airing",
  }) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(
              syncId: widget.trackerProvider.syncId,
              status: TrackStatus.completed,
            ),
            itemType: itemType,
          ).notifier,
        )
        .fetchGeneralData(rankingType: rankingType);
  }

  Future<List<TrackSearch>?> Function() fetchUserData(ItemType itemType) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(
              syncId: widget.trackerProvider.syncId,
              status: TrackStatus.completed,
            ),
            itemType: itemType,
          ).notifier,
        )
        .fetchUserData();
  }
}

class TrackerSectionScreen extends StatefulWidget {
  final TrackLibrarySection section;

  const TrackerSectionScreen({super.key, required this.section});

  @override
  State<TrackerSectionScreen> createState() => _TrackerSectionScreenState();
}

class _TrackerSectionScreenState extends State<TrackerSectionScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  String _errorMessage = "";
  bool _isLoading = true;
  List<TrackSearch> tracks = [];
  _init() async {
    try {
      _errorMessage = "";
      tracks = await widget.section.func() ?? [];
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

    return Scaffold(
      body: SizedBox(
        height: 260,
        child: Column(
          children: [
            ListTile(dense: true, title: Text(widget.section.name)),
            Flexible(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        if (_errorMessage.isNotEmpty) {
                          return Center(child: Text(_errorMessage));
                        }
                        if (tracks.isNotEmpty) {
                          return SuperListView.builder(
                            extentPrecalculationPolicy:
                                SuperPrecalculationPolicy(),
                            scrollDirection: Axis.horizontal,
                            itemCount: tracks.length,
                            itemBuilder: (context, index) {
                              return TrackerLibraryImageCard(
                                track: tracks[index],
                                itemType: widget.section.itemType,
                              );
                            },
                          );
                        }
                        return Center(child: Text(l10n.no_result));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackerLibraryImageCard extends ConsumerStatefulWidget {
  final TrackSearch track;
  final ItemType itemType;

  const TrackerLibraryImageCard({
    super.key,
    required this.track,
    required this.itemType,
  });

  @override
  ConsumerState<TrackerLibraryImageCard> createState() =>
      _TrackerLibraryImageCardState();
}

class _TrackerLibraryImageCardState
    extends ConsumerState<TrackerLibraryImageCard>
    with AutomaticKeepAliveClientMixin<TrackerLibraryImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trackData = widget.track;
    return GestureDetector(
      onTap: () => _pushMigrationScreen(context),
      child: StreamBuilder(
        stream: isar.mangas
            .filter()
            .itemTypeEqualTo(widget.itemType)
            .nameEqualTo(trackData.title)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Stack(
              children: [
                SizedBox(
                  width: 110,
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (hasData &&
                              snapshot.data!.first.customCoverImage != null) {
                            return Image.memory(
                              snapshot.data!.first.customCoverImage
                                  as Uint8List,
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: cachedNetworkImage(
                              imageUrl: toImgUrl(
                                hasData
                                    ? snapshot
                                              .data!
                                              .first
                                              .customCoverFromTracker ??
                                          snapshot.data!.first.imageUrl ??
                                          ""
                                    : trackData.coverUrl ?? "",
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
                        text: trackData.title!,
                        isLoading: true,
                        textColor: Theme.of(context).textTheme.bodyLarge!.color,
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.star, color: context.primaryColor),
                        ),
                        TextSpan(text: " ${trackData.score ?? "?"}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _pushMigrationScreen(BuildContext context) {
    context.push(
      "/migrate",
      extra: Manga(
        name: widget.track.title,
        itemType: widget.itemType,
        source: null,
        author: null,
        artist: null,
        genre: [],
        imageUrl: null,
        lang: null,
        link: null,
        status: Status.unknown,
        description: null,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SuperPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) {
    return context.numberOfItems < 100;
  }
}
