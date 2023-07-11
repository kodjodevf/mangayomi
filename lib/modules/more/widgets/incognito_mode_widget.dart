import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class IncognitoModeWidget extends ConsumerWidget {
  const IncognitoModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    return ListTileWidget(
      onTap: () {
        if (incognitoMode == true) {
          ref.read(incognitoModeStateProvider.notifier).setIncognitoMode(false);
        } else {
          ref.read(incognitoModeStateProvider.notifier).setIncognitoMode(true);
        }
      },
      icon: CupertinoIcons.eyeglasses,
      subtitle: l10n!.incognito_mode_description,
      title: l10n.incognito_mode,
      trailing: Switch(
        value: incognitoMode,
        onChanged: (value) {
          ref.read(incognitoModeStateProvider.notifier).setIncognitoMode(value);
        },
      ),
    );
  }
}
