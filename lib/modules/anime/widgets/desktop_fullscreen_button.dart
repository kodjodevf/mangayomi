import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shiori/shiori.dart';

Future<void> changeDesktopFullScreen(
  WidgetRef ref,
  void Function(bool) setFullScreenCallback, {
  bool? value,
}) async {
  final isFullScreen = await setFullScreen(value: value);
  ref.read(fullscreenProvider.notifier).state = isFullScreen;
  setFullScreenCallback(isFullScreen);
}

class CustomMaterialDesktopFullscreenButton extends ConsumerStatefulWidget {
  final VideoController controller;
  final void Function(bool) desktopFullScreenPlayer;

  const CustomMaterialDesktopFullscreenButton({
    super.key,
    required this.controller,
    required this.desktopFullScreenPlayer,
  });

  @override
  ConsumerState<CustomMaterialDesktopFullscreenButton> createState() =>
      _CustomMaterialDesktopFullscreenButtonState();
}

class _CustomMaterialDesktopFullscreenButtonState
    extends ConsumerState<CustomMaterialDesktopFullscreenButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(fullscreenProvider);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: ShioriMotion.fast,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _hover
              ? Colors.white.withValues(alpha: Alphas.hairline)
              : Colors.transparent,
        ),
        child: IconButton(
          tooltip: isFullScreen
              ? context.l10n.exit_fullscreen
              : context.l10n.fullscreen,
          icon: isFullScreen
              ? const Icon(Symbols.fullscreen_exit_rounded)
              : const Icon(Symbols.fullscreen_rounded),
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: context.shiori.density.minTarget,
            minHeight: context.shiori.density.minTarget,
          ),
          color: Colors.white,
          onPressed: () async {
            await changeDesktopFullScreen(ref, widget.desktopFullScreenPlayer);
          },
        ),
      ),
    );
  }
}
