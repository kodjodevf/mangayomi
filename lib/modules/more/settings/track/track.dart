import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_listile.dart';
import 'package:mangayomi/services/myanimelist.dart';

class TrackScreen extends ConsumerWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking"),
      ),
      body: StreamBuilder(
          stream: isar.trackPreferences
              .filter()
              .syncIdIsNotNull()
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            List<TrackPreference>? entries =
                snapshot.hasData ? snapshot.data : [];
            return Column(
              children: [
                TrackListile(
                    onTap: () async {
                      await ref
                          .read(myAnimeListProvider(syncId: 1).notifier)
                          .login();
                    },
                    id: 1,
                    entries: entries!)
              ],
            );
          }),
    );
  }
}
