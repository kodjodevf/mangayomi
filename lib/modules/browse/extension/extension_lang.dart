import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_lang_list_tile_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ExtensionsLang extends ConsumerWidget {
  final ItemType itemType;
  const ExtensionsLang({required this.itemType, super.key});

  /// Turns every source of this kind on or off.
  void _setAll(bool enable) {
    final sources = sourceRepository.getByItemType(itemType);
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var source in sources) {
      source
        ..isActive = enable
        ..updatedAt = now;
    }
    sourceRepository.putAll(sources);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extensions),
        actions: [
          ShioriMenuButton(
            tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
            items: [
              ShioriMenuItem(
                label: l10n.enable_all,
                icon: Symbols.check_box_rounded,
                onSelected: () => _setAll(true),
              ),
              ShioriMenuItem(
                label: l10n.disable_all,
                icon: Symbols.check_box_outline_blank_rounded,
                onSelected: () => _setAll(false),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: sourceRepository.watchByItemType(itemType),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const ShioriLoading();
          final List<Source> entries = snapshot.data!;
          final languages = entries.map((e) => e.lang!).toSet().toList();
          if (languages.isEmpty) {
            return ShioriEmptyState(
              icon: Symbols.translate_rounded,
              title: l10n.no_result,
              compact: true,
            );
          }

          languages.sort((a, b) => a.compareTo(b));
          return SuperListView.builder(
            padding: tvPageInsets,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return ExtensionLangListTileWidget(
                lang: lang,
                onChanged: (val) {
                  final now = DateTime.now().millisecondsSinceEpoch;
                  final toUpdate = entries
                      .where(
                        (source) =>
                            source.lang!.toLowerCase() == lang.toLowerCase(),
                      )
                      .map(
                        (source) => source
                          ..isActive = val
                          ..updatedAt = now,
                      )
                      .toList();
                  sourceRepository.putAll(toUpdate);
                },
                value: entries
                    .where(
                      (element) =>
                          element.lang!.toLowerCase() == lang.toLowerCase() &&
                          element.isActive!,
                    )
                    .isNotEmpty,
              );
            },
          );
        },
      ),
    );
  }
}
