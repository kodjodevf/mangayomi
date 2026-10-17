import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class SyncListile extends ConsumerWidget {
  final VoidCallback onTap;
  final int id;
  final SyncPreference preference;
  final String? text;
  final bool enabled;
  const SyncListile({
    super.key,
    required this.onTap,
    required this.id,
    required this.preference,
    this.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLogged = preference.authToken?.isNotEmpty ?? false;
    final l10n = l10nLocalizations(context)!;
    final c = context.shiori.color;
    // The same row as a tracking service: a tile for the service, its name,
    // the server signed in to or Login under it, a check once connected.
    return ShioriListRow(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        child: Container(
          width: context.shiori.scaled(44),
          height: context.shiori.scaled(44),
          color: c.ink3,
          child: Icon(Symbols.dns_rounded, color: c.fgMuted),
        ),
      ),
      title: text ?? l10n.sync_server,
      subtitle: text != null
          ? null
          : (isLogged
                ? ((preference.server ?? '').isEmpty
                      ? l10n.log_out
                      : preference.server)
                : l10n.login),
      dimmed: !enabled,
      trailing: isLogged
          ? Icon(
              Symbols.check_circle_rounded,
              fill: 1,
              color: c.completed.foreground,
            )
          : const Icon(Symbols.chevron_forward_rounded),
      onTap: !enabled
          ? null
          : isLogged
          ? () => showLogOutDialog(
              context,
              serviceName: l10n.sync_server,
              onLogOut: () =>
                  ref.read(synchingProvider(syncId: id).notifier).logout(),
            )
          : onTap,
    );
  }
}
