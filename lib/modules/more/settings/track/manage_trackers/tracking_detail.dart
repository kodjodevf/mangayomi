import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackingDetail extends StatefulWidget {
  final TrackPreference trackerPref;
  const TrackingDetail({super.key, required this.trackerPref});

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail>
    with TickerProviderStateMixin {
  late TabController _tabBarController;
  @override
  void initState() {
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.animateTo(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(widget.trackerPref.syncId == -1
              ? 'Local'
              : trackInfos(widget.trackerPref.syncId!).$2),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: [
              Tab(text: l10n.manga),
              Tab(text: l10n.anime),
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          TrackingTab(
              itemType: ItemType.manga, syncId: widget.trackerPref.syncId!),
          TrackingTab(
              itemType: ItemType.anime, syncId: widget.trackerPref.syncId!)
        ]),
      ),
    );
  }
}

class TrackingTab extends StatelessWidget {
  final ItemType itemType;
  final int syncId;
  const TrackingTab({super.key, required this.itemType, required this.syncId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: isar.tracks
            .filter()
            .idIsNotNull()
            .itemTypeEqualTo(itemType)
            .syncIdEqualTo(syncId)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
          final mediaIds = trackRes!.map((e) => e.mediaId).toSet().toList();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: mediaIds.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final mediaId = mediaIds[index];
                final track = trackRes
                    .firstWhere((element) => element.mediaId == mediaId);
                return ExpansionTile(
                  title: Text(track.title!),
                  children: [
                    TrackingWidget(
                        itemType: itemType, syncId: syncId, mediaId: mediaId!)
                  ],
                );
              },
              separatorBuilder: (_, index) {
                return const Divider();
              },
            ),
          );
        });
  }
}

class TrackingWidget extends StatelessWidget {
  final int syncId;
  final ItemType itemType;
  final int mediaId;
  const TrackingWidget(
      {super.key,
      required this.mediaId,
      required this.itemType,
      required this.syncId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: isar.tracks
            .filter()
            .idIsNotNull()
            .mediaIdEqualTo(mediaId)
            .itemTypeEqualTo(itemType)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          List<Track>? trackRes = [];
          List<Track> res = snapshot.data ?? [];
          for (var track in res) {
            if (!trackRes
                .map((e) => e.mediaId)
                .toList()
                .contains(track.mediaId)) {
              trackRes.add(track);
            }
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: trackRes.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final track = trackRes[index];
                return TrackerWidget(
                  mangaId: track.mangaId!,
                  syncId: track.syncId!,
                  trackRes: track,
                  itemType: itemType,
                  hide: true,
                );
              },
              separatorBuilder: (_, index) {
                return const Divider();
              },
            ),
          );
        });
  }
}
