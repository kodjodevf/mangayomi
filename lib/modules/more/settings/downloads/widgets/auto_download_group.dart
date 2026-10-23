import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:shiori/shiori.dart';

/// Downloads that start on their own: the new chapters a library update
/// finds, and the chapters after the one being read.
class AutoDownloadGroup extends ConsumerWidget {
  const AutoDownloadGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final downloadNew = ref.watch(downloadNewChaptersStateProvider);
    final included = ref.watch(downloadNewChaptersCategoriesStateProvider);
    final excluded = ref.watch(
      downloadNewChaptersExcludedCategoriesStateProvider,
    );
    final ahead = ref.watch(downloadAheadWhileReadingStateProvider);
    final categories = categoryRepository.getAll()
      ..sort((a, b) {
        final byType = a.forItemType.index.compareTo(b.forItemType.index);
        return byType != 0 ? byType : (a.pos ?? 0).compareTo(b.pos ?? 0);
      });
    return ShioriSettingsGroup(
      title: l10n.auto_download,
      children: [
        ShioriSwitchRow(
          title: l10n.download_new_chapters,
          subtitle: l10n.download_new_chapters_subtitle,
          value: downloadNew,
          onChanged: (v) =>
              ref.read(downloadNewChaptersStateProvider.notifier).set(v),
        ),
        if (downloadNew && categories.isNotEmpty) ...[
          _CategoriesRow(
            title: l10n.download_new_chapters_included,
            categories: categories,
            selected: included,
            emptyLabel: l10n.download_new_chapters_all_categories,
            onChanged: (ids) => ref
                .read(downloadNewChaptersCategoriesStateProvider.notifier)
                .set(ids),
          ),
          _CategoriesRow(
            title: l10n.download_new_chapters_excluded,
            categories: categories,
            selected: excluded,
            emptyLabel: l10n.library_update_restrictions_none,
            onChanged: (ids) => ref
                .read(
                  downloadNewChaptersExcludedCategoriesStateProvider.notifier,
                )
                .set(ids),
          ),
        ],
        ShioriValueRow<int>(
          title: l10n.download_ahead,
          description: ahead == 0 ? l10n.download_ahead_subtitle : null,
          value: ahead,
          options: [
            for (final n in downloadAheadCounts)
              ShioriChoice(n, n == 0 ? l10n.off : l10n.download_ahead_count(n)),
          ],
          onChanged: (v) =>
              ref.read(downloadAheadWhileReadingStateProvider.notifier).set(v),
        ),
      ],
    );
  }
}

/// The chapters Download ahead can be set to; 0 is off.
const downloadAheadCounts = [0, 2, 3, 5, 10];

/// A set of categories picked in a sheet, every media type together.
class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow({
    required this.title,
    required this.categories,
    required this.selected,
    required this.emptyLabel,
    required this.onChanged,
  });

  final String title;
  final List<Category> categories;
  final List<int> selected;
  final String emptyLabel;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String typeOf(Category c) => switch (c.forItemType) {
      ItemType.manga => l10n.manga,
      ItemType.anime => l10n.anime,
      ItemType.novel => l10n.novel,
    };
    // A category deleted since it was picked is not listed.
    final names = [
      for (final c in categories)
        if (selected.contains(c.id)) c.name ?? '',
    ];
    return ShioriSettingRow(
      title: title,
      subtitle: names.isEmpty ? emptyLabel : names.join(', '),
      onTap: () async {
        final picked = await showShioriMultiChoice<int>(
          context,
          title: title,
          selected: selected.toSet(),
          options: [
            for (final c in categories)
              ShioriChoice(c.id!, c.name ?? '', subtitle: typeOf(c)),
          ],
        );
        if (picked != null) onChanged(picked.toList());
      },
    );
  }
}
