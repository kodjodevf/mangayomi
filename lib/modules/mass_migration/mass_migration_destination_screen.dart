import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_runner_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MassMigrationDestinationScreen extends ConsumerWidget {
  const MassMigrationDestinationScreen({required this.sourceGroup, super.key});

  final MassMigrationSourceGroup sourceGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sources = buildMassMigrationDestinationSources(
      sourceGroup: sourceGroup,
      showNSFW: ref.watch(showNSFWStateProvider),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mass_migration_destination_source)),
      body: sources.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.mass_migration_no_destination_sources),
              ),
            )
          : ListView.separated(
              padding: tvPageInsets,
              itemCount: sources.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final source = sources[index];
                return _DestinationSourceTile(
                  autofocus: index == 0,
                  source: source,
                  onTap: () {
                    Navigator.push(
                      context,
                      createRoute(
                        page: MassMigrationRunnerScreen(
                          sourceGroup: sourceGroup,
                          destinationSource: source,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _DestinationSourceTile extends StatelessWidget {
  const _DestinationSourceTile({
    required this.source,
    required this.onTap,
    this.autofocus = false,
  });

  final Source source;
  final VoidCallback onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tile = ListTile(
      leading: MassMigrationSourceIcon(source: source),
      title: Text(source.name ?? l10n.mass_migration_unknown_source),
      subtitle: Text(
        [
          if ((source.lang ?? '').isNotEmpty)
            completeLanguageName(source.lang!),
          l10n.mass_migration_installed,
        ].join(' • '),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
    if (isTv) {
      return TvListRow(
        children: [
          Expanded(
            child: TvRowButton(autofocus: autofocus, onTap: onTap, child: tile),
          ),
        ],
      );
    }
    return ListTile(
      leading: tile.leading,
      title: tile.title,
      subtitle: tile.subtitle,
      trailing: tile.trailing,
      onTap: onTap,
    );
  }
}
