import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ManageTrackersScreen extends StatefulWidget {
  const ManageTrackersScreen({super.key});

  @override
  State<ManageTrackersScreen> createState() => _ManageTrackersScreenState();
}

class _ManageTrackersScreenState extends State<ManageTrackersScreen> {
  late List<TrackPreference> trackPreferences = [];
  @override
  void initState() {
    trackPreferences =
        isar.trackPreferences.filter().syncIdIsNotNull().findAllSync();
    // trackPreferences.insert(0, TrackPreference(syncId: -1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.manage_trackers)),
      body: GridViewWidget(
          childAspectRatio: 0.69,
          itemCount: trackPreferences.length,
          itemBuilder: (context, index) {
            final trackerPref = trackPreferences[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  context.push('/trackingDetail', extra: trackerPref);
                },
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                          decoration: BoxDecoration(
                              color: trackerPref.syncId == -1
                                  ? Colors.grey
                                  : trackInfos(trackerPref.syncId!).$3,
                              borderRadius: BorderRadius.circular(10)),
                          child: trackerPref.syncId == -1
                              ? SizedBox(
                                  width: context.mediaWidth(1),
                                  child: const Icon(Icons.local_library_rounded,
                                      size: 60))
                              : Image.asset(
                                  trackInfos(trackerPref.syncId!).$1)),
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          trackerPref.syncId == -1
                              ? 'Local'
                              : trackInfos(trackerPref.syncId!).$2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19)),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
