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

class ManageTrackersScreen extends StatefulWidget {
  const ManageTrackersScreen({super.key});

  @override
  State<ManageTrackersScreen> createState() => _ManageTrackersScreenState();
}

class _ManageTrackersScreenState extends State<ManageTrackersScreen> {
  late List<TrackPreference> trackPreferences = [];
  @override
  void initState() {
    super.initState();
    trackPreferences = trackRepository.getAllPreferences();
    // trackPreferences.insert(0, TrackPreference(syncId: -1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trackers = trackPreferences.where((p) => p.syncId != -1).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.manage_trackers)),
      body: trackers.isEmpty
          ? ShioriEmptyState(
              icon: Symbols.sync_alt_rounded,
              title: l10n.no_tracker_connected,
              message: l10n.no_tracker_connected_message,
              actionLabel: l10n.tracking,
              onAction: () => context.push('/track'),
            )
          : ListView(
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
                      l10n.n_tracked(
                        trackRepository.countBySyncId(pref.syncId!),
                      ),
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
            ),
    );
  }
}
