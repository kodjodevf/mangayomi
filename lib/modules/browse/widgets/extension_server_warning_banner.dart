import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Says, on desktop, that Mihon extensions need the extension server, and
/// leads to it; in the offline tone, the one for "something is missing".
class ExtensionServerWarningBanner extends ConsumerWidget {
  const ExtensionServerWarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isDesktop) return const SizedBox.shrink();

    final installedAsync = ref.watch(isExtensionServerInstalledStreamProvider);

    return installedAsync.when(
      data: (isInstalled) {
        if (isInstalled) return const SizedBox.shrink();

        final l10n = context.l10n;
        final tokens = context.shiori;
        final tone = tokens.color.offline;
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: ShioriSpace.s12,
            vertical: ShioriSpace.s8,
          ),
          padding: const EdgeInsets.all(ShioriSpace.s12),
          decoration: BoxDecoration(
            color: tone.background,
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          child: Row(
            spacing: ShioriSpace.s12,
            children: [
              Icon(
                Symbols.warning_rounded,
                fill: 1,
                color: tone.foreground,
                size: tokens.scaled(24),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: ShioriSpace.s4,
                  children: [
                    Text(
                      l10n.android_proxy_server_mihon,
                      style: tokens.text.row.copyWith(
                        color: tokens.color.fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      l10n.extension_server_intro_with_jre,
                      style: tokens.caption,
                    ),
                  ],
                ),
              ),
              ShioriButton(
                icon: Symbols.download_rounded,
                label: l10n.download,
                onPressed: () => context.push('/extensionServer'),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
