import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          width: 60,
          height: 70,
          child: Icon(
            Icons.dns_outlined,
            size: 30,
            color: context.secondaryColor,
          ),
        ),
        trailing: (isLogged
            ? const Icon(Icons.check, size: 30, color: Colors.green)
            : null),
        enabled: enabled,
        onTap: isLogged
            ? () => showLogOutDialog(
                context,
                serviceName: l10n.sync_server,
                onLogOut: () =>
                    ref.read(synchingProvider(syncId: id).notifier).logout(),
              )
            : onTap,
        title: Text(
          text ?? l10n.sync_server,
          style: TextStyle(fontSize: text != null ? 13 : null),
        ),
      ),
    );
  }
}
