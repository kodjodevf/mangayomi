import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Shiori settings group for iOS zero-interpreter runtime control.
class IosRuntimeGroup extends ConsumerWidget {
  const IosRuntimeGroup({
    super.key,
    required this.runtimeRunning,
    required this.runtimeBusy,
    required this.onToggleRuntime,
  });

  final bool runtimeRunning;
  final bool runtimeBusy;
  final VoidCallback onToggleRuntime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final autoStartServer = ref.watch(
      autoStartExtensionServerOnLaunchStateProvider,
    );

    return ShioriSettingsGroup(
      title: l10n.zero_interpreter,
      footer: l10n.zero_interpreter_description,
      children: [
        ShioriSwitchRow(
          title: l10n.start_server_on_launch,
          value: autoStartServer,
          onChanged: ref
              .read(autoStartExtensionServerOnLaunchStateProvider.notifier)
              .set,
        ),
        ShioriSettingRow(
          icon: runtimeRunning
              ? Symbols.stop_circle_rounded
              : Symbols.play_circle_rounded,
          title: runtimeRunning ? l10n.stop : l10n.start,
          subtitle:
              '${l10n.runtime_status} · ${runtimeRunning ? l10n.running : l10n.stopped}',
          enabled: !runtimeBusy,
          onTap: onToggleRuntime,
        ),
      ],
    );
  }
}
