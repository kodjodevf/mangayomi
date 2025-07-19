// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/modules/tracker_library/tracker_section_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
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

class TrackerLibraryScreen extends ConsumerStatefulWidget {
  final String? presetInput;
  const TrackerLibraryScreen({required this.presetInput, super.key});

  @override
  ConsumerState<TrackerLibraryScreen> createState() =>
      _TrackerLibraryScreenState();
}

class _TrackerLibraryScreenState extends ConsumerState<TrackerLibraryScreen> {
  late final _textEditingController = TextEditingController();
  late String _query = "";
  late bool _isSearch = false;
  List<TrackLibrarySection> _sections = [];
  List<TrackPreference> _preferences = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final lastLocation = ref.watch(lastTrackerLibraryLocationStateProvider);
    final trackerProvider =
        TrackerProviders.values.firstWhereOrNull(
          (t) => t.syncId == lastLocation.$1,
        ) ??
        TrackerProviders.myAnimeList;
    final itemType = lastLocation.$2 ? ItemType.manga : ItemType.anime;
    _sections = switch (trackerProvider.syncId) {
      1 => _sectionsMAL(trackerProvider.syncId, itemType),
      2 => _sectionsAL(trackerProvider.syncId, itemType),
      3 => _sectionsKitsu(trackerProvider.syncId, itemType),
      _ => [],
    };
    if (_isSearch && _query.isNotEmpty) {
      _sections.insert(
        0,
        TrackLibrarySection(
          name: "Search results",
          syncId: trackerProvider.syncId,
          func: _fetchSearch(trackerProvider.syncId, _query, itemType),
          itemType: itemType,
          isSearch: true,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${trackerProvider.name} | ${itemType == ItemType.anime ? l10n.anime : l10n.manga}",
        ),
        leading: !_isSearch ? null : Container(),
        actions: [
          _isSearch
              ? SeachFormTextField(
                  onFieldSubmitted: (submit) {
                    setState(() {
                      if (submit.isNotEmpty) {
                        _query = submit;
                      }
                    });
                  },
                  onChanged: (value) {},
                  onSuffixPressed: () {
                    _query = "";
                    _textEditingController.clear();
                    setState(() {});
                  },
                  onPressed: () {
                    setState(() {
                      _isSearch = false;
                      _query = "";
                      _textEditingController.clear();
                    });
                  },
                  controller: _textEditingController,
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                  },
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
          IconButton(
            splashRadius: 20,
            onPressed: () async => await _resetData(trackerProvider, itemType),
            icon: Icon(
              Icons.refresh_outlined,
              color: Theme.of(context).hintColor,
            ),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              _openSwitchProviderDialog(l10n);
            },
            icon: CircleAvatar(
              radius: 14,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: trackInfos(trackerProvider.syncId).$3,
                ),
                width: 60,
                height: 70,
                child: Image.asset(
                  trackInfos(trackerProvider.syncId).$1,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: StreamBuilder(
          stream: isar.trackPreferences.filter().syncIdIsNotNull().watch(
            fireImmediately: true,
          ),
          builder: (context, snapshot) {
            _preferences = snapshot.hasData ? snapshot.data ?? [] : [];
            return _preferences.any((p) => p.syncId == trackerProvider.syncId)
                ? RefreshIndicator(
                    onRefresh: () async {
                      await _resetData(trackerProvider, itemType);
                    },
                    child: SuperListView.builder(
                      itemCount: _sections.length,
                      extentPrecalculationPolicy: SuperPrecalculationPolicy(),
                      itemBuilder: (context, index) {
                        final section = _sections[index];
                        return SizedBox(
                          height: 260,
                          child: TrackerSectionScreen(
                            key: ValueKey(section.name),
                            section: section,
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(l10n.track_library_not_logged)],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Future<void> _resetData(
    TrackerProviders trackerProvider,
    ItemType itemType,
  ) async {
    final box = await Hive.openBox("tracker_library");
    final keys = box.keys.where(
      (e) => (e as String).startsWith(
        "${trackerProvider.syncId}-${itemType.name}-",
      ),
    );
    await box.deleteAll(keys);
    setState(() {});
  }

  List<TrackLibrarySection> _sectionsMAL(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: "Continue watching",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Airing Anime",
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Popular Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "bypopularity",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Upcoming Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "upcoming",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: "Continue reading",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: "Popular Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "bypopularity",
              ),
            ),
            TrackLibrarySection(
              name: "Top Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manga",
              ),
            ),
            TrackLibrarySection(
              name: "Top Manhwa",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manhwa",
              ),
            ),
            TrackLibrarySection(
              name: "Top Manhua",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "manhua",
              ),
            ),
          ];
  }

  List<TrackLibrarySection> _sectionsKitsu(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: "Continue watching",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Popular Anime",
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Latest Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "-updatedAt",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Best Rated Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "-averageRating",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: "Continue reading",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: "Popular Manga",
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: "Latest Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "-updatedAt",
              ),
            ),
            TrackLibrarySection(
              name: "Best Rated Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "-averageRating",
              ),
            ),
          ];
  }

