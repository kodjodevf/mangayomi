import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The library's active filters, said out loud: one chip per filter that is
/// on, a check when it includes, a no-entry sign when it excludes, and a
/// cross that turns it off. A library that looks short is never a mystery.
///
/// Renders nothing while no filter is on.
class ActiveFilterChips extends ConsumerWidget {
  const ActiveFilterChips({
    super.key,
    required this.itemType,
    required this.settings,
  });

  final ItemType itemType;
  final Settings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final anime = itemType == ItemType.anime;

    // The same provider instances the library screen watches (an empty
    // manga list), so clearing one here rebuilds the grid at once.
    const none = <Manga>[];
    final downloaded = mangaFilterDownloadedStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final unread = mangaFilterUnreadStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final started = mangaFilterStartedStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final bookmarked = mangaFilterBookmarkedStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final completed = mangaFilterCompletedStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final tracking = mangaFilterTrackingStateProvider(
      mangaList: none,
      itemType: itemType,
      settings: settings,
    );
    final filters = <(String, int, VoidCallback)>[
      (
        l10n.downloaded,
        ref.watch(downloaded),
        () => ref.read(downloaded.notifier).setType(0),
      ),
      (
        anime ? l10n.unwatched : l10n.unread,
        ref.watch(unread),
        () => ref.read(unread.notifier).setType(0),
      ),
      (
        l10n.started,
        ref.watch(started),
        () => ref.read(started.notifier).setType(0),
      ),
      (
        l10n.bookmarked,
        ref.watch(bookmarked),
        () => ref.read(bookmarked.notifier).setType(0),
      ),
      (
        l10n.completed,
        ref.watch(completed),
        () => ref.read(completed.notifier).setType(0),
      ),
      (
        l10n.tracked,
        ref.watch(tracking),
        () => ref.read(tracking.notifier).setType(0),
      ),
    ].where((f) => f.$2 != 0).toList();

    if (filters.isEmpty) return const SizedBox.shrink();
    final c = context.shiori.color;
    return SizedBox(
      height: context.shiori.density.minTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
        children: [
          for (final (label, value, clear) in filters)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: ShioriSpace.s8),
              child: InputChip(
                avatar: Icon(
                  value == 1 ? Symbols.check_rounded : Symbols.block_rounded,
                  color: value == 1 ? c.accentInk : c.error.foreground,
                ),
                label: Text(label),
                tooltip: value == 1 ? label : '${l10n.excluded}: $label',
                deleteButtonTooltipMessage: l10n.remove_filter,
                onDeleted: clear,
              ),
            ),
        ],
      ),
    );
  }
}
