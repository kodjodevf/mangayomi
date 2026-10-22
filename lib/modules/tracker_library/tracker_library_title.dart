import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:shiori/shiori.dart';

/// The app bar title for a tracker's library: the service and item type, with
/// the account underneath it.
///
/// Watches the preference rather than reading it once, so signing out drops
/// the account from the title instead of leaving a stale name above an empty
/// list.
class TrackerLibraryTitle extends ConsumerWidget {
  const TrackerLibraryTitle({
    super.key,
    required this.text,
    required this.syncId,
  });

  final String text;
  final int syncId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(tracksProvider(syncId: syncId));
    final label = preference?.accountLabel;

    if (preference == null || label == null) return Text(text);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TrackerAccountAvatar(preference: preference, radius: 14),
        const SizedBox(width: ShioriSpace.s12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, overflow: TextOverflow.ellipsis),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: context.shiori.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