  List<TrackLibrarySection> _sectionsAL(int syncId, ItemType itemType) {
    return itemType == ItemType.anime
        ? [
            TrackLibrarySection(
              name: "Continue watching",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Upcoming Anime",
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.anime),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Popular Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "sort: POPULARITY_DESC",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Trending Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType: "sort: TRENDING_DESC",
              ),
              itemType: ItemType.anime,
            ),
            TrackLibrarySection(
              name: "Latest Anime",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.anime,
                rankingType:
                    "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
              ),
              itemType: ItemType.anime,
            ),
          ]
        : [
            TrackLibrarySection(
              name: "Continue reading",
              syncId: syncId,
              func: _fetchUserData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: "Upcoming Manga",
              syncId: syncId,
              func: _fetchGeneralData(syncId, ItemType.manga),
            ),
            TrackLibrarySection(
              name: "Popular Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "sort: POPULARITY_DESC",
              ),
            ),
            TrackLibrarySection(
              name: "Trending Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType: "sort: TRENDING_DESC",
              ),
            ),
            TrackLibrarySection(
              name: "Latest Manga",
              syncId: syncId,
              func: _fetchGeneralData(
                syncId,
                ItemType.manga,
                rankingType:
                    "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
              ),
            ),
          ];
  }

  Future<List<TrackSearch>?> Function() _fetchSearch(
    int syncId,
    String query,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
          ).notifier,
        )
        .search(query);
  }

  Future<List<TrackSearch>?> Function() _fetchGeneralData(
    int syncId,
    ItemType itemType, {
    String? rankingType,
  }) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
          ).notifier,
        )
        .fetchGeneralData(rankingType: rankingType);
  }

  Future<List<TrackSearch>?> Function() _fetchUserData(
    int syncId,
    ItemType itemType,
  ) {
    return () async => await ref
        .read(
          trackStateProvider(
            track: Track(syncId: syncId, status: TrackStatus.completed),
            itemType: itemType,
          ).notifier,
        )
        .fetchUserData();
  }

  void _openSwitchProviderDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.track_library_switch),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _getListile(l10n, TrackerProviders.myAnimeList.syncId),
                _getListile(l10n, TrackerProviders.anilist.syncId),
                _getListile(l10n, TrackerProviders.kitsu.syncId),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSwitchTypeDialog(AppLocalizations l10n, int syncId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.track_library_switch),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _getListile(l10n, syncId, isManga: true),
                _getListile(l10n, syncId, isManga: false),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getListile(AppLocalizations l10n, int syncId, {bool? isManga}) {
    final isLoggedIn = _preferences.any((p) => p.syncId == syncId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: trackInfos(syncId).$3,
          ),
          width: 60,
          height: 70,
          child: isManga == null
              ? Image.asset(trackInfos(syncId).$1, height: 30)
              : Icon(
                  isManga ? Icons.collections_bookmark : Icons.video_collection,
                  size: 30,
                ),
        ),
        title: Text(
          isManga == null
              ? trackInfos(syncId).$2
              : isManga
              ? l10n.manga
              : l10n.anime,
        ),
        enabled: isLoggedIn,
        onTap: () {
          if (isManga == null) {
            context.pop();
            _openSwitchTypeDialog(l10n, syncId);
          } else {
            ref.read(lastTrackerLibraryLocationStateProvider.notifier).set((
              syncId,
              isManga,
            ));
            context.pop();
          }
        },
      ),
    );
  }
}
