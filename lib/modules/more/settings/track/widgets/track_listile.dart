import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/modules/widgets/tracker_account_avatar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/widgets/tracker_logo.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackListile extends ConsumerWidget {
  final VoidCallback onTap;
  final int id;
  final List<TrackPreference> entries;
  final String? text;
  const TrackListile({
    super.key,
    required this.onTap,
    required this.id,
    required this.entries,
    this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.shiori.color;
    final preference = entries.where((e) => e.syncId == id).firstOrNull;
    final isLogged = preference != null;
    return ShioriListRow(
      leading: TrackerLogo(syncId: id),
      title: text ?? trackInfos(id).$2,
      // Who is signed in, or what a tap does.
      subtitle: text != null
          ? null
          : (isLogged ? (preference.accountLabel ?? l10n.log_out) : l10n.login),
      trailing: isLogged
          ? Icon(
              Symbols.check_circle_rounded,
              fill: 1,
              color: c.completed.foreground,
            )
          : const Icon(Symbols.chevron_forward_rounded),
      onTap: isLogged
          ? () => showLogOutDialog(
              context,
              serviceName: trackInfos(id).$2,
              onLogOut: () =>
                  ref.read(tracksProvider(syncId: id).notifier).logout(),
            )
          : onTap,
    );
  }
}
