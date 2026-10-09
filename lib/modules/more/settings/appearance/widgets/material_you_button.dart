import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/dynamic_color_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/material_you_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MaterialYouButton extends ConsumerWidget {
  const MaterialYouButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMaterialYou = ref.watch(materialYouStateProvider);
    final isSupported = ref.watch(dynamicColorAvailableProvider);
    final l10n = l10nLocalizations(context);

    final String statusText;
    if (!isSupported) {
      statusText = l10n?.not_supported_on_this_device ?? 'Not supported on this device';
    } else {
      statusText = useMaterialYou ? (l10n?.on ?? 'On') : (l10n?.off ?? 'Off');
    }

    return SwitchListTile(
      title: Text(l10n?.material_you ?? 'Material You'),
      subtitle: Text(
        statusText,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      value: isSupported ? useMaterialYou : false,
      onChanged: isSupported
          ? (value) {
              ref.read(materialYouStateProvider.notifier).set(value);
            }
          : null,
    );
  }
}
