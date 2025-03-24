import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';

class FollowSystemThemeButton extends ConsumerStatefulWidget {
  const FollowSystemThemeButton({super.key});

  @override
  ConsumerState<FollowSystemThemeButton> createState() => _FollowSystemThemeButtonState();
}

class _FollowSystemThemeButtonState extends ConsumerState<FollowSystemThemeButton> {
  @override
  Widget build(BuildContext context) {
    bool isFollow = ref.watch(followSystemThemeStateProvider);
    final l10n = l10nLocalizations(context);
    return SwitchListTile(
      onChanged: (value) {
        ref.read(followSystemThemeStateProvider.notifier).set(value);
      },
      title: Text(l10n!.follow_system_theme),
      subtitle: Text(
        !isFollow ? l10n.off : l10n.on,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      value: isFollow,
    );
  }
}
