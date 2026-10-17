import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_destination_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/language.dart';

class MassMigrationPreviewScreen extends StatefulWidget {
  const MassMigrationPreviewScreen({required this.sourceGroup, super.key});

  final MassMigrationSourceGroup sourceGroup;

  @override
  State<MassMigrationPreviewScreen> createState() =>
      _MassMigrationPreviewScreenState();
}

class _MassMigrationPreviewScreenState
    extends State<MassMigrationPreviewScreen> {
  // Indices of the entries that will actually be migrated. Everything starts
  // selected (previous behaviour was "migrate the whole group"), and the user
  // can trim it down.
  late final Set<int> _selected = {
    for (var i = 0; i < widget.sourceGroup.items.length; i++) i,
  };

  // Anchor for range selection: long-pressing an entry selects everything
  // between the last tapped entry and it (inclusive).
  int? _anchor;

  void _toggle(int index) {
    setState(() {
      if (!_selected.remove(index)) _selected.add(index);
      _anchor = index;
    });
  }

  void _selectRange(int index) {
    final anchor = _anchor;
    if (anchor == null) {
      _toggle(index);
      return;
    }
    setState(() {
      final start = anchor < index ? anchor : index;
      final end = anchor < index ? index : anchor;
      for (var i = start; i <= end; i++) {
        _selected.add(i);
      }
      _anchor = index;
    });
  }

  void _setAll(bool selectAll) {
    setState(() {
      _selected.clear();
      if (selectAll) {
        _selected.addAll([
          for (var i = 0; i < widget.sourceGroup.items.length; i++) i,
        ]);
      }
      _anchor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceGroup = widget.sourceGroup;
    final total = sourceGroup.items.length;
    final allSelected = _selected.length == total;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mass_migration_preview_items),
        actions: [
          IconButton(
            tooltip: allSelected
                ? l10n.deselect_all
                : MaterialLocalizations.of(context).selectAllButtonLabel,
            onPressed: total == 0 ? null : () => _setAll(!allSelected),
            icon: Icon(
              allSelected
                  ? Symbols.deselect_rounded
                  : Symbols.select_all_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: MassMigrationSourceIcon(source: sourceGroup.source),
            title: Text(sourceGroup.sourceName),
            subtitle: Text(
              [
                if ((sourceGroup.lang ?? '').isNotEmpty)
                  languageName(context, sourceGroup.lang!),
                l10n.n_selected(_selected.length),
              ].join(' · '),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: sourceGroup.items.length,
              itemBuilder: (context, index) {
                final manga = sourceGroup.items[index];
                final selected = _selected.contains(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ShioriSpace.s12,
                    vertical: ShioriSpace.s4,
                  ),
                  child: Card(
                    color: selected
                        ? context.shiori.color.accent.withValues(
                            alpha: Alphas.accentTint,
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(ShioriSpace.s12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tap the header row to toggle; long-press to select a
                          // range from the last tapped entry. The chapter
                          // expander below stays independently tappable.
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _toggle(index),
                            onLongPress: () => _selectRange(index),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  child: Checkbox(
                                    value: selected,
                                    onChanged: (_) {},
                                  ),
                                ),
                                const SizedBox(width: ShioriSpace.s4),
                                MassMigrationCover(
                                  libraryItem: manga,
                                  source: sourceGroup.source,
                                ),
                                const SizedBox(width: ShioriSpace.s12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        manga.name ??
                                            l10n.mass_migration_unknown_title,
                                        style: context.shiori.text.row.copyWith(
                                          color: context.shiori.color.fg,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: ShioriSpace.s4),
                                      Text(
                                        [
                                          if ((manga.author ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            manga.author!,
                                          if ((manga.artist ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            manga.artist!,
                                          l10n.mass_migration_chapter_count(
                                            manga.chapters.length,
                                          ),
                                        ].join(' · '),
                                        style: context.shiori.caption,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: ShioriSpace.s8),
                          MassMigrationChapterSection(
                            title: l10n.mass_migration_source_chapters,
                            chapters: manga.chapters
                                .map(
                                  (chapter) =>
                                      chapter.name ??
                                      l10n.mass_migration_unknown_chapter,
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ShioriSpace.s16),
            child: SizedBox(
              width: double.infinity,
              child: ShioriButton(
                expand: true,
                label: l10n.mass_migration_select_destination_source,
                onPressed: _selected.isEmpty
                    ? null
                    : () {
                        final selectedItems = [
                          for (var i = 0; i < sourceGroup.items.length; i++)
                            if (_selected.contains(i)) sourceGroup.items[i],
                        ];
                        final filtered = MassMigrationSourceGroup(
                          sourceName: sourceGroup.sourceName,
                          itemType: sourceGroup.itemType,
                          items: selectedItems,
                          source: sourceGroup.source,
                          lang: sourceGroup.lang,
                          sourceId: sourceGroup.sourceId,
                        );
                        Navigator.push(
                          context,
                          createRoute(
                            page: MassMigrationDestinationScreen(
                              sourceGroup: filtered,
                            ),
                          ),
                        );
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
