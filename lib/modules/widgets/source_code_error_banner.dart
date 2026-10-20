import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/source_code_errors.dart';
import 'package:shiori/shiori.dart';

/// In developer mode, what failed when [source]'s code was run, on the page
/// itself: which call, the error and its stack, to copy or to fix in the
/// code editor straight away, rather than leaving to read the logs and
/// coming back. Readers, outside developer mode, see nothing: the screen
/// has fallen back and goes on.
class SourceCodeErrorBanner extends ConsumerWidget {
  const SourceCodeErrorBanner({super.key, required this.source});

  final Source source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(developerModeStateProvider)) return const SizedBox.shrink();
    return ValueListenableBuilder<Map<int, SourceCodeError>>(
      valueListenable: SourceCodeErrors.notifier,
      builder: (context, errors, _) {
        final error = errors[source.id];
        if (error == null) return const SizedBox.shrink();
        return _Banner(source: source, error: error);
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.source, required this.error});

  final Source source;
  final SourceCodeError error;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final fg = scheme.onErrorContainer;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s12,
        ShioriSpace.s8,
        ShioriSpace.s12,
        ShioriSpace.s4,
      ),
      child: Material(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s12,
            ShioriSpace.s12,
            ShioriSpace.s4,
            ShioriSpace.s4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: ShioriSpace.s8,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: ShioriSpace.s8,
                children: [
                  Icon(Symbols.code_off_rounded, color: fg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.source_code_error_title,
                          style: tokens.text.row.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.source_code_error_failed(error.what),
                          style: tokens.text.meta.copyWith(color: fg),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.dismiss,
                    color: fg,
                    icon: const Icon(Symbols.close_rounded),
                    onPressed: () => SourceCodeErrors.clear(source.id),
                  ),
                ],
              ),
              // The error first, then where it came from; scrolls when long.
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: tokens.scaled(160)),
                child: SingleChildScrollView(
                  child: SelectableText(
                    '${error.message}\n\n${error.stack}',
                    style: tokens.text.badge.copyWith(
                      color: fg,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: ShioriSpace.s8,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: fg),
                    icon: const Icon(Symbols.content_copy_rounded),
                    label: Text(l10n.copy_error),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: error.toString()),
                      );
                      botToast(l10n.error_copied, second: 2);
                    },
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: fg),
                    icon: const Icon(Symbols.code_rounded),
                    label: Text(l10n.edit_code),
                    onPressed: () =>
                        context.push('/codeEditor', extra: source.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
