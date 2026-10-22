import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

Future<void> showSavedSearchesSheet({
  required BuildContext context,
  required Source source,
  required ValueChanged<String> onSelect,
}) {
  return showShioriSheet<void>(
    context,
    title: context.l10n.saved_searches,
    builder: (ctx) => Consumer(
      builder: (ctx, ref, _) {
        final saved =
            ref.watch(savedSearchesProvider)[source.id] ??
            const <SavedSearch>[];
        if (saved.isEmpty) {
          return ShioriEmptyState(
            icon: Symbols.bookmark_rounded,
            title: context.l10n.no_saved_searches,
            compact: true,
          );
        }
        return ListView(
          shrinkWrap: true,
          children: [
            for (final s in saved)
              ShioriListRow(
                leading: const Icon(Symbols.bookmark_rounded),
                title: s.name,
                subtitle: s.query,
                onTap: () {
                  Navigator.pop(ctx);
                  onSelect(s.query);
                },
                trailing: IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .deleteButtonTooltip,
                  icon: const Icon(Symbols.delete_rounded),
                  onPressed: () => ref
                      .read(savedSearchesProvider.notifier)
                      .remove(source.id!, s.name),
                ),
              ),
          ],
        );
      },
    ),
  );
}

Future<void> showSaveSearchPrompt({
  required BuildContext context,
  required WidgetRef ref,
  required Source source,
  required String query,
}) async {
  if (query.trim().isEmpty) {
    botToast(context.l10n.enter_search_to_save_first);
    return;
  }
  final name = await showShioriPrompt(
    context,
    title: context.l10n.save_search,
    label: context.l10n.name,
    confirmLabel: context.l10n.save,
    initialValue: query,
  );
  if (name == null) return;
  ref.read(savedSearchesProvider.notifier).add(source.id!, name, query);
}
