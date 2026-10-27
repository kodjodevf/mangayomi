import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/tracker_logo.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';

class ManageTrackersScreen extends StatelessWidget {
  const ManageTrackersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.manage_trackers)),
      body: StreamBuilder<List<TrackPreference>>(
        stream: trackRepository.watchAllWithSyncId(),
        builder: (context, snapshot) {
          final trackers =
              (snapshot.data ?? trackRepository.getAllPreferences())
                  .where((p) => p.syncId != -1)
                  .toList();
          if (trackers.isEmpty) {
            return ShioriEmptyState(
              icon: Symbols.sync_alt_rounded,
              title: l10n.no_tracker_connected,
              message: l10n.no_tracker_connected_message,
              actionLabel: l10n.tracking,
              onAction: () => context.push('/track'),
            );
          }
          return ListView(
            padding: tvPageInsets,
            children: [
              for (final pref in trackers)
                ShioriListRow(
                  // Each service's own colour behind its logo, as in the
                  // tracker's own apps.
                  leading: TrackerLogo(syncId: pref.syncId!),
                  title: trackInfos(pref.syncId!).$2,
                  subtitle: [
                    ?pref.accountLabel,
                    l10n.n_tracked(trackRepository.countBySyncId(pref.syncId!)),
                  ].join(' · '),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: ShioriSpace.s8,
                    children: [
                      if (pref.accountLabel != null)
                        TrackerAccountAvatar(preference: pref, radius: 12),
                      const Icon(Symbols.chevron_forward_rounded),
                    ],
                  ),
                  onTap: () => context.push('/trackingDetail', extra: pref),
                ),
            ],
          );
        },
      ),
    );
  }
}
